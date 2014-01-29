//
//  Alert.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Alert.h"

@interface Alert () {
  UIToolbar *_backgroundView;
  NSMutableArray *_buttons;
  UIView *_containerView;
  UILabel *_messageView;
  UILabel *_titleView;
}
@end

@implementation Alert

#pragma mark - Setup

+ (Alert *)errorWithTitle:(NSString *)title message:(NSString *)message {
  Alert *alert = [[self alloc] initWithAlertType:AlertError];
  alert.title = title;
  alert.message = message;
  return alert;
}

+ (Alert *)notificationWithTitle:(NSString *)title message:(NSString *)message {
  Alert *alert = [[self alloc] initWithAlertType:AlertNotification];
  alert.title = title;
  alert.message = message;
  return alert;
}

- (id)initWithAlertType:(AlertType)alertType {
  self = [self init];
  if (self) {
    self.alertType = alertType;
  }
  return self;
}

#pragma mark - Rendering

- (void)willMoveToSuperview:(UIView *)newSuperview {
  [super willMoveToSuperview:newSuperview];

  // Set up a background
  if (!_backgroundView) {
    _backgroundView = [[UIToolbar alloc] init];
    _backgroundView.barStyle = UIBarStyleBlackTranslucent;
    [self addSubview:_backgroundView];
  }
  _backgroundView.frame = newSuperview.bounds;

  // Lay out container
  if (!_containerView) {
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_containerView];
  }

  if (!_titleView) {
    _titleView = [[UILabel alloc] init];
    [_containerView addSubview:_titleView];
  }

  if (!_messageView) {
    _messageView = [[UILabel alloc] init];
    [_containerView addSubview:_messageView];
  }

  CGSize containerSize = CGSizeMake(newSuperview.frame.size.width - SUPERVIEW_SPACING * 2, CGFLOAT_MAX);
  CGFloat textWidth = containerSize.width - SUPERVIEW_SPACING * 2;
  CGSize textSize = CGSizeMake(textWidth, CGFLOAT_MAX);

  _titleView.text = self.title;
  CGSize idealTitleSize = [_titleView sizeThatFits:textSize];
  _titleView.frame = CGRectMake(SUPERVIEW_SPACING, 0, textWidth, idealTitleSize.height);

  _messageView.text = self.message;
  CGSize idealMessageSize = [_messageView sizeThatFits:textSize];
  _messageView.frame = CGRectMake(_titleView.frame.origin.x, CGRectGetMaxY(_titleView.frame) + SIBLING_SPACING, textWidth, idealMessageSize.height);

  containerSize.height = CGRectGetMaxY(_messageView.frame) + SUPERVIEW_SPACING;
  CGFloat containerTop = (newSuperview.frame.size.height - containerSize.height) / 2.0;
  _containerView.frame = CGRectMake(containerTop, SUPERVIEW_SPACING, containerSize.width, containerSize.height);

  NSLog(@"%@ %@ %@", newSuperview, NSStringFromCGRect(_containerView.frame), NSStringFromCGRect(newSuperview.frame));
}

- (void)show {
  id<UIApplicationDelegate> app = [UIApplication sharedApplication].delegate;
  UIWindow *window = app.window;
  self.frame = window.bounds;
  [window addSubview:self];
}

#pragma mark - Buttons

- (void)addButtonWithText:(NSString *)text type:(AlertButtonType)type {
  [self addButtonWithText:text type:type target:nil action:nil];
}

- (void)addButtonWithText:(NSString *)text type:(AlertButtonType)type target:(id)target action:(SEL)action {
  if (!_buttons) {
    _buttons = [NSMutableArray array];
  }

  UIButton *button = [[UIButton alloc] init];
  button.titleLabel.text = text;
  CGFloat red, green, blue;
  red = 1.0;
  green = 1.0;
  blue = 1.0;
  UIColor *backgroundColor;
  switch (type) {
    case AlertButtonDefault:
//      backgroundColor = SweeponYellow;
      break;
    case AlertButtonError:
//      backgroundColor = SweeponRed;
      break;
    case AlertButtonOK:
//      backgroundColor = SweeponGreen;
      break;
  }
  button.backgroundColor = backgroundColor;
  if (target && action) {
    [button addTarget:target action:action forControlEvents:UIControlEventAllEvents];
  }

  [_buttons addObject:button];
}

@end
