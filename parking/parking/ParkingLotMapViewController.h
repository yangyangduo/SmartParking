//
//  ParkingLotMapViewController.h
//  parking
//
//  Created by Zhao yang on 11/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BMapKit.h"
#import "UIImage+Extension.h"
#import "ParkingLotAnnotationView.h"
#import "ParkingLotBubbleView.h"
#import "ParkingLotAnnotation.h"
#import "ParkingLotCollection.h"

@interface ParkingLotMapViewController : BaseViewController<BMKMapViewDelegate, BMKSearchDelegate, BubbleViewDelegate>

@property (strong, nonatomic) ParkingLotCollection *parkingLots;

@end
