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

@synthesize numberOfEmptyParkingSpace;
@synthesize numberOfParkingSpace;

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super initWithDictionary:dic];
    if(self && dic) {
        self.latitude = [dic doubleForKey:@"latitude"];
        self.longitude = [dic doubleForKey:@"longitude"];
        self.numberOfParkingSpace = [dic integerForKey:@"parkingSpaceCount"];
        self.numberOfEmptyParkingSpace = [dic integerForKey:@"emptyParkingSpaceCount"];
    }
    return self;
}

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *dic = [super toDictionary];
    [dic setDouble:self.latitude forKey:@"latitude"];
    [dic setDouble:self.longitude forKey:@"longitude"];
    [dic setInteger:self.numberOfEmptyParkingSpace forKey:@"parkingSpaceCount"];
    [dic setInteger:self.numberOfParkingSpace forKey:@"emptyParkingSpaceCount"];
    return dic;
}

@end
