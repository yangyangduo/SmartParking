//
//  ParkingLotBubbleView.m
//  parking
//
//  Created by Zhao yang on 11/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ParkingLotBubbleView.h"

@implementation ParkingLotBubbleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (ParkingLotBubbleView *)viewWithParkingLot:(ParkingLotEntity *)parkingLot {
    ParkingLotBubbleView *view = [[ParkingLotBubbleView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    
    return view;
}

@end
