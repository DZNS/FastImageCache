//
//  DZFiCOperation.m
//  FastImageCacheDemo
//
//  Created by Nikhil Nigade on 4/3/15.
//  Copyright (c) 2015 Path. All rights reserved.
//

#import "DZFICOperation.h"
#import "DZCategories.h"

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
    
    self.task = [[NSURLSession sharedSession] downloadTaskWithURL:self.sourceURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        if(self.isCancelled) return;
        
        if(error)
        {
            NSLog(@"%@ (%@ @ %@) : %@", NSStringFromClass([self class]), @(__LINE__), NSStringFromSelector(_cmd), [error localizedDescription]);
            return;
        }
        
        NSString *tempPath = [[@"~/tmp" stringByExpandingTildeInPath] stringByAppendingPathComponent:[self.sourceURL lastPathComponent]];
        
        if(self.isCancelled) return;
        
        if([[NSFileManager defaultManager] fileExistsAtPath:tempPath] || [[NSFileManager defaultManager] moveItemAtPath:[location path] toPath:tempPath error:nil])
        {
            
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:tempPath];
            
            if(self.sourceBlock) self.sourceBlock(image);
            
        }
        
    }];
    
    [self.task resume];
    
}

- (void)cancel
{
    
    if(self.isCancelled) return;
    
    [self.task cancel];
    
    [super cancel];
    
}

@end
