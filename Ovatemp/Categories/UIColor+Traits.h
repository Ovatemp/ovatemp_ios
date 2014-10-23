//
//  UIColor+Traits.h
//  Sweepon
//
//  Created by Flip Sasser on 3/6/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Traits)

@property (readonly) CGFloat brightness;

+ (UIColor *)gradientWithSize:(CGSize)size
                    fromColor:(UIColor *)fromColor
                startPosition:(CGPoint)startPosition
                      toColor:(UIColor *)toColor
                  endPosition:(CGPoint)endPosition;

- (UIColor *)darkenBy:(CGFloat)amount;
- (UIColor *)desaturateBy:(CGFloat)amount;

+ (UIColor *)ovatempGreyColor;

@end
