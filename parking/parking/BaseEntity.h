//
//  BaseEntity.h
//  parking
//
//  Created by Zhao yang on 11/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+Extension.h"
#import "NSMutableDictionary+Extension.h"

@interface BaseEntity : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;

- (id)initWithDictionary:(NSDictionary *)dic;
- (NSMutableDictionary *)toDictionary;

@end
