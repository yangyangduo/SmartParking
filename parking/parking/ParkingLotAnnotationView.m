//
//  ParkingLotAnnotationView.m
//  parking
//
//  Created by Zhao yang on 11/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ParkingLotAnnotationView.h"

@implementation ParkingLotAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"icon_parking_lot"];
        self.centerOffset = CGPointMake(0, -(self.frame.size.height * 0.5));
    }
    return self;
}

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self) {
        self.image = [UIImage imageNamed:@"icon_parking_lot"];
        self.centerOffset = CGPointMake(0, -(self.frame.size.height * 0.5));
    }
    return self;
}

@end
