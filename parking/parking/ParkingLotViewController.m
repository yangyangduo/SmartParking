//
//  ParkingLotViewController.m
//  parking
//
//  Created by Zhao yang on 11/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ParkingLotViewController.h"
#import "ParkingLotBubbleView.h"

@interface ParkingLotViewController ()

@end

@implementation ParkingLotViewController {
    BMKMapView *mapView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 10, 320, 400)];
    mapView.delegate = self;

    [self.view addSubview:mapView];
    
    
    
    
   
    UIButton *btn =    [[UIButton alloc] initWithFrame:CGRectMake(10, 430, 150, 25)];
    [btn setBackgroundColor:[UIColor blackColor]];
    [btn setTitle:@"sssss" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(jjj) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)jjj {
//    mapView.showsUserLocation = NO;
//    mapView.userTrackingMode = BMKUserTrackingModeNone;
//    mapView.showsUserLocation = YES;
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 39.915;
    coor.longitude = 116.404;
    annotation.coordinate = coor;
    annotation.title = @"这里是北京";
    [mapView addAnnotation:annotation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark BMK Annotation view delegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    // 只要字符串不传nil就代表了要重用
    BMKAnnotationView *v = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"an"];
    
    
    //retina 60*60  30*30
    v.image = [UIImage imageNamed:@"pin_green"];

//    v.backgroundColor = [UIColor blackColor];
//    v.frame = CGRectMake(0, 0, 100, 100);
    
    
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    vv.backgroundColor = [UIColor greenColor];
    v.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:vv];
    
    
    return v;
}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    NSLog(@"add view count is %d", views.count);
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    NSLog(@"select");
    

}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"region change");
}

@end
