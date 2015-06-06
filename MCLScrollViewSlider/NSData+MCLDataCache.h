//
//  NSData+MCLDataCache.h
//  MCLScrollViewSlider
//
//  Created by MC Lee on 15/6/4.
//  Copyright (c) 2015年 MCLee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (MCLDataCache)

- (void)saveDataCacheWithIdentifier:(NSString *)identifier;
+ (NSData *)getDataCacheWithIdentifier:(NSString *)identifier;

@end
