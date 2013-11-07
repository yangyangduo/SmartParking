//
//  BaseEntity.m
//  parking
//
//  Created by Zhao yang on 11/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "BaseEntity.h"

@implementation BaseEntity

@synthesize identifier;
@synthesize name;
@synthesize description;

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if(self && dic) {
        self.identifier = [dic noNilStringForKey:@"identifier"];
        self.name = [dic noNilStringForKey:@"name"];
        self.description = [dic noNilStringForKey:@"description"];
    }
    return self;
}

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setMayBlankString:self.identifier forKey:@"identifier"];
    [dic setMayBlankString:self.name forKey:@"name"];
    [dic setMayBlankString:self.description forKey:@"description"];
    return dic;
}

@end
