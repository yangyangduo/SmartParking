//
//  ParkingLotMapViewController.mm
//  parking
//
//  Created by Zhao yang on 11/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ParkingLotMapViewController.h"
#import "UIImage+Extension.h"
#import "ParkingLotAnnotationView.h"
#import "ParkingLotBubbleView.h"
#import "ParkingLotAnnotation.h"

#define MYBUNDLE_NAME  @"mapapi.bundle"
#define MYBUNDLE_PATH  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:MYBUNDLE_NAME]
#define MYBUNDLE       [NSBundle bundleWithPath:MYBUNDLE_PATH]

@interface RouteAnnotation : BMKPointAnnotation {
	int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
	int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;

@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;

@end



@interface ParkingLotMapViewController ()

@end

@implementation ParkingLotMapViewController {
    BMKMapView *_mapView_;
    BMKSearch *_routeSearch_;
    ParkingLotBubbleView *_bubbleView_;
}

@synthesize parkingLots = _parkingLots_;

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_mapView_ != nil && _mapView_.delegate == nil) {
        _mapView_.delegate = self;
    }
    if(_routeSearch_ != nil && _routeSearch_.delegate == nil) {
        _routeSearch_.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(_mapView_ != nil) {
        _mapView_.delegate = nil;
    }
    if(_routeSearch_ != nil) {
        _routeSearch_.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Initializations

- (void)initDefaults {
    _routeSearch_ = [[BMKSearch alloc] init];
    _routeSearch_.delegate = self;
    
    ParkingLotEntity *en = [[ParkingLotEntity alloc] init];
    en.latitude = 28.234484;
    en.longitude = 112.945181;
    en.numberOfEmptyParkingSpace = 241;
    en.numberOfParkingSpace = 1200;
    en.name = @"万达停车场";
    
    [self.parkingLots addObject:en];
}

- (void)initUI {    
    _mapView_ = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    _mapView_.delegate = self;
    [self.view addSubview:_mapView_];
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 430, 150, 25)];
//    [btn setBackgroundColor:[UIColor blackColor]];
//    [btn setTitle:@"sssss" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(jjj) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
    
    [self showParkingLotsOnMap];
    [self showMyLocationWithZoomLevel:13];
}

- (void)showParkingLotsOnMap {
    if(_mapView_ == nil) return;
    [self removeAllParkingLotAnnotations];
    if(self.parkingLots == nil || self.parkingLots.count == 0) {
        return;
    }
    
    NSMutableArray *annotations = [NSMutableArray array];
    for(int i=0; i<self.parkingLots.count; i++) {
        ParkingLotEntity *entity = [self.parkingLots objectAtIndex:i];
        ParkingLotAnnotation *annotation = [[ParkingLotAnnotation alloc] init];
        CLLocationCoordinate2D coor;
        coor.latitude = entity.latitude;
        coor.longitude = entity.longitude;
        annotation.coordinate = coor;
        annotation.parkingLotEntity = entity;
        [annotations addObject:annotation];
    }
    
    [_mapView_ addAnnotations:annotations];
}

- (void)removeAllAnnotations {
    if(_mapView_ == nil) return;
    NSArray *annotations = [NSArray arrayWithArray:_mapView_.annotations];
    [_mapView_ removeAnnotations:annotations];
}

- (void)removeAllParkingLotAnnotations {
    if(_mapView_ == nil) return;
    NSMutableArray *arr = [NSMutableArray array];
    for(int i=0; i<_mapView_.annotations.count; i++) {
        if([[_mapView_.annotations objectAtIndex:i] isKindOfClass:[ParkingLotAnnotation class]]) {
            [arr addObject:[_mapView_.annotations objectAtIndex:i]];
        }
    }
    [_mapView_ removeAnnotations:arr];
}

