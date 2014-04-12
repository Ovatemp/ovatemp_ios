//
//  GradientButton.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/7/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "GradientButton.h"

#import "UIColor+Traits.h"

static UIColor *kStartColor;
static UIColor *kEndColor;
static UIColor *kPressedStartColor;
static UIColor *kPressedEndColor;

@interface GradientButton () {
  CGSize targetSize;
  CGPoint start;
  CGPoint end;
}
@end

@implementation GradientButton

+ (void)initialize {
  kStartColor = GRADIENT_BLUE;
  kEndColor = GRADIENT_PINK;
  CGFloat darkenBy = 0.3;
  kPressedStartColor = [kStartColor darkenBy:darkenBy];
  kPressedEndColor = [kEndColor darkenBy:darkenBy];
}

# pragma mark - Setup

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self configureDefaults];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self configureDefaults];
  }
  return self;
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  [self configureDefaults];
}

- (void)sizeToFit {
  [super sizeToFit];
  [self configureDefaults];
}

# pragma mark - Drawing gradient text colors

- (void)configureDefaults {
  if (!self.titleLabel.text.length) {
    return;
  }

  NSDictionary *fontAttributes = @{NSFontAttributeName: self.titleLabel.font};
  targetSize = [self.titleLabel.text sizeWithAttributes:fontAttributes];
  start = CGPointZero;
  end = CGPointMake(targetSize.width, targetSize.height);
  [self setTextColor];
  [self setHighlightedTextColor];
}

- (void)setHighlightedTextColor {
  UIColor *gradient = [self gradientFrom:kPressedStartColor
                                      to:kPressedEndColor];
  [self setTitleColor:gradient forState:UIControlStateSelected];
  [self setTitleColor:gradient forState:UIControlStateHighlighted];
}

- (void)setTextColor {
  UIColor *gradient = [self gradientFrom:kStartColor
                                      to:kEndColor];
  [self setTitleColor:gradient forState:UIControlStateNormal];
}

- (UIColor *)gradientFrom:(UIColor *)startColor to:(UIColor *)endColor {
  return [UIColor gradientWithSize:targetSize
                  fromColor:startColor
              startPosition:start
                    toColor:endColor
                endPosition:end];
}

@end