//
//  NSString+sha256.h
//  daojiajiaoshi
//
//  Created by joy on 9/19/16.
//  Copyright © 2016 Ices. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (sha256)

+ (NSString *)base64StringFromData:(NSData *)theData;

- (NSData *)sha256Data;
- (NSString *)sha256;

@end