- (void)removeAllAnnotationsButParkingLotAnnotations {
    if(_mapView_ == nil) return;
    NSMutableArray *arr = [NSMutableArray array];
    for(int i=0; i<_mapView_.annotations.count; i++) {
        if([[_mapView_.annotations objectAtIndex:i] isKindOfClass:[ParkingLotAnnotation class]]) {
            continue;
        }
        [arr addObject:[_mapView_.annotations objectAtIndex:i]];
    }
    [_mapView_ removeAnnotations:arr];
}

- (void)removeAllOverlays {
    NSArray *overlays = [NSArray arrayWithArray:_mapView_.overlays];
    [_mapView_ removeOverlays:overlays];
}

- (void)showMyLocationWithZoomLevel:(NSUInteger)zoomLevel {
    if(_mapView_ == nil) return;
    
    _mapView_.showsUserLocation = NO;;
    _mapView_.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView_.showsUserLocation = YES;
    [_mapView_ setCenterCoordinate:_mapView_.userLocation.coordinate animated:YES];
    _mapView_.zoomLevel = zoomLevel;
}

- (void)showParkingLotViewWithEntity:(ParkingLotEntity *)entity {
    if(_bubbleView_ == nil) {
        _bubbleView_ = [ParkingLotBubbleView viewWithPoint:CGPointMake(0, self.view.bounds.size.height)];
        [self.view addSubview: _bubbleView_];
    }
    
    _bubbleView_.parkingLotEntity = entity;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         _bubbleView_.center = CGPointMake(_bubbleView_.center.x, _bubbleView_.center.y - PARKING_LOT_BUBBLE_VIEW_HEIGHT);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"finished");
                     }
     ];
}

- (void)hideParkingLotView {
    if(_bubbleView_ == nil) return;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         _bubbleView_.center = CGPointMake(_bubbleView_.center.x, _bubbleView_.center.y + PARKING_LOT_BUBBLE_VIEW_HEIGHT);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"finished");
                     }
     ];
}

- (void)jjj {

    CLLocationCoordinate2D coor;
    coor.latitude = 28.234484;
    coor.longitude = 112.945181;

    

    BMKPlanNode *startNode = [[BMKPlanNode alloc] init];
    startNode.pt = _mapView_.userLocation.coordinate;
    
    BMKPlanNode *endNode =    [[BMKPlanNode alloc] init];
    endNode.pt = coor;

    BMKSearch *search = [[BMKSearch alloc] init];
    search.delegate = self;

    [search drivingSearch:@"长沙" startNode:startNode endCity:@"长沙" endNode:endNode];
}

- (BMKRoutePlan *)getMinimumTimePlan:(BMKPlanResult *)result {
    if(result == nil || result.plans == nil || result.plans.count == 0) return nil;
    BMKTime *time = nil;
    int index = -1;
    for(int i=0; i<result.plans.count; i++) {
        BMKRoutePlan *plan = [result.plans objectAtIndex:i];
        if(i == 0) {
            time = plan.time;
            index = 0;
            continue;
        }
        
        
    }
    return [result.plans objectAtIndex:index];
}

- (BMKRoutePlan *)getMinimumDistancePlan:(BMKPlanResult *)result {
    if(result == nil || result.plans == nil || result.plans.count == 0) return nil;
    int distance = -1;
    int index = -1;
    for(int i=0; i<result.plans.count; i++) {
        BMKRoutePlan *plan = [result.plans objectAtIndex:i];
        if(i == 0) {
            distance = plan.distance;
            index = 0;
            continue;
        }
        if(plan.distance < distance) {
            distance = plan.distance;
            index = i;
        }
    }
    return [result.plans objectAtIndex:index];
}

#pragma mark -
#pragma mark BMK Search Delegate

