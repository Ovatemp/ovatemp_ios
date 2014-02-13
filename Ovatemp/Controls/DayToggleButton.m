//
//  DayToggleButton.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "DayToggleButton.h"
#define kDayToggleButtonTextPadding 10.0f

@implementation DayToggleButton

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];

  if (self) {
    UIImage *selectedImage = [UIImage imageNamed:@"MPArrowLeft"];
    UIImage *normalImage = [UIImage imageNamed:@"MPArrowRight.png"];

    NSLog(@"selected %@ normal %@", selectedImage, normalImage);

    [self setImage:selectedImage forState:UIControlStateSelected];
    [self setImage:normalImage forState:UIControlStateNormal];
  }
  return self;
}

-(void)layoutSubviews {
  [super layoutSubviews];

  // Move the image to the top and center it horizontally
  CGRect imageFrame = self.imageView.frame;
  imageFrame.origin.y = 0;
  imageFrame.origin.x = (self.frame.size.width / 2) - (imageFrame.size.width / 2);
  self.imageView.frame = imageFrame;

  // Adjust the label size to fit the text, and move it below the image
  CGRect titleLabelFrame = self.titleLabel.frame;

  CGSize maximumLabelSize = CGSizeMake(310, 9999);
  self.titleLabel.numberOfLines = 0;
  CGSize labelSize = [self.titleLabel sizeThatFits:maximumLabelSize];

  titleLabelFrame.size = labelSize;
  titleLabelFrame.origin.x = (self.frame.size.width / 2) - (labelSize.width / 2);
  titleLabelFrame.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height + kDayToggleButtonTextPadding;
  self.titleLabel.frame = titleLabelFrame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
