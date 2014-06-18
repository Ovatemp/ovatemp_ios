//
//  BorderedGradientButton.h
//  Ovatemp
//
//  Created by Flip Sasser on 4/7/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "GradientButton.h"

@interface BorderedGradientButton : GradientButton {
  UIBezierPath *borderPath;
}

@property CGFloat borderWidth;
@property CGFloat cornerRadius;

- (void)buildBorderPath;

@end
