//
//  ParkingLotAnnotation.h
//  parking
//
//  Created by Zhao yang on 11/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "BMKPointAnnotation.h"
#import "ParkingLot.h"

@interface ParkingLotAnnotation : BMKPointAnnotation

@property (strong, nonatomic) ParkingLot *parkingLot;

@end
