//
//  DZFiCOperation.h
//  FastImageCacheDemo
//
//  Created by Nikhil Nigade on 4/3/15.
//  Copyright (c) 2015 Path. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@interface DZFICOperation : NSOperation

@property (nonatomic, copy) NSString *UUID;
@property (nonatomic, copy) NSURL *sourceURL;
@property (nonatomic, copy) NSString *format;
@property (nonatomic, copy) void(^sourceBlock)(UIImage *image);
@property (nonatomic, assign) BOOL followRedirects;

@end
