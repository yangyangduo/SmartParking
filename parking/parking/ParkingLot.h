//
//  ParkingLot.h
//  parking
//
//  Created by Zhao yang on 11/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"

@interface ParkingLot : BaseEntity

@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;

@property (assign, nonatomic) NSUInteger numberOfParkingSpace;
@property (assign, nonatomic) NSUInteger numberOfEmptyParkingSpace;

@property (strong, nonatomic) NSString *address;

@property (assign, nonatomic, readonly) BOOL isFull;
@property (assign, nonatomic, readonly) BOOL isEmpty;
@property (assign, nonatomic, readonly) BOOL isFullOrEmpty;

@end
