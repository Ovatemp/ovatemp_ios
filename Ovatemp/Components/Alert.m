//
//  Alert.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Alert.h"

@interface Alert () {
  NSMutableArray *_buttons;
}

@property (readonly) NSMutableArray *buttons;

@end

static NSMutableDictionary *kAlerts;

static NSString * const kCallbackKey = @"callback";
static NSString * const kSelectorKey = @"selector";
static NSString * const kTargetKey = @"target";
static NSString * const kTitleKey = @"title";

@implementation Alert

# pragma mark - Setup

+ (Alert *)alertForError:(NSError *)error {
  NSString *title = @"Something Went Wrong!";

  NSString *message = [error.userInfo objectForKey:@"error"];

  if (!message) {
    message = error.localizedDescription;
  }
  if (!message || message.isNull) {
    message = @"We're not 100% sure what, but we've been notified and will fix it shortly.";
  }
  
  return [Alert alertWithTitle:title message:message];
}

+ (Alert *)alertWithTitle:(NSString *)title message:(NSString *)message {
  Alert *alert = [[self alloc] init];
  alert.title = title;
  alert.message = message;
  if (!kAlerts) {
    kAlerts = [NSMutableDictionary dictionary];
  }
  kAlerts[alert.description] = alert;
  return alert;
}

+ (Alert *)presentError:(NSError *)error {
  Alert *alert = [self alertForError:error];
  [alert addButtonWithTitle:@"Okay"];
  [alert show];
  return alert;
}

+ (Alert *)showAlertWithTitle:(NSString *)title message:(NSString *)message {
  Alert *alert = [self alertWithTitle:title message:message];
  [alert show];
  return alert;
}

# pragma mark - Rendering

- (void)hide {
  [self hide:nil];
}

- (void)hide:(id)sender {
  [self.view dismissWithClickedButtonIndex:0 animated:NO];
}

- (void)show {
  NSString *cancelButton = @"Okay";
  if (_buttons.count) {
    NSDictionary *button = _buttons.firstObject;
    cancelButton = button[kTitleKey];
  }
  
  self.view = [[UIAlertView alloc] initWithTitle:self.title
                                              message:self.message
                                             delegate:self
                                    cancelButtonTitle:cancelButton
                                    otherButtonTitles:nil];
  for (NSInteger i = 1; i < _buttons.count; i++) {
    NSDictionary *button = _buttons[i];
    [self.view addButtonWithTitle:button[kTitleKey]];
  }

  self.view.alertViewStyle = self.alertViewStyle;

  [self.view show];
}

# pragma mark - Buttons

- (void)addButtonWithTitle:(NSString *)title {
  [self addButtonWithTitle:title callback:nil];
}

- (void)addButtonWithTitle:(NSString *)title callback:(AlertCallback)callback {
  NSMutableDictionary *button = [self buttonWithTitle:title];
  
  if (callback) {
    button[kCallbackKey] = callback;
  }
  
  [self.buttons addObject:button];
}

- (void)addButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
  NSMutableDictionary *button = [self buttonWithTitle:title];
  
  if (target && action) {
    button[kTargetKey] = target;
    button[kSelectorKey] = NSStringFromSelector(action);
  }
  
  [self.buttons addObject:button];
}

- (NSMutableDictionary *)buttonWithTitle:(NSString *)title {
  NSMutableDictionary *button = [NSMutableDictionary dictionaryWithCapacity:3];
  button[kTitleKey] = title;
  return button;
}

- (NSMutableArray *)buttons {
  if (!_buttons) {
    _buttons = [NSMutableArray array];
  }
  return _buttons;
}

# pragma mark - Alert view delegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if (self.buttons.count) {
    NSDictionary *button = [self.buttons objectAtIndex:buttonIndex];
    if (button[kTargetKey]) {
      id target = button[kTargetKey];
      SEL action = NSSelectorFromString(button[kSelectorKey]);
      [target performSelectorOnMainThread:action withObject:alertView waitUntilDone:YES];
    } else if (button[kCallbackKey]) {
      AlertCallback callback = button[kCallbackKey];
      callback();
    }
  }
  [kAlerts removeObjectForKey:self.description];
}

@end
