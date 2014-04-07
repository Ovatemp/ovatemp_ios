//
//  RoundedButton.h
//  Ovatemp
//
//  Created by Flip Sasser on 4/7/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundedButton : UIButton {
  UIBezierPath *_backgroundPath;
  UIColor *_borderColor;
}

@property CGFloat cornerRadius;
@property NSInteger index;
@property NSInteger siblings;

@end
