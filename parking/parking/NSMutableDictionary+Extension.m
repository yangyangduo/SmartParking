//
//  NSMutableDictionary+Extension.m
//  SmartHome
//
//  Created by Zhao yang on 9/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NSMutableDictionary+Extension.h"

@implementation NSMutableDictionary (Extension)

- (void)setInteger:(NSInteger)integer forKey:(id<NSCopying>)key {
    [self setObject:[NSNumber numberWithInteger:integer] forKey:key];
}

/* if object is blank , return */
- (void)setNoNilObject:(id)object forKey:(id<NSCopying>)key {
    if(object == nil || object == [NSNull null]) return;
    [self setObject:object forKey:key];
}

/* if string is blank , return */
- (void)setNoBlankString:(NSString *)string forKey:(id<NSCopying>)key {
    if([NSString isBlank:string]) return;
    [self setObject:string forKey:key];
}

/* if string is blank , set an empty string for value */
- (void)setMayBlankString:(NSString *)string forKey:(id<NSCopying>)key {
    if([NSString isBlank:string]) {
        [self setObject:[NSString emptyString] forKey:key];
        return;
    }
    [self setObject:string forKey:key];
}

/* if date is nil , return */
- (void)setDateLongLongValue:(NSDate *)date forKey:(id<NSCopying>)key {
    if(date == nil) return;
    [self setObject:[NSNumber numberWithLongLong:date.timeIntervalSince1970 * 1000] forKey:key];
}

- (void)setBool:(BOOL)b forKey:(id<NSCopying>)key {
    NSString *boolStr = b ? @"yes" : @"no";
    [self setObject:boolStr forKey:key];
}

@end
