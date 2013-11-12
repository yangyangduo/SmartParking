//
//  ParkingLotCollection.h
//  parking
//
//  Created by Zhao yang on 11/11/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "BaseEntity.h"
#import "ParkingLot.h"

@interface ParkingLotCollection : BaseEntity

@property (strong, nonatomic) NSMutableArray *allParkingLots;
@property (assign, nonatomic, readonly) BOOL hasAnyParkingLots;

- (ParkingLot *)parkingLotWithIdentifier:(NSString *)identifier;
- (NSArray *)parkingLotsWithName:(NSString *)name;

@end
