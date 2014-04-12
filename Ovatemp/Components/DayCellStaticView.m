//
//  DayCellStaticView.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/11/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "DayCellStaticView.h"

#import "DayAttribute.h"
#import "GradientLabel.h"

@interface DayCellStaticView () {
  DayAttribute *_attribute;
  UILabel *_choiceLabel;
  GradientLabel *_slideToEditLabel;
  UIImageView *_imageView;
  UILabel *_label;
  UITextView *_textView;
}

@property (readonly) UILabel *choiceLabel;
@property (readonly) UIImageView *imageView;
@property (readonly) GradientLabel *slideToEditLabel;
@property (readonly) UITextView *textView;

@end

@implementation DayCellStaticView

# pragma mark - Setup

- (DayAttribute *)attribute {
  return _attribute;
}

- (void)setAttribute:(DayAttribute *)attribute {
  _attribute = attribute;
  self.label.text = attribute.title;
  [self.label sizeToFit];
}

# pragma mark - UI elements

- (UILabel *)choiceLabel {
  if (!_choiceLabel) {
    _choiceLabel = [[UILabel alloc] init];
    _choiceLabel.font = [UIFont systemFontOfSize:18.0f];
    _choiceLabel.adjustsFontSizeToFitWidth = YES;
    _choiceLabel.minimumScaleFactor = 0.5;
    _choiceLabel.text = @"!_jGjH08";
    [_choiceLabel sizeToFit];
    [self addSubview:_choiceLabel];
  }
  return _choiceLabel;
}

- (UIImageView *)imageView {
  if (!_imageView) {
    CGRect frame = CGRectMake(0, CGRectGetMaxY(_label.frame) + SIBLING_SPACING, 52, 52);
    _imageView = [[UIImageView alloc] initWithFrame:frame];
    _imageView.contentMode = UIViewContentModeLeft;
    [self addSubview:_imageView];
  }
  return _imageView;
}

- (UILabel *)label {
  if (!_label) {
    _label = [[UILabel alloc] init];
    _label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f];
    _label.textColor = DARK;
    [self addSubview:_label];
  }
  return _label;
}

- (GradientLabel *)slideToEditLabel {
  if (!_slideToEditLabel) {
    _slideToEditLabel = [[GradientLabel alloc] init];
    _slideToEditLabel.font = [UIFont systemFontOfSize:17.0f];
    _slideToEditLabel.adjustsFontSizeToFitWidth = YES;
    _slideToEditLabel.minimumScaleFactor = 0.5;
    _slideToEditLabel.text = @"❮ slide to change";
    _slideToEditLabel.textAlignment = NSTextAlignmentCenter;
    [_slideToEditLabel sizeToFit];
    CGRect frame = _slideToEditLabel.frame;
    CGFloat maxWidth = self.frame.size.width - SUPERVIEW_SPACING;
    if (frame.size.width > maxWidth) {
      frame.size.width = maxWidth;
      _slideToEditLabel.frame = frame;
    }
    [self addSubview:_slideToEditLabel];
  }
  return _slideToEditLabel;
}

- (UITextView *)textView {
  if (!_textView) {
    _textView = [[UITextView alloc] init];
    _textView.editable = NO;
    _textView.font = [UIFont systemFontOfSize:12.0f];
    _textView.selectable = NO;
    CGFloat top = CGRectGetMaxY(self.label.frame) + SIBLING_SPACING;
    CGRect frame = CGRectMake(0, top,
                              self.frame.size.width, self.frame.size.height - top);
    _textView.frame = frame;
    [self addSubview:_textView];
  }
  return _textView;
}

# pragma mark - Changing selection

- (void)setChoice:(NSString *)choice {
  if (choice.length) {
    [self hideSlideToEdit];
    self.imageView.image = [UIImage imageNamed:choice];
    self.choiceLabel.text = choice.capitalizedString;
    
    CGRect imageFrame = self.imageView.frame;
    CGFloat left;
    
    if (self.solitary) {
      self.choiceLabel.font = [UIFont systemFontOfSize:17.0f];
      [self.choiceLabel sizeToFit];
      CGFloat imageOffset = self.imageView.frame.size.width + SIBLING_SPACING;
      CGFloat fullWidth = imageOffset + self.choiceLabel.frame.size.width;
      CGFloat center = (self.frame.size.width - fullWidth) / 2;
      left = center + imageOffset;
      
      imageFrame.origin.x = center;
    } else {
      self.choiceLabel.font = [UIFont systemFontOfSize:13.0f];
      [self.choiceLabel sizeToFit];
      left = CGRectGetMaxX(self.imageView.frame);
    }
    
    // Center the image view in the available whitespace
    imageFrame.origin.y = (self.frame.size.height - imageFrame.size.height) / 2 + CGRectGetMaxY(self.label.frame);
    self.imageView.frame = imageFrame;
    
    // Center the choice label vertically on the image view, wherever it appears
    CGFloat top = CGRectGetMidY(self.imageView.frame) - self.label.frame.size.height / 2;
    self.choiceLabel.frame = CGRectMake(left, top,
                                        self.frame.size.width - left,
                                        _choiceLabel.frame.size.height);
    
  } else {
    self.imageView.image = nil;
    self.choiceLabel.text = nil;
    [self showSlideToEdit];
  }
}

- (void)setSelectedChoices:(NSArray *)selectedChoices {
  if (selectedChoices.count) {
    self.textView.text = [[selectedChoices valueForKey:@"name"] componentsJoinedByString:@", "];
    [self hideSlideToEdit];
  } else {
    self.textView.text = nil;
    [self showSlideToEdit];
  }
}

- (void)setValue:(id)value {
  if (value) {
    [self hideSlideToEdit];
  } else {
    [self showSlideToEdit];
  }
}

# pragma mark - Slide-to-edit

- (void)hideSlideToEdit {
  self.slideToEditLabel.hidden = YES;
}

- (void)showSlideToEdit {
  CGRect frame = self.slideToEditLabel.frame;
  // Center the "slide to change" label in the whitespace BELOW the title label,
  // rather than in the entire frame
  frame = CGRectMake((self.frame.size.width - frame.size.width) / 2,
                     (self.frame.size.height - frame.size.height) / 2 + CGRectGetMaxY(self.label.frame),
                     frame.size.width, frame.size.height);
  self.slideToEditLabel.frame = frame;
  self.slideToEditLabel.hidden = NO;
}

@end
