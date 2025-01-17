//
//  PassthroughScrollView.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "PassthroughScrollView.h"

@implementation PassthroughScrollView

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  UIView* view = [super hitTest:point withEvent:event];
  
  // If a user touches the scrollview above the slider, turn
  // of scrolling temporarily so that we don't delay the
  // slider
  if ([view isKindOfClass:[UISlider class]]) {
    self.scrollEnabled = NO;
  } else {
    self.scrollEnabled = YES;
  }
  return view;
}

@end
