//
//  SettingsTemperatureTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 10/16/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SettingsTemperatureTableViewCell.h"

@implementation SettingsTemperatureTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.textLabel.textColor = [UIColor ovatempGreyColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.textLabel.frame;
    frame.size.width -= 60; // fix text label cutting off segmented control
    self.textLabel.frame = frame;
}

@end
