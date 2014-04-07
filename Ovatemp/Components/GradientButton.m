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

# pragma mark - Detecting highlighted state

- (void)setHighlighted:(BOOL)highlighted {
  // NOOP
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self setHighlightedTextColor];
  [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [self setTextColor];
  [super touchesEnded:touches withEvent:event];
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
}

- (void)setHighlightedTextColor {
  self.titleLabel.textColor = [self gradientFrom:kPressedStartColor
                                              to:kPressedEndColor];
}

- (void)setTextColor {
  self.titleLabel.textColor = [self gradientFrom:kStartColor
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