//
//  DZFICCategories.h
//  FastImageCacheDemo
//
//  Created by Nikhil Nigade on 4/3/15.
//  Copyright (c) 2015 Path. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef asyncMain

#define asyncMain(block) {\
if([NSThread isMainThread])\
    {\
        block();\
    }\
    else\
    {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }\
};

#endif

#ifndef NS_DESIGNATED_INITIALIZER
    #if __has_attribute(objc_designated_initializer)
        #define NS_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
    #else
        #define NS_DESIGNATED_INITIALIZER
    #endif
#endif

@interface NSString (DZFICCategories)

- (BOOL)isBlank;
- (NSString *)stringByStrippingWhitespace;

@end
