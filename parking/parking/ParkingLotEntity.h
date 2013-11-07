//
//  ParkingLotEntity.h
//  parking
//
//  Created by Zhao yang on 11/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"

@interface ParkingLotEntity : BaseEntity

@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;

@property (assign, nonatomic) NSUInteger numberOfParkingSpace;
@property (assign, nonatomic) NSUInteger numberOfEmptyParkingSpace;

@property (strong, nonatomic) NSString *address;

@end
