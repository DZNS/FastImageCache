//
//  DZCategories.m
//  FastImageCacheDemo
//
//  Created by Nikhil Nigade on 4/3/15.
//  Copyright (c) 2015 Path. All rights reserved.
//

#import "DZCategories.h"

@implementation NSString (DZCategories)

-(BOOL)isBlank
{
    return [[self stringByStrippingWhitespace] isEqualToString:@""];
}

-(NSString *)stringByStrippingWhitespace
{
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"\n" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@" "];
    
    return [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


@end
