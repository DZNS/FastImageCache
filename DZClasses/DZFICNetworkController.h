//
//  DZFICNetworkController.h
//  FastImageCacheDemo
//
//  Created by Nikhil Nigade on 4/3/15.
//  Copyright (c) 2015 Dezine Zync Studios LLP. All rights reserved.
//

#warning CURRENTLY UNTESTED. DON'T USE.

#import <Foundation/Foundation.h>
#import "FICImageCache.h"

typedef NSString *(^instructionBlock)(id<FICEntity>);

@interface DZFICConfiguration : NSObject

@property (nonatomic, assign) NSInteger maxConcurrentConnections; // Default: 20.
@property (nonatomic, assign) BOOL shouldContinueInBackground; // Default: NO
@property (nonatomic, copy) instructionBlock instructionBlock; // Not currently used. Ignore.

@end

/**
 DZFICNetworkController is a drop-in Networking Controller that assists with downloading images over the network to be used in tandem with FICImageCache. You don't have to use this class to be able to use FICImageCache. It merely simplifies things if you are required to download images over the network. It is to be assigned as the delegate to the FICImageCache instance.
 */

@interface DZFICNetworkController : NSObject <FICImageCacheDelegate>

/**
 *  Creates an instance of the Networking Controller. Once created, assign it to FICImageCache's delegate. You must store this in a strongly typed property.
 *
 *  @param configuration A DZFICConfiguration object. If you pass nil, the default values will be used instead.
 *
 *  @return a ready to use instance of DZFICNetworkController.
 */
- (instancetype)initWithConfiguration:(DZFICConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

/**
 *  Cancels all download operations, if any, pending and currently downloading. Use with caution.
 */
- (void)cancelAllDownloadOperations;

@end
