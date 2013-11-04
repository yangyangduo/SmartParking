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

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;

@end
