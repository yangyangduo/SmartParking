//
//  NSDictionary+Extension.h
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Utils.h"

@interface NSDictionary (Extension)

- (id)notNSNullObjectForKey:(id)key;

- (BOOL)boolForKey:(id)key;
- (NSString *)stringForKey:(id)key;
- (NSNumber *)numberForKey:(id)key;
- (NSDate *)dateForKey:(id)key;
- (NSInteger)integerForKey:(id)key;
- (double)doubleForKey:(id)key;
- (NSArray *)arrayForKey:(id)key;
- (NSDictionary *)dictionaryForKey:(id)key;
- (NSString *)noNilStringForKey:(id)key;

@end