- (void)onGetDrivingRouteResult:(BMKPlanResult *)result errorCode:(int)error {
    if(result != nil) {
        [self removeAllAnnotationsButParkingLotAnnotations];
        [self removeAllOverlays];
        
        // error 值的意义请参考BMKErrorCode
        if (error == BMKErrorOk) {
            BMKRoutePlan* plan = [self getMinimumDistancePlan:result];
            
            if(plan != nil) {
                // 添加起点
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = result.startNode.pt;
                item.title = @"起点";
                item.type = 0;
                [_mapView_ addAnnotation:item];
                
                // 下面开始计算路线，并添加驾车提示点
                int index = 0;
                int size = [plan.routes count];
                for (int i = 0; i < 1; i++) {
                    BMKRoute* route = [plan.routes objectAtIndex:i];
                    for (int j = 0; j < route.pointsCount; j++) {
                        int len = [route getPointsNum:j];
                        index += len;
                    }
                }
                
                BMKMapPoint* points = new BMKMapPoint[index];
                index = 0;
                for (int i = 0; i < 1; i++) {
                    BMKRoute* route = [plan.routes objectAtIndex:i];
                    for (int j = 0; j < route.pointsCount; j++) {
                        int len = [route getPointsNum:j];
                        BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
                        memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
                        index += len;
                    }
                    size = route.steps.count;
                    for (int j = 0; j < size; j++) {
                        // 添加驾车关键点
                        BMKStep* step = [route.steps objectAtIndex:j];
                        item = [[RouteAnnotation alloc]init];
                        item.coordinate = step.pt;
                        item.title = step.content;
                        item.degree = step.degree * 30;
                        item.type = 4;
                        [_mapView_ addAnnotation:item];
                    }
                }
                
                // 添加终点
                item = [[RouteAnnotation alloc]init];
                item.coordinate = result.endNode.pt;
                item.type = 1;
                item.title = @"终点";
                [_mapView_ addAnnotation:item];
                
                // 添加途经点
                if(result.wayNodes) {
                    for (BMKPlanNode* tempNode in result.wayNodes) {
                        item = [[RouteAnnotation alloc]init];
                        item.coordinate = tempNode.pt;
                        item.type = 5;
                        item.title = tempNode.name;
                        [_mapView_ addAnnotation:item];
                    }
                }
                
                // 根究计算的点，构造并添加路线覆盖物
                BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
                [_mapView_ addOverlay:polyLine];
                delete[] points;
                
                [_mapView_ setCenterCoordinate:result.startNode.pt animated:YES];
                return;
            }
        }
    }
    
    // Error ...
}

#pragma mark -
#pragma mark BMK Map view delegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation *)annotation];
    } else if([annotation isKindOfClass:[ParkingLotAnnotation class]]) {
        ParkingLotAnnotationView *annotationView = [[ParkingLotAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"parking_node"];
        annotationView.canShowCallout = NO;
        return annotationView;
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay  {
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
	return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    if([view isKindOfClass:[ParkingLotAnnotationView class]]) {
        ParkingLotAnnotationView *annotationView = (ParkingLotAnnotationView *)view;
        if([annotationView.annotation isKindOfClass:[ParkingLotAnnotation class]]) {
            ParkingLotAnnotation *parkingLotAnnotation = (ParkingLotAnnotation *)annotationView.annotation;
            [self showParkingLotViewWithEntity:parkingLotAnnotation.parkingLotEntity];
        }
    }
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view {
    if([view isKindOfClass:[ParkingLotAnnotationView class]]) {
        NSLog(@"deselect");
        [self hideParkingLotView];
    }
}

#pragma mark -
#pragma mark Methods for create route annotation view

- (BMKAnnotationView *)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation {
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"] ;
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 1: {
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 2: {
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"] ;
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
		case 3: {
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
		case 4: {
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
		}
			break;
        case 5: {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
        }
            break;
		default:
			break;
	}
	
	return view;
}

- (NSString*)getMyBundlePath1:(NSString *)filename {
	NSBundle *libBundle = MYBUNDLE;
	if(libBundle && filename ) {
		NSString *s = [[libBundle resourcePath] stringByAppendingPathComponent:filename];
		return s;
	}
	return nil ;
}

#pragma mark -
#pragma mark Getter and setters

- (NSMutableArray *)parkingLots {
    if(_parkingLots_ == nil) {
        _parkingLots_ = [NSMutableArray array];
    }
    return _parkingLots_;
}

@end
