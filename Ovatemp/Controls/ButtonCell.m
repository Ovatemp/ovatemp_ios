//
//  ButtonCell.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "ButtonCell.h"

@implementation ButtonCell

- (id)initWithFrame:(CGRect)frame {
  self = [self initWithStyle:0 reuseIdentifier:BUTTON_CELL_IDENTIFIER];
  if (self) {
    self.frame = frame;
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:self.button];
  }
  return self;
}

- (void)didMoveToSuperview {
  self.button.frame = CGRectMake(SUPERVIEW_SPACING, 0, self.frame.size.width - SUPERVIEW_SPACING * 2, self.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

@end
