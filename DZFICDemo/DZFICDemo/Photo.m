//
//  ViewController.m
//  DZFICDemo
//
//  Created by Nikhil Nigade on 4/3/15.
//  Copyright (c) 2015 Dezine Zync Studios LLP. All rights reserved.
//

#import "Photo.h"
#import "FICUtilities.h"

@interface Photo () {
    NSURL *_sourceImageURL;
    NSString *_UUID, *_sourceImageUUID;
}

@end

@implementation Photo

- (void)encodeWithCoder:(NSCoder *)encoder;
{
    [encoder encodeObject:self.farm forKey:@"farm"];
    [encoder encodeObject:self.photoID forKey:@"photoID"];
    [encoder encodeObject:self.isFamily forKey:@"isFamily"];
    [encoder encodeObject:self.isFriend forKey:@"isFriend"];
    [encoder encodeObject:self.isPublic forKey:@"isPublic"];
    [encoder encodeObject:self.owner forKey:@"owner"];
    [encoder encodeObject:self.secret forKey:@"secret"];
    [encoder encodeObject:self.server forKey:@"server"];
    [encoder encodeObject:self.title forKey:@"title"];
}

- (id)initWithCoder:(NSCoder *)decoder;
{
    if ((self = [super init])) {
        self.farm = [decoder decodeObjectForKey:@"farm"];
        self.photoID = [decoder decodeObjectForKey:@"photoID"];
        self.isFamily = [decoder decodeObjectForKey:@"isFamily"];
        self.isFriend = [decoder decodeObjectForKey:@"isFriend"];
        self.isPublic = [decoder decodeObjectForKey:@"isPublic"];
        self.owner = [decoder decodeObjectForKey:@"owner"];
        self.secret = [decoder decodeObjectForKey:@"secret"];
        self.server = [decoder decodeObjectForKey:@"server"];
        self.title = [decoder decodeObjectForKey:@"title"];
    }
    return self;
}

+ (Photo *)instanceFromDictionary:(NSDictionary *)aDictionary;
{

    Photo *instance = [[Photo alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
{

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    [self setValuesForKeysWithDictionary:aDictionary];

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
{

    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"photoID"];
    } else if ([key isEqualToString:@"isfamily"]) {
        [self setValue:value forKey:@"isFamily"];
    } else if ([key isEqualToString:@"isfriend"]) {
        [self setValue:value forKey:@"isFriend"];
    } else if ([key isEqualToString:@"ispublic"]) {
        [self setValue:value forKey:@"isPublic"];
    }

}


- (NSDictionary *)dictionaryRepresentation;
{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    if (self.farm) {
        [dictionary setObject:self.farm forKey:@"farm"];
    }

    if (self.photoID) {
        [dictionary setObject:self.photoID forKey:@"photoID"];
    }

    if (self.isFamily) {
        [dictionary setObject:self.isFamily forKey:@"isFamily"];
    }

    if (self.isFriend) {
        [dictionary setObject:self.isFriend forKey:@"isFriend"];
    }

    if (self.isPublic) {
        [dictionary setObject:self.isPublic forKey:@"isPublic"];
    }

    if (self.owner) {
        [dictionary setObject:self.owner forKey:@"owner"];
    }

    if (self.secret) {
        [dictionary setObject:self.secret forKey:@"secret"];
    }

    if (self.server) {
        [dictionary setObject:self.server forKey:@"server"];
    }

    if (self.title) {
        [dictionary setObject:self.title forKey:@"title"];
    }

    return dictionary;

}

- (NSString *)description
{
    
    NSString *desc = [super description];
    
    desc = [NSString stringWithFormat:@"%@ %@", desc, [self dictionaryRepresentation]];
    
    return desc;
    
}

- (NSUInteger)hash
{
    
    __block NSUInteger hash = 0;
    
    [[self dictionaryRepresentation] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        hash += [key hash];
        hash += [obj hash];
        
    }];
    
    return hash;
    
}

#pragma mark - <FICEntity>

- (NSString *)UUID
{
    
    if (!_UUID) {
        
        _UUID = FICStringWithUUIDBytes(FICUUIDBytesWithString(self.photoID));
        
    }
    
    return _UUID;
    
}

- (NSString *)sourceImageUUID
{
    
    if(!_sourceImageUUID)
    {
        
        _sourceImageUUID = FICStringWithUUIDBytes(FICUUIDBytesWithString(self.photoID));
        
    }
    
    return _sourceImageUUID;
    
}

- (NSURL *)sourceImageURLWithFormatName:(NSString *)formatName
{
    
    // This demo always returns the "small" format, regardless of what the formatName speicifes. You shouldn't do this.
    
    if(!_sourceImageURL)
    {
        
        NSString *path = [NSString stringWithFormat:@"https://farm%@.staticflickr.com", self.farm];
        path = [path stringByAppendingPathComponent:self.server];
        path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_m.jpg", self.photoID, self.secret]];
        
        _sourceImageURL = [NSURL URLWithString:path];
        
    }
    
    return _sourceImageURL;
    
}

- (FICEntityImageDrawingBlock)drawingBlockForImage:(UIImage *)image withFormatName:(NSString *)formatName
{
    
    FICEntityImageDrawingBlock drawingBlock = ^(CGContextRef contextRef, CGSize contextSize) {
        
        // Simple drawing
        CGRect contextBounds = CGRectZero;
        contextBounds.size = contextSize;
        CGContextClearRect(contextRef, contextBounds);
        
        UIGraphicsPushContext(contextRef);
        [image drawInRect:contextBounds];
        UIGraphicsPopContext();
        
    };
    
    return drawingBlock;
}

@end
