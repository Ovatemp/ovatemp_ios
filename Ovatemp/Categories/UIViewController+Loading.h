//
//  UIViewController+Loading.h
//  Ovatemp
//
//  Created by Flip Sasser on 3/26/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Loading)

- (void)startLoading;
- (void)startLoadingWithBackground:(UIColor *)backgroundColor spinnerColor:(UIColor *)spinnerColor;
- (void)startLoadingWithSpinnerColor:(UIColor *)spinnerColor;
- (void)stopLoading;

@end
