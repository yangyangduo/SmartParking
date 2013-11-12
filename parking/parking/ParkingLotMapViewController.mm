//
//  ParkingLotMapViewController.mm
//  parking
//
//  Created by Zhao yang on 11/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ParkingLotMapViewController.h"
#import "AlertView.h"

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
    
    /* To show parking lot details. */
    ParkingLotBubbleView *_bubbleView_;
    
    UIButton *btnShowMyLocation;
    
    /* For parking lot info refresh timer. */
    NSTimer *_parkingLotRefreshTimer_;
    NSString *_currentRefreshParkingLotIdentifier_;
}

@synthesize parkingLots = _parkingLots_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    ParkingLot *en = [[ParkingLot alloc] init];
    en.identifier = @"a001";
    en.latitude = 28.159561;
    en.longitude = 113.001906;
    en.numberOfEmptyParkingSpace = 10;
    en.numberOfParkingSpace = 241;
    en.name = @"沃尔玛购物广场停车场";
    en.address = @"长沙市雨花区韶山中路421号长沙深国投商业中心";
    
    ParkingLot *en1 = [[ParkingLot alloc] init];
    en1.identifier = @"a002";
    en1.latitude = 28.199665;
    en1.longitude = 112.983562;
    en1.numberOfEmptyParkingSpace = 5;
    en1.numberOfParkingSpace = 420;
    en1.name = @"平和堂商贸大厦停车场";
    en1.address = @"长沙市芙蓉区五一大道629湖南平和堂商贸大厦";
    
    ParkingLot *en2 = [[ParkingLot alloc] init];
    en2.identifier = @"a003";
    en2.latitude = 28.20471;
    en2.longitude = 112.984146;
    en2.numberOfEmptyParkingSpace = 100;
    en2.numberOfParkingSpace = 310;
    en2.name = @"乐和城停车场";
    en2.address = @"长沙市芙蓉区黄兴中路188号";
    
    [self.parkingLots.allParkingLots addObject:en];
    [self.parkingLots.allParkingLots addObject:en1];
    [self.parkingLots.allParkingLots addObject:en2];
}

- (void)initUI {    
    _mapView_ = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    _mapView_.delegate = self;
    [self.view addSubview:_mapView_];
    
    btnShowMyLocation = [[UIButton alloc] initWithFrame:CGRectMake(5, self.view.bounds.size.height - 32 - 50, 33, 32)];
    [btnShowMyLocation setBackgroundImage:[UIImage imageNamed:@"btn_show_my_location"] forState:UIControlStateNormal];
    [btnShowMyLocation addTarget:self action:@selector(btnShowMyLocationPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnShowMyLocation];
}

- (void)setup {
    [self showParkingLotsOnMap];
    [self showMyLocationWithZoomLevel:14];
}

- (void)startRefrehParkingLotTimerWithIdentifier:(NSString *)parkingLotIdentifier {
    _currentRefreshParkingLotIdentifier_ = parkingLotIdentifier;
    _parkingLotRefreshTimer_ = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(updateParkingLot) userInfo:nil repeats:YES];
    [_parkingLotRefreshTimer_ fire];
#ifdef DEBUG
    NSLog(@"[] Parking space refresh timer started.");
#endif
}

- (void)stopRefreshParkingLotTimer {
    if(_parkingLotRefreshTimer_ != nil && _parkingLotRefreshTimer_.isValid) {
        [_parkingLotRefreshTimer_ invalidate];
        _parkingLotRefreshTimer_ = nil;
#ifdef DEBUG
        NSLog(@"[] Parking space refresh timer stopped.");
#endif
    }
}

- (void)updateParkingLot {
    if([NSString isBlank:_currentRefreshParkingLotIdentifier_]) return;
    ParkingLot *parkingLot = [self.parkingLots parkingLotWithIdentifier:_currentRefreshParkingLotIdentifier_];
    if(parkingLot.isFullOrEmpty) {
        int random = arc4random() % 3;
        if(random == 0) {
            if(parkingLot.isFull) {
                parkingLot.numberOfEmptyParkingSpace++;
            } else if(parkingLot.isEmpty) {
                parkingLot.numberOfEmptyParkingSpace--;
            }
        }
    } else {
        int random = arc4random() % 4;
        if(random == 0) {
            parkingLot.numberOfEmptyParkingSpace--;
        } else if(random == 1) {
            parkingLot.numberOfEmptyParkingSpace++;
        }
    }
    
    if(_bubbleView_ != nil) {
        _bubbleView_.parkingLot = parkingLot;
    }
}


