//
//  UIViewController+Alerts.h
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Alert;

@interface UIViewController (Alerts)

- (Alert *)alertWithTitle:(NSString *)title message:(NSString *)message;
- (Alert *)alertWithTitle:(NSString *)title message:(NSString *)message selector:(SEL)selector;

- (void)showErrorWithTitle:(NSString *)title message:(NSString *)message;
- (void)showNotificationWithTitle:(NSString *)title message:(NSString *)message;

@end
