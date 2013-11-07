//
//  ParkingLotBubbleView.h
//  parking
//
//  Created by Zhao yang on 11/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkingLotEntity.h"

#define PARKING_LOT_BUBBLE_VIEW_HEIGHT 110

@interface ParkingLotBubbleView : UIView

@property (strong, nonatomic) ParkingLotEntity *parkingLotEntity;

+ (ParkingLotBubbleView *)viewWithPoint:(CGPoint)point;

@end
