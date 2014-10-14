//
//  GradientSegmentedControl.m
//  Ovatemp
//
//  Created by Jason Welch on 9/4/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "GradientSegmentedControl.h"

@interface GradientSegmentedControl () {
  NSMutableArray *_buttons;
  NSArray *_dividers;
  CGFloat _borderWidth;
  CGFloat _cornerRadius;
  UIColor *gradient;
}
@end

@implementation GradientSegmentedControl

# pragma mark - Watching the frame

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

#pragma mark - Adding Buttons

- (GradientSegmentedControlButton *)addButtonWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
  GradientSegmentedControlButton *button = [GradientSegmentedControlButton buttonWithType:UIButtonTypeCustom];
  button.titleLabel.numberOfLines = 0;
  button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
  button.titleLabel.textAlignment = NSTextAlignmentCenter;

  NSMutableAttributedString *attributedTitle;
  UIFont *titleFont = [UIFont boldSystemFontOfSize:12.0f];
  NSDictionary *baseAttributes = @{NSFontAttributeName: titleFont};

  if (subtitle) {
    NSString *fullTitle = [title stringByAppendingFormat:@"\n%@", subtitle];
    NSRange subtitleRange = NSMakeRange(title.length + 1, subtitle.length);
    UIFont *subtitleFont = [UIFont boldSystemFontOfSize:8.0f];
    attributedTitle = [[NSMutableAttributedString alloc] initWithString:fullTitle attributes:baseAttributes];
    [attributedTitle addAttribute:NSFontAttributeName value:subtitleFont range:subtitleRange];
  } else {
    attributedTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:baseAttributes];
  }

  [button setAttributedTitle:attributedTitle forState:UIControlStateNormal];
  button.index = _buttons.count;

  if (!_buttons) {
    _buttons = [NSMutableArray array];
  }
  [_buttons addObject:button];
  [self addSubview:button];

  return button;
}

# pragma mark - Properties

- (CGFloat)borderWidth {
  if (!isnormal(_borderWidth)) {
    return 1.0f;
  } else {
    return _borderWidth;
  }
}

- (void)setBorderWidth:(CGFloat)borderWidth {
  _borderWidth = borderWidth;
  [self buildBorderPath];
}

- (CGFloat)cornerRadius {
  if (!isnormal(_cornerRadius)) {
    return 3.0f;
  } else {
    return _cornerRadius;
  }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  _cornerRadius = cornerRadius;
  [self buildBorderPath];
}

# pragma mark - Drawing helpers

- (void)buildBorderPath {
  CGRect bounds = self.bounds;
  bounds = CGRectInset(bounds, 0.5, 0.5);
  borderPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:self.cornerRadius];
  borderPath.lineWidth = self.borderWidth;
}

- (void)buildGradient {
  gradient = [UIColor gradientWithSize:self.bounds.size
                             fromColor:GRADIENT_BLUE
                         startPosition:CGPointZero
                               toColor:GRADIENT_PINK
                           endPosition:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
}

- (void)configureDefaults {
  self.layer.cornerRadius = self.cornerRadius;
  self.layer.masksToBounds = YES;
  [self buildBorderPath];
  [self buildGradient];
}

// Reused to draw the same sized line at whichever x starting point
- (UIBezierPath*)makeDividerWithXOrigin:(CGFloat)x {
  UIBezierPath *bezierPath = [UIBezierPath bezierPath];
  [bezierPath moveToPoint:CGPointMake(x, 0)];
  [bezierPath addLineToPoint:CGPointMake(x, self.bounds.size.height)];
  [bezierPath closePath];
  bezierPath.lineWidth = self.borderWidth;
  return bezierPath;
}

# pragma mark - Drawing

// Allows the lines to blend into one solid block when pressed
- (void)drawRect:(CGRect)rect {
  if (gradient && _dividers.count > 0) {
    [gradient setStroke];
    [borderPath stroke];

    [_dividers makeObjectsPerformSelector:@selector(stroke)];
  }
}

- (void)layoutSubviews {
  if (_buttons.count > 0) {
    NSMutableArray *addedDividers = [NSMutableArray arrayWithCapacity:_buttons.count];

    CGFloat buttonWidth = self.frame.size.width / _buttons.count;
    CGRect buttonFrame = CGRectMake(0, 0, buttonWidth, self.frame.size.height);
    for (GradientSegmentedControlButton *button in _buttons) {
      button.frame = buttonFrame;
      if (buttonFrame.origin.x > 0) {
        [addedDividers addObject:[self makeDividerWithXOrigin:buttonFrame.origin.x]];
      }
      buttonFrame.origin.x += buttonWidth;
    }

    _dividers = [NSArray arrayWithArray:addedDividers];

    [self setNeedsDisplay];
  }
}

@end