//
//  ParkingLotBubbleView.h
//  parking
//
//  Created by Zhao yang on 11/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkingLot.h"
#import <CoreLocation/CLLocation.h>

#define PARKING_LOT_BUBBLE_VIEW_HEIGHT 110

@protocol BubbleViewDelegate;

@interface ParkingLotBubbleView : UIView

@property (strong, nonatomic) ParkingLot *parkingLot;
@property (assign, nonatomic) id<BubbleViewDelegate> delegate;

+ (ParkingLotBubbleView *)viewWithPoint:(CGPoint)point;

@end

@protocol BubbleViewDelegate <NSObject>

- (void)bubbleView:(ParkingLotBubbleView *)bubbleView pathPlanningTo:(CLLocationCoordinate2D)coordinate;

@end