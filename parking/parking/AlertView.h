//
//  AlertView.h
//  SmartHome
//
//  Created by Zhao yang on 8/16/13.
//  Copyright (c) 2013 zhaoyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Utils.h"

typedef NS_ENUM(NSUInteger, AlertViewState) {
    AlertViewStateReady,
    AlertViewStateWillAppear,
    AlertViewStateDidAppear,
    AlertViewStateWillDisappear
};

typedef NS_ENUM(NSUInteger, AlertViewType) {
    AlertViewTypeNone,
    AlertViewTypeWaitting,
    AlertViewTypeSuccess,
    AlertViewTypeFailed
};

@interface AlertView : UIView

@property (assign, nonatomic, readonly) AlertViewType alertViewType;
@property (assign, nonatomic) AlertViewState alertViewState;

+ (AlertView *)currentAlertView;

- (void)setMessage:(NSString *)message forType:(AlertViewType)type;
- (void)alertAutoDisappear:(BOOL)autoDisappear lockView:(UIView *)lockView;
- (void)delayDismissAlertView;
- (void)dismissAlertView;

@end
