//
//  LastPeriodTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 10/21/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "LastPeriodTableViewCell.h"

@implementation LastPeriodTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.datePicker addTarget:self
                               action:@selector(lastPeriodChanged:)
                     forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)lastPeriodChanged:(UIDatePicker *)sender {
//    NSString *dateString = [NSString stringWithFormat:@"%@ %@, %@", [self.datePicker.date ]]
    self.dateLabel.text = [self.datePicker.date classicDate];
}

@end
