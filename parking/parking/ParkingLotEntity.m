//
//  ParkingLotEntity.m
//  parking
//
//  Created by Zhao yang on 11/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ParkingLotEntity.h"

@implementation ParkingLotEntity

@synthesize latitude;
@synthesize longitude;

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super initWithDictionary:dic];
    if(self && dic) {
        self.latitude = [dic doubleForKey:@"latitude"];
        self.longitude = [dic doubleForKey:@"longitude"];
    }
    return self;
}

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *dic = [super toDictionary];
    [dic setDouble:self.latitude forKey:@"latitude"];
    [dic setDouble:self.longitude forKey:@"longitude"];
    return dic;
}

@end