- (void)showParkingLotsOnMap {
    if(_mapView_ == nil) return;
    [self removeAllParkingLotAnnotations];
    if(!self.parkingLots.hasAnyParkingLots) return;
    
    NSMutableArray *annotations = [NSMutableArray array];
    for(int i=0; i<self.parkingLots.allParkingLots.count; i++) {
        ParkingLot *parkingLot = [self.parkingLots.allParkingLots objectAtIndex:i];
        ParkingLotAnnotation *annotation = [[ParkingLotAnnotation alloc] init];
        CLLocationCoordinate2D coor;
        coor.latitude = parkingLot.latitude;
        coor.longitude = parkingLot.longitude;
        annotation.coordinate = coor;
        annotation.parkingLot = parkingLot;
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

/* If the parameter of 'zone level' is '-1', will not changed the current zoom level */
- (void)showMyLocationWithZoomLevel:(NSUInteger)zoomLevel {
    if(_mapView_ == nil) return;
    
    _mapView_.showsUserLocation = NO;;
    _mapView_.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView_.showsUserLocation = YES;
    [_mapView_ setCenterCoordinate:_mapView_.userLocation.coordinate animated:YES];
    if(zoomLevel != -1) {
        _mapView_.zoomLevel = zoomLevel;
    }
}

- (void)showParkingLotViewWithEntity:(ParkingLot *)entity {
    if(_bubbleView_ == nil) {
        _bubbleView_ = [ParkingLotBubbleView viewWithPoint:CGPointMake(0, self.view.bounds.size.height)];
        _bubbleView_.delegate = self;
        [self.view addSubview: _bubbleView_];
    }
    
    _bubbleView_.parkingLot = entity;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         btnShowMyLocation.center = CGPointMake(btnShowMyLocation.center.x, btnShowMyLocation.center.y - _bubbleView_.bounds.size.height + 35);
                         _bubbleView_.center = CGPointMake(_bubbleView_.center.x, _bubbleView_.center.y - PARKING_LOT_BUBBLE_VIEW_HEIGHT);
                     }
                     completion:^(BOOL finished) {
                     }
     ];
}

- (void)hideParkingLotView {
    if(_bubbleView_ == nil) return;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         _bubbleView_.center = CGPointMake(_bubbleView_.center.x, _bubbleView_.center.y + PARKING_LOT_BUBBLE_VIEW_HEIGHT);
                         btnShowMyLocation.center = CGPointMake(btnShowMyLocation.center.x, btnShowMyLocation.center.y + _bubbleView_.bounds.size.height - 35);
                     }
                     completion:^(BOOL finished) {
                     }
     ];
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
#pragma mark UI Event

- (void)btnShowMyLocationPressed:(id)sender {
    [self showMyLocationWithZoomLevel:-1];
}

#pragma mark -
#pragma mark Bubble view delegate

- (void)bubbleView:(ParkingLotBubbleView *)bubbleView pathPlanningTo:(CLLocationCoordinate2D)coordinate {
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"path_planning", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:NO lockView:self.view];
    
    if(_routeSearch_ == nil) {
        _routeSearch_ = [[BMKSearch alloc] init];
        _routeSearch_.delegate = self;
    }
    
    BMKPlanNode *startNode = [[BMKPlanNode alloc] init];
    startNode.pt = _mapView_.userLocation.coordinate;
    
    BMKPlanNode *endNode = [[BMKPlanNode alloc] init];
    endNode.pt = coordinate;
    
    [_routeSearch_ drivingSearch:@"长沙" startNode:startNode endCity:@"长沙" endNode:endNode];
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
                item.title = NSLocalizedString(@"start_point", @"");
                item.type = 0;
                [_mapView_ addAnnotation:item];
                
                // 下面开始计算路线，并添加驾车提示点
                int index = 0;

                NSUInteger size = plan.routes.count;
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
                item.title = NSLocalizedString(@"terminal_point", @"");
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
                
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"path_plan_success", @"") forType:AlertViewTypeSuccess];
                [[AlertView currentAlertView] delayDismissAlertView];
                return;
            }
        }
    }
    
    /*
     BMKErrorConnect = 2,	///< 网络连接错误
     BMKErrorData = 3,	///< 数据错误
     BMKErrorRouteAddr = 4, ///<起点或终点选择(有歧义)
     BMKErrorResultNotFound = 100,	///< 搜索结果未找到
     BMKErrorLocationFailed = 200,	///< 定位失败
     BMKErrorPermissionCheckFailure = 300,	///< 百度地图API授权Key验证失败
     BMKErrorParse = 310  //数据解析失败
     */
    
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"path_plan_failed", @"") forType:AlertViewTypeFailed];
    [[AlertView currentAlertView] delayDismissAlertView];
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
            [self showParkingLotViewWithEntity:parkingLotAnnotation.parkingLot];
            // Start refresh parking space timer
            [self startRefrehParkingLotTimerWithIdentifier:parkingLotAnnotation.parkingLot.identifier];
        }
    }
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view {
    if([view isKindOfClass:[ParkingLotAnnotationView class]]) {
        // Stop refresh parking space timer
        [self stopRefreshParkingLotTimer];
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

- (ParkingLotCollection *)parkingLots {
    if(_parkingLots_ == nil) {
        _parkingLots_ = [[ParkingLotCollection alloc] init];
    }
    return _parkingLots_;
}

@end
