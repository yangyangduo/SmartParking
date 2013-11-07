//
//  ParkingLotViewController.h
//  parking
//
//  Created by Zhao yang on 11/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BMapKit.h"

@interface ParkingLotViewController : BaseViewController<BMKMapViewDelegate, BMKSearchDelegate>

@property (strong, nonatomic) NSMutableArray *parkingLots;

@end
