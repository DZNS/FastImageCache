//
//  DZFiCOperation.m
//  FastImageCacheDemo
//
//  Created by Nikhil Nigade on 4/3/15.
//  Copyright (c) 2015 Path. All rights reserved.
//

#import "DZFICOperation.h"
#import "DZFICCategories.h"

@interface DZFICOperation ()

@property (nonatomic, strong) NSURLSessionDownloadTask *task;

@end

@implementation DZFICOperation

- (BOOL)isAsynchronous
{
    return YES;
}

- (void)main
{
    
    if(self.isCancelled) return;
    
    // We either don't have the sourceURL so we definitely can't continue;
    // Or, we don't have a callback. There's no point in executing further
    // as no one is there to receive the image.
    if(!self.sourceURL || !self.sourceBlock) return;
    
    NSString *tempPath = [[@"~/tmp" stringByExpandingTildeInPath] stringByAppendingPathComponent:[self.sourceURL lastPathComponent]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:tempPath])
    {
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:tempPath];
        
        if(self.sourceBlock) self.sourceBlock(image);
        
        return;
        
    }
    
    self.task = [[NSURLSession sharedSession] downloadTaskWithURL:self.sourceURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        if(self.isCancelled) return;
        
        if(error)
        {
            NSLog(@"%@ (%@ @ %@) : %@", NSStringFromClass([self class]), @(__LINE__), NSStringFromSelector(_cmd), [error localizedDescription]);
            return;
        }
        
        if(self.isCancelled) return;
        
        if(!self.followRedirects)
        {
            
            //Ensure that the sourceURL is the same as the request's URL.
            if(![[[self.task.originalRequest URL] absoluteString] isEqualToString:[[self.task.currentRequest URL] absoluteString]])
            {
                
                if(self.sourceBlock)
                {
                    self.sourceBlock(nil);
                }
                
                return;
                
            }
            
        }
        
        if([[NSFileManager defaultManager] fileExistsAtPath:tempPath] || [[NSFileManager defaultManager] moveItemAtPath:[location path] toPath:tempPath error:nil])
        {
            
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:tempPath];
            
            if(self.sourceBlock) self.sourceBlock(image);
            
        }
        
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [self.task resume];
        
    });
    
}

- (void)cancel
{
    
    if(self.isCancelled) return;
    
    [self.task cancel];
    
    [super cancel];
    
}

@end
