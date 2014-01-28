//
//  UIViewController+Alerts.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "UIViewController+Alerts.h"

#import "Alert.h"

@implementation UIViewController (Alerts)

#pragma mark - Alerts

- (Alert *)alertWithTitle:(NSString *)title message:(NSString *)message {
  return [self alertWithTitle:title message:message selector:nil];
}

- (Alert *)alertWithTitle:(NSString *)title message:(NSString *)message selector:(SEL)selector {
  Alert *alert = [Alert notificationWithTitle:title message:message];
  return alert;
}

- (void)showErrorWithTitle:(NSString *)title message:(NSString *)message {
  Alert *alert = [Alert errorWithTitle:title message:message];
  [alert addButtonWithText:@"OK" type:AlertButtonOK];
  [alert show];
}

- (void)showNotificationWithTitle:(NSString *)title message:(NSString *)message {
  Alert *alert = [Alert notificationWithTitle:title message:message];
  [alert addButtonWithText:@"OK" type:AlertButtonOK];
  [alert show];
}

@end
