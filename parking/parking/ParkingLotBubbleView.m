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
    UILabel *lblParkingLotAddress;
    UIButton *btnPathPlanning;
}

@synthesize parkingLot = _parkingLot_;
@synthesize delegate;

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
    self.alpha = 0.95f;
    
    lblParkingLotName = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 160, 29)];
    lblParkingLotName.font = [UIFont boldSystemFontOfSize:16.f];
    [self addSubview:lblParkingLotName];
    
    lblParkingSpaceInfo = [[UILabel alloc] initWithFrame:CGRectMake(175, 8, 135, 29)];
    lblParkingSpaceInfo.font = [UIFont systemFontOfSize:11.f];
    lblParkingSpaceInfo.textColor = [UIColor darkTextColor];
    lblParkingSpaceInfo.textAlignment = NSTextAlignmentRight;
    [self addSubview:lblParkingSpaceInfo];
    
    UILabel *lblParkingLotAddressTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 37, 30, 25)];
    lblParkingLotAddressTitle.font = [UIFont boldSystemFontOfSize:12.f];
    lblParkingLotAddressTitle.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"address", @"")];
    [self addSubview:lblParkingLotAddressTitle];
    
    lblParkingLotAddress = [[UILabel alloc] initWithFrame:CGRectMake(45, 37, 275, 25)];
    lblParkingLotAddress.font = [UIFont systemFontOfSize:12.f];
    [self addSubview:lblParkingLotAddress];
    
    btnPathPlanning = [[UIButton alloc] initWithFrame:CGRectMake(60, 70, 200, 25)];
    [btnPathPlanning setTitle:NSLocalizedString(@"path_plan", @"") forState:UIControlStateNormal];
    btnPathPlanning.backgroundColor = [UIColor lightGrayColor];
    [btnPathPlanning setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnPathPlanning.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [btnPathPlanning addTarget:self action:@selector(pathPlanning:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnPathPlanning];
}

- (void)pathPlanning:(id)sender {
    if(_parkingLot_ != nil && self.delegate != nil) {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = _parkingLot_.latitude;
        coordinate.longitude = _parkingLot_.longitude;
        [self.delegate bubbleView:self pathPlanningTo:coordinate];
    }
}

- (void)setParkingLot:(ParkingLot *)parkingLot {
    _parkingLot_ = parkingLot;
    if(_parkingLot_ != nil) {
        lblParkingLotName.text = _parkingLot_.name;
        if([NSString isBlank:_parkingLot_.address]) {
            lblParkingLotAddress.text = [NSString emptyString];
        } else {
            lblParkingLotAddress.text = _parkingLot_.address;
        }
        lblParkingSpaceInfo.text = [NSString stringWithFormat:@"%@: (%d/%d) %@",NSLocalizedString(@"parking_space_remain", @""), _parkingLot_.numberOfEmptyParkingSpace, _parkingLot_.numberOfParkingSpace, NSLocalizedString(@"parking_space", @"")];
    } else {
        lblParkingLotName.text = [NSString emptyString];
        lblParkingSpaceInfo.text = [NSString emptyString];
        lblParkingLotAddress.text = [NSString emptyString];
    }
}

@end
