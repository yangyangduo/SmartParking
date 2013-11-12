//
//  ParkingLotCollection.m
//  parking
//
//  Created by Zhao yang on 11/11/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ParkingLotCollection.h"

@implementation ParkingLotCollection

@synthesize allParkingLots = _allParkingLots_;

- (ParkingLot *)parkingLotWithIdentifier:(NSString *)identifier {
    if([NSString isBlank:identifier]) return nil;
    if(self.allParkingLots == nil) return nil;
    for(int i=0; i<self.allParkingLots.count; i++) {
        ParkingLot *parkingLot = [self.allParkingLots objectAtIndex:i];
        if([identifier isEqualToString:parkingLot.identifier]) {
            return parkingLot;
        }
    }
    return nil;
}

- (NSArray *)parkingLotsWithName:(NSString *)name {
    if([NSString isBlank:name]) return nil;
    if(self.allParkingLots == nil) return nil;
    NSMutableArray *parkingLots = [NSMutableArray array];
    for(int i=0; i<self.allParkingLots.count; i++) {
        ParkingLot *parkingLot = [self.allParkingLots objectAtIndex:i];
        if([name isEqualToString:parkingLot.name]) {
            [parkingLots addObject:parkingLot];
        }
    }
    return parkingLots;
}

- (BOOL)hasAnyParkingLots {
    if(self.allParkingLots == nil) return NO;
    if(self.allParkingLots.count == 0) return NO;
    return YES;
}

- (NSMutableArray *)allParkingLots {
    if(_allParkingLots_ == nil) {
        _allParkingLots_ = [NSMutableArray array];
    }
    return _allParkingLots_;
}

@end
