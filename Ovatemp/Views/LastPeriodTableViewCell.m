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
    
    // min and max date
    self.datePicker.maximumDate = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-1];
    self.datePicker.minimumDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    
    self.lastPeriodLabel.textColor = [UIColor ovatempGreyColor];
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