//
//  GradientSegmentedControl.h
//  Ovatemp
//
//  Created by Jason Welch on 9/4/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GradientSegmentedControlButton.h"

@interface GradientSegmentedControl : UIView {
  UIBezierPath *borderPath;
}

@property CGFloat borderWidth;
@property CGFloat cornerRadius;

- (GradientSegmentedControlButton *)addButtonWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

@end
