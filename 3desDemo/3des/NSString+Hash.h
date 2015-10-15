//
//  NSString+Hash.m
//  mPOS
//
//  Created by 德益富 on 15/5/15.
//  Copyright (c) 2015年 Dyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Hash)
//3des
+ (NSString*)encrypt3DES:(NSString*)plainText withKey:(NSString*)key;
+ (NSString*)decrypt3DES:(NSString*)plainText withKey:(NSString*)key;

@end
