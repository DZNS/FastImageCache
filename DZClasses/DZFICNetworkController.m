//
//  DZFICNetworkController.m
//  FastImageCacheDemo
//
//  Created by Nikhil Nigade on 4/3/15.
//  Copyright (c) 2015 Dezine Zync Studios LLP. All rights reserved.
//

#import "DZFICNetworkController.h"
#import "DZFICOperation.h"

#import "DZCategories.h"

@implementation DZFICConfiguration

@end

@interface DZFICNetworkController()

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, copy) instructionBlock instructionBlock;
@property (nonatomic, assign, getter=shouldFollowRedirects) BOOL followRedirects;

@end

@implementation DZFICNetworkController

- (instancetype)init
{
    
    self = [self init];
    
    return self;
    
}

- (instancetype)initWithConfiguration:(DZFICConfiguration *)configuration
{
    
    if(self = [super init])
    {
        
        _queue = [[NSOperationQueue alloc] init];
        _queue.qualityOfService = NSQualityOfServiceUtility;
        _queue.maxConcurrentOperationCount = configuration.maxConcurrentConnections?:20;
        
        if(!configuration.shouldContinueInBackground)
        {
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
            
        }
        
        self.followRedirects = configuration ? configuration.shouldFollowRedirects : YES;
   
    }
    
    return self;
    
}

- (void)cancelAllDownloadOperations
{
    
    [self.queue cancelAllOperations];
    
}

#pragma mark - Notifications

- (void)applicationWillEnterForeground
{
    
    if([self.queue isSuspended]) [self.queue setSuspended:NO];
    
}

- (void)applicationWillResignActive
{
    
    if(![self.queue isSuspended]) [self.queue setSuspended:YES];
    
}

#pragma mark - <FICImageCacheDelegate>

- (void)imageCache:(FICImageCache *)imageCache wantsSourceImageForEntity:(id<FICEntity>)entity
    withFormatName:(NSString *)formatName
   completionBlock:(FICImageRequestCompletionBlock)completionBlock
{
    
    NSURL *URL = [entity sourceImageURLWithFormatName:formatName];
    
    // We don't have a valid URL.
    if(!URL) return;
    
    DZFICOperation *op = [[DZFICOperation alloc] init];
    op.sourceURL = URL;
    op.UUID = [entity UUID];
    op.format = formatName;
    op.followRedirects = [self shouldFollowRedirects];
    op.sourceBlock = ^(UIImage *image) {
        
        if(!image) return;
        
        if(!completionBlock) return;
        
        asyncMain(^{
            
            completionBlock(image);
            
        });
        
    };
    
    [self.queue addOperation:op];
    
}

- (void)imageCache:(FICImageCache *)imageCache cancelImageLoadingForEntity:(id<FICEntity>)entity withFormatName:(NSString *)formatName
{
    
    BOOL stop = NO;
    
    for (DZFICOperation *operation in [self.queue operations]) {
        
        if(stop) break;
        
        // Make sure we pick out the right OP
        if([operation.UUID isEqualToString:[entity UUID]]
           && [[operation sourceURL] isEqual:[entity sourceImageURLWithFormatName:formatName]]
           && [[operation format] isEqualToString:formatName])
        {
            
            //NSLog(@"(Line: %@) %@-%@ : Canceled request for entity: %@", @(__LINE__), NSStringFromClass([self class]), NSStringFromSelector(_cmd), entity);
            
            // If the operation is Executing or not finished (possibly not started yet)
            if(![operation isFinished])
            {
                [operation cancel];
            }
            
            stop = YES;
            
        }
        
    }
    
}

- (BOOL)imageCache:(FICImageCache *)imageCache shouldProcessAllFormatsInFamily:(NSString *)formatFamily forEntity:(id<FICEntity>)entity {
    return NO;
}

- (void)imageCache:(FICImageCache *)imageCache errorDidOccurWithMessage:(NSString *)errorMessage {
    NSLog(@"%@", errorMessage);
}

@end
