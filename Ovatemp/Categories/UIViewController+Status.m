//
//  UIViewController+Status.m
//  Ovatemp
//
//  Created by Flip Sasser on 5/22/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "UIViewController+Status.h"

static const CGFloat kStatusViewAnimationDuration = 1;
static const NSInteger kStatusViewTag = 1338;

@interface UIViewController ()

@property (readonly) UILabel *statusView;

@end

@implementation UIViewController (Status)

- (UIView *)statusView {
  for (UIView *subview in self.view.subviews) {
    if (subview.tag == kStatusViewTag) {
      return subview;
    }
  }
  return nil;
}

- (void)flashStatus:(NSString *)statusText {
  [self flashStatus:statusText duration:1];
}

- (void)flashStatus:(NSString *)statusText duration:(CGFloat)duration {
  UIView *statusView = self.statusView;
  UILabel *label = statusView.subviews.firstObject;
  if (!statusView) {
    statusView = [[UIView alloc] initWithFrame:self.view.bounds];
    statusView.tag = kStatusViewTag;
    statusView.userInteractionEnabled = NO;

    label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = LIGHT;

    label.layer.backgroundColor = [DARK colorWithAlphaComponent:0.5].CGColor;

    [statusView addSubview:label];
    [self.view addSubview:statusView];
  } else {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideStatus) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeStatusView) object:nil];
    statusView.alpha = 1;
  }
  label.text = statusText;
  [label sizeToFit];

  CGRect frame = label.frame;
  frame.size.height += SUPERVIEW_SPACING;
  frame.size.width += SUPERVIEW_SPACING * 2;
  label.frame = frame;
  label.layer.cornerRadius = frame.size.height / 2;
  label.center = statusView.center;

  [self performSelector:@selector(hideStatus) withObject:nil afterDelay:duration];
}

- (void)hideStatus {
  UIView *statusView = self.statusView;
  if (statusView) {
    [UIView animateWithDuration:kStatusViewAnimationDuration animations:^{
      statusView.alpha = 0;
    } completion:^(BOOL finished) {
      [self performSelector:@selector(removeStatusView) withObject:nil afterDelay:kStatusViewAnimationDuration];
    }];
  }
}

- (void)removeStatusView {
  [self.statusView removeFromSuperview];
}

@end
