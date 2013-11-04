//
//  BaseViewController.h
//  parking
//
//  Created by Zhao yang on 11/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)initDefaults;
- (void)initUI;

- (void)registerTapGestureToResignKeyboard;
- (void)triggerTapGestureEventForResignKeyboard:(UIGestureRecognizer *)gesture;
- (void)resignFirstResponderFor:(UIView *)view;

@end
