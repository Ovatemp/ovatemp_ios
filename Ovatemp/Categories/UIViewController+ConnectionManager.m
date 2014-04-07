//
//  UIViewController+ConnectionManager.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "UIViewController+ConnectionManager.h"

#import "UIViewController+Alerts.h"

@implementation UIViewController (ConnectionManager)

- (void)presentError:(NSError *)error {
  NSString *title = @"Something Went Wrong!";

  NSString *message = [error.userInfo objectForKey:@"error"];

  if (!message) {
    message = error.localizedDescription;
  }

  [self showErrorWithTitle:title message:message];
}

@end
