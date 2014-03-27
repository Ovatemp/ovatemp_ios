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
  NSString *title = [error.userInfo objectForKey:@"error"];
  if (!title) {
    title = @"Something Went Wrong";
  }

  NSString *message;

  NSDictionary *errors = [error.userInfo objectForKey:@"errors"];
  if (errors && errors.count) {
    NSMutableString *errorMessages = [NSMutableString string];
    for (NSString *key in errors) {
      if (errorMessages.length) {
        [errorMessages appendString:@"\n"];
      }
      for (NSString *errorMessage in errors[key]) {
        [errorMessages appendFormat:@"- %@ %@", key, errorMessage];
      }
    }
    message = errorMessages;
  } else {
    message = error.localizedDescription;
  }

  [self showErrorWithTitle:title message:message];
}

@end
