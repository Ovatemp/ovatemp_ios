//
//  GradientLabel.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/11/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "GradientLabel.h"

#import "UIColor+Traits.h"

static UIColor *kStartColor;
static UIColor *kEndColor;

@interface GradientLabel () {
  CGSize targetSize;
  CGPoint start;
  CGPoint end;
}
@end

@implementation GradientLabel

+ (void)initialize {
  kStartColor = GRADIENT_BLUE;
  kEndColor = GRADIENT_PINK;
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
  if (!self.text.length) {
    return;
  }
  
  NSDictionary *fontAttributes = @{NSFontAttributeName: self.font};
  targetSize = [self.text sizeWithAttributes:fontAttributes];
  start = CGPointZero;
  end = CGPointMake(targetSize.width, targetSize.height);
  [self setGradientTextColor];
}

- (void)setGradientTextColor {
  self.textColor = [self gradientFrom:kStartColor
                                   to:kEndColor];
}

- (UIColor *)gradientFrom:(UIColor *)startColor to:(UIColor *)endColor {
  return [UIColor gradientWithSize:targetSize
                         fromColor:startColor
                     startPosition:start
                           toColor:endColor
                       endPosition:end];
}

@end
