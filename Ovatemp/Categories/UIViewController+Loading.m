//
//  UIViewController+Loading.m
//  Ovatemp
//
//  Created by Flip Sasser on 3/26/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "UIViewController+Loading.h"

static const NSInteger kLoadingViewTag = 1337;

@interface UIViewController ()

@property (readonly) UIView *loadingView;

@end

@implementation UIViewController (Loading)

- (UIView *)loadingView {
  for (UIView *subview in self.view.subviews) {
    if (subview.tag == kLoadingViewTag) {
      return subview;
    }
  }
  return nil;
}

- (void)startLoading {
  [self startLoadingWithSpinnerColor:LIGHT];
}

- (void)startLoadingWithBackground:(UIColor *)backgroundColor spinnerColor:(UIColor *)spinnerColor {
  UIView *loadingView = self.loadingView;
  if (!loadingView) {
    loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    loadingView.backgroundColor = backgroundColor;
    loadingView.tag = kLoadingViewTag;

    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner sizeToFit];
    [loadingView addSubview:spinner];
    spinner.center = loadingView.center;
    spinner.color = spinnerColor;
    [spinner startAnimating];

    [self.view addSubview:loadingView];
  }
}

- (void)startLoadingWithSpinnerColor:(UIColor *)spinnerColor {
  UIColor *background;
  if (spinnerColor.brightness > 0.5) {
    background = DARK;
  } else {
    background = LIGHT;
  }
  [self startLoadingWithBackground:[background colorWithAlphaComponent:0.6] spinnerColor:spinnerColor];
}

- (void)stopLoading {
  [self.loadingView removeFromSuperview];
}

@end
