//
//  WelcomeInfoTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 10/21/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "WelcomeInfoTableViewCell.h"

@implementation WelcomeInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.textLabel.frame;
    frame.size.width -= 150; // fix text label cutting off text field
    self.textLabel.frame = frame;
}

@end
