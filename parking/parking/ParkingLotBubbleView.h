//
//  ParkingLotBubbleView.h
//  parking
//
//  Created by Zhao yang on 11/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkingLotEntity.h"

@interface ParkingLotBubbleView : UIView

+ (ParkingLotBubbleView *)viewWithParkingLot:(ParkingLotEntity *)parkingLot;

@end
