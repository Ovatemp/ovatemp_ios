//
//  UIViewController+KeyboardObservers.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/19/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "UIViewController+KeyboardObservers.h"

@implementation UIViewController (KeyboardObservers)

- (void)addKeyboardObservers {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardObservers {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// The callback for frame-changing of keyboard
- (void)keyboardDidShow:(NSNotification *)notification {
  CGFloat height = [self keyboardHeight:notification];

  [UIView animateWithDuration:.2 animations:^{
    CGRect frame = self.view.frame;
    frame.origin.y = -height / 2;
    self.view.frame = frame;
  }];
}

- (CGFloat)keyboardHeight:(NSNotification *)notification {
  NSDictionary *info = [notification userInfo];
  NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
  CGRect keyboardFrame = [kbFrame CGRectValue];

  return keyboardFrame.size.height;
}

- (void)keyboardWillHide:(NSNotification *)notification {
  [UIView animateWithDuration:.2 animations:^{
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
  }];
}

@end
