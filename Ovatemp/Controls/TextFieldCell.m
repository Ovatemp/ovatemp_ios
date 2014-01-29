//
//  TextFieldCell.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TextFieldCell.h"

@implementation TextFieldCell

- (id)initWithFrame:(CGRect)frame {
  self = [self initWithStyle:0 reuseIdentifier:TEXT_FIELD_CELL_IDENTIFIER];
  if (self) {
    self.frame = frame;
    self.textField = [[UITextField alloc] init];
    [self addSubview:self.textField];
  }
  return self;
}

- (void)didMoveToSuperview {
  self.textField.frame = CGRectMake(SUPERVIEW_SPACING, 0, self.frame.size.width - SUPERVIEW_SPACING * 2, self.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  if (selected) {
    [self.textField becomeFirstResponder];
  }
}

@end
