//
//  ParkingLotBubbleView.m
//  parking
//
//  Created by Zhao yang on 11/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ParkingLotBubbleView.h"

@implementation ParkingLotBubbleView {
    UILabel *lblParkingLotName;
    UILabel *lblParkingSpaceInfo;
    UIButton *btnPathPlanning;
}

@synthesize parkingLotEntity = _entity_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

+ (ParkingLotBubbleView *)viewWithPoint:(CGPoint)point {
    return [[ParkingLotBubbleView alloc] initWithFrame:CGRectMake(point.x, point.y, [UIScreen mainScreen].bounds.size.width, PARKING_LOT_BUBBLE_VIEW_HEIGHT)];
}

- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0.9f;
    
    lblParkingLotName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview:lblParkingLotName];
    
    lblParkingSpaceInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview:lblParkingSpaceInfo];
    
    btnPathPlanning = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [btnPathPlanning addTarget:self action:@selector(pathPlanning:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnPathPlanning];
}

- (void)pathPlanning:(id)sender {
    
}

- (void)setParkingLotEntity:(ParkingLotEntity *)parkingLotEntity {
    _entity_ = parkingLotEntity;
    if(_entity_ != nil) {
        lblParkingLotName.text = _entity_.name;
        
        [NSString stringWithFormat:@"%d / %d %@", _entity_.numberOfEmptyParkingSpace, _entity_.numberOfParkingSpace, @""];
    } else {
        lblParkingLotName.text = [NSString emptyString];
        lblParkingSpaceInfo.text = [NSString emptyString];
    }
}

@end
