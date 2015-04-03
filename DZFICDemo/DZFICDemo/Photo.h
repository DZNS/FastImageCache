//
//  ViewController.m
//  DZFICDemo
//
//  Created by Nikhil Nigade on 4/3/15.
//  Copyright (c) 2015 Dezine Zync Studios LLP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FICEntity.h"

@interface Photo : NSObject <NSCoding, FICEntity>

@property (nonatomic, copy) NSNumber *farm;
@property (nonatomic, copy) NSString *photoID;
@property (nonatomic, copy) NSNumber *isFamily;
@property (nonatomic, copy) NSNumber *isFriend;
@property (nonatomic, copy) NSNumber *isPublic;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, copy) NSString *secret;
@property (nonatomic, copy) NSString *server;
@property (nonatomic, copy) NSString *title;

+ (Photo *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
