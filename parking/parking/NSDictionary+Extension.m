//
//  NSDictionary+Extension.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

/****************************
 * can be nil
 ****************************/

- (id)notNSNullObjectForKey:(id)key {
    id obj = [self objectForKey:key];
    if(obj == [NSNull null]) return nil;
    return obj;
}

- (NSString *)stringForKey:(id)key {
    NSString *str = [self notNSNullObjectForKey:key];
    if(str != nil) {
        return str;
    }
    return nil;
}

- (NSNumber *)numberForKey:(id)key {
    return [self notNSNullObjectForKey:key];
}

- (NSDate *)dateForKey:(id)key {
    NSNumber *_date_ = [self notNSNullObjectForKey:key];
    if(_date_ == nil) return nil;
    return [NSDate dateWithTimeIntervalSince1970:_date_.longLongValue / 1000];
}

- (NSArray *)arrayForKey:(id)key {
    return [self notNSNullObjectForKey:key];
}

- (NSDictionary *)dictionaryForKey:(id)key {
    return [self notNSNullObjectForKey:key];
}


/****************************
 * can not be nil
 ****************************/

- (NSInteger)integerForKey:(id)key {
    NSNumber *number = [self notNSNullObjectForKey:key];
    if(number == nil) return 0;
    return number.integerValue;
}

- (double)doubleForKey:(id)key {
    NSNumber *number = [self notNSNullObjectForKey:key];
    if(number == nil) return 0;
    return number.doubleValue;
}

- (BOOL)boolForKey:(id)key {
    NSString *_bool_ = [self notNSNullObjectForKey:key];
    if(_bool_ != nil) {
        return [@"yes" isEqualToString:_bool_] || [@"YES" isEqualToString:_bool_];
    }
    return NO;
}

- (NSString *)noNilStringForKey:(id)key {
    NSString *_str_ = [self notNSNullObjectForKey:key];
    if(_str_ == nil) {
        return [NSString emptyString];
    }
    return _str_;
}

@end
