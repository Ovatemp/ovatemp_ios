//
//  UIViewController+ConnectionManager.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "UIViewController+ConnectionManager.h"

@implementation UIViewController (ConnectionManager)

- (Alert *)alertForError:(NSError *)error {
  NSString *title = @"Something Went Wrong!";

  NSString *message = [error.userInfo objectForKey:@"error"];

  if (!message) {
    message = error.localizedDescription;
  }

  return [Alert errorWithTitle:title message:message];
}

- (void)presentError:(NSError *)error {
  Alert *alert = [self alertForError:error];
  [alert addButtonWithText:@"Okay" type:AlertButtonError];
  [alert show];
}

@end
