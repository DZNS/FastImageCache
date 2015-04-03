//
//  ViewController.m
//  DZFICDemo
//
//  Created by Nikhil Nigade on 4/3/15.
//  Copyright (c) 2015 Dezine Zync Studios LLP. All rights reserved.
//

#import "ViewController.h"
#import "DZCategories.h"
#import "Photo.h"

#import "FICImageCache.h"
#import "DZFICNetworkController.h"

#define kFormatName @"small"

@implementation FlowLayout

- (instancetype)init
{
    
    if(self = [super init])
    {
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width/3;
        width = floor(width);
        
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 1;
        self.itemSize = CGSizeMake(width, width);
    }
    
    return self;
    
}

@end

#define Cell @"cell"

@interface GridCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation GridCell

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if(self = [super initWithFrame:frame])
    {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_imageView];
        
        self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        
    }
    
    return self;
    
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.imageView.image = nil;
}

@end

@interface ViewController()

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) DZFICNetworkController *networkController;

@end

@implementation ViewController

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[GridCell class] forCellWithReuseIdentifier:Cell];
    
    //Network Controller Setup
    _networkController = [[DZFICNetworkController alloc] initWithConfiguration:nil];
    
    // Image Cache Setup
    FICImageFormat *squareImageFormat16BitBGR = [FICImageFormat formatWithName:kFormatName
                                                                        family:@"someFamily"
                                                                     imageSize:[(FlowLayout *)self.collectionView.collectionViewLayout itemSize]
                                                                         style:FICImageFormatStyle32BitBGRA
                                                                  maximumCount:400
                                                                       devices:FICImageFormatDevicePhone|FICImageFormatDevicePad
                                                                protectionMode:FICImageFormatProtectionModeNone];
    
    FICImageCache *cache = [FICImageCache sharedImageCache];
    [cache setFormats:@[squareImageFormat16BitBGR]];
    [cache setDelegate:_networkController];

}

- (void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
    
    [self getData];

}

#pragma mark - <UICollectionViewDatasource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.data ? [self.data count] : 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    GridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Cell forIndexPath:indexPath];
    
    Photo *photo = [self.data objectAtIndex:indexPath.row];
    
    [[FICImageCache sharedImageCache] retrieveImageForEntity:photo withFormatName:kFormatName completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
        
        if(!image)
        {
            NSLog(@"%@ %@", NSStringFromClass([self class]), entity);
            return;
        }
        
        asyncMain(^{
            [cell.imageView setImage:image];
            [cell.imageView setNeedsLayout];
        });
        
    }];
    
    return cell;
    
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    Photo *photo = [self.data objectAtIndex:indexPath.row];
    
    [[FICImageCache sharedImageCache] cancelImageRetrievalForEntity:photo withFormatName:kFormatName];
    
}

#pragma mark - Networking

- (void)getData
{
    
    NSURL *URL = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=4143542731626dd57dc916803c3a08c7&per_page=120&page=1&format=json&nojsoncallback=1"];
    
    NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:URL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
       
        if(error)
        {
            NSLog(@"%@ (%@ @ %@) : %@", NSStringFromClass([self class]), @(__LINE__), NSStringFromSelector(_cmd), [error localizedDescription]);
            return;
        }
        
        NSData *data = [NSData dataWithContentsOfFile:[location path]];
        
        if(!data || ![data length]) return;
        
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if(!responseObject) return;
        
        NSArray *photos = (NSArray *)[[responseObject objectForKey:@"photos"] objectForKey:@"photo"];
        
        if([photos count])
        {
            
            NSMutableArray *processed = [NSMutableArray arrayWithCapacity:[photos count]];
            
            for(id obj in photos)
            {
                
                Photo *photo = [Photo instanceFromDictionary:obj];
                
                if(photo) [processed addObject:photo];
                
            }
            
            self.data = processed;
            
            asyncMain(^{
                
                [self.collectionView reloadData];
                
            });
            
        }
        
    }];
    
    [task resume];
    
}

@end
