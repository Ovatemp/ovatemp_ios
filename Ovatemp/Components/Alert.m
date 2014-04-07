//
//  Alert.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Alert.h"

#import "RoundedButton.h"

@interface Alert () {
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

- (void)hide {
  [self hide:nil];
}

- (void)hide:(id)sender {
  [self removeFromSuperview];
}

- (void)show {
  id<UIApplicationDelegate> app = [UIApplication sharedApplication].delegate;
  UIWindow *window = app.window;
  self.frame = window.bounds;
  for (UIView *view in window.subviews) {
    [view endEditing:YES];
  }
  self.alpha = 0;
  [window addSubview:self];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
  [super willMoveToSuperview:newSuperview];

  // Lay out container
  if (!_containerView) {
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor clearColor];
    _containerView.layer.backgroundColor = LIGHT.CGColor;
    _containerView.layer.cornerRadius = 3.0f;
    _containerView.layer.shadowColor = DARK.CGColor;
    _containerView.layer.shadowOffset = CGSizeMake(0, 1.0f);
    _containerView.layer.shadowOpacity = 0.5f;
    _containerView.layer.shadowRadius = 2.0f;
    [self addSubview:_containerView];
  }

  if (!_titleView) {
    _titleView = [[UILabel alloc] init];
    _titleView.adjustsFontSizeToFitWidth = YES;
//    _titleView.backgroundColor = self.alertType == AlertError ? RED : GREEN;
    _titleView.font = [UIFont boldSystemFontOfSize:17.0f];
    _titleView.minimumScaleFactor = 0.5;
    _titleView.numberOfLines = 0;
    _titleView.lineBreakMode = NSLineBreakByWordWrapping;
    _titleView.textAlignment = NSTextAlignmentLeft;
    _titleView.textColor = DARK;
    [_containerView addSubview:_titleView];
  }

  if (!_messageView) {
    _messageView = [[UILabel alloc] init];
    _messageView.lineBreakMode = NSLineBreakByWordWrapping;
    _messageView.numberOfLines = 0;
    [_containerView addSubview:_messageView];
  }

  CGSize containerSize = CGSizeMake(newSuperview.frame.size.width - SUPERVIEW_SPACING * 2, CGFLOAT_MAX);
  CGFloat textWidth = containerSize.width - SUPERVIEW_SPACING * 2;
  CGSize textSize = CGSizeMake(textWidth, CGFLOAT_MAX);

  _titleView.text = self.title;
  [_titleView sizeToFit];
  CGSize idealTitleSize = [_titleView sizeThatFits:textSize];
  idealTitleSize.height += SUPERVIEW_SPACING;
  _titleView.frame = CGRectMake(SUPERVIEW_SPACING, SUPERVIEW_SPACING,
                                idealTitleSize.width, idealTitleSize.height);

  _messageView.text = self.message;
  [_messageView sizeToFit];
  CGSize idealMessageSize = [_messageView sizeThatFits:textSize];
  _messageView.frame = CGRectMake(SUPERVIEW_SPACING,
                                  CGRectGetMaxY(_titleView.frame) + SIBLING_SPACING,
                                  textWidth, idealMessageSize.height);
  _messageView.isAccessibilityElement = TRUE;
  _messageView.accessibilityLabel = @"Alert Message";
  _messageView.accessibilityValue = self.message;

  CGFloat buttonWidth = containerSize.width / _buttons.count;
  CGFloat buttonTop = CGRectGetMaxY(_messageView.frame) + SUPERVIEW_SPACING;

  for (NSInteger i = 0; i < _buttons.count; i++) {
    RoundedButton *button = _buttons[i];
    [button sizeToFit];
    button.frame = CGRectMake(i * buttonWidth, buttonTop, buttonWidth, button.frame.size.height);
    if (!button.superview) {
      [_containerView addSubview:button];
    }
    containerSize.height = CGRectGetMaxY(button.frame);
  }

  CGFloat containerTop = (newSuperview.frame.size.height - containerSize.height) / 2.0;
  _containerView.frame = CGRectMake(SUPERVIEW_SPACING, containerTop, containerSize.width, containerSize.height);
}

- (void)didMoveToSuperview {
  [super didMoveToSuperview];
  [UIView animateWithDuration:0.3 animations:^{
    self.alpha = 1;
  }];
}

#pragma mark - Buttons

- (void)addButtonWithText:(NSString *)text type:(AlertButtonType)type {
  [self addButtonWithText:text type:type target:nil action:nil];
}

- (void)addButtonWithText:(NSString *)text type:(AlertButtonType)type target:(id)target action:(SEL)action {
  if (!_buttons) {
    _buttons = [NSMutableArray array];
  }

  RoundedButton *button = [[RoundedButton alloc] initWithFrame:CGRectZero];
  [button setTitle:text forState:UIControlStateNormal];
  button.isAccessibilityElement = TRUE;
  button.accessibilityLabel = text;
  button.cornerRadius = 3.0f;
  [button addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
  if (target && action) {
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  }

  CGFloat red, green, blue;
  red = 1.0;
  green = 1.0;
  blue = 1.0;
  UIColor *backgroundColor;
  switch (type) {
    case AlertButtonDefault:
      backgroundColor = BLUE;
      break;
    case AlertButtonError:
      backgroundColor = LIGHT;
      break;
    case AlertButtonOK:
      backgroundColor = DARK_BLUE;
      break;
  }
  button.backgroundColor = backgroundColor;

  [_buttons addObject:button];
  [self resetButtonIndices];
}

- (void)resetButtonIndices {
  for (NSInteger i = 0; i < _buttons.count; i++) {
    RoundedButton *button = _buttons[i];
    button.index = i;
    button.siblings = _buttons.count;
  }
}

@end
