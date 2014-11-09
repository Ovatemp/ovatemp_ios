//
//  TrackingCervicalPositionTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/5/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingCervicalPositionTableViewCell.h"

#import "TrackingViewController.h"

@implementation TrackingCervicalPositionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectedDate = [[NSDate alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didSelectInfoButton:(id)sender {
    [self.delegate pushInfoAlertWithTitle:@"Cervical Position" AndMessage:@"The position of your cervix changes throughout your cycle. When you are not fertile your cervix is low, closed and firm. When fertile your cervix moves up and opens up so that the fittest swimmers reach the egg.\n\nTo learn how to track your cervical position, tap Learn More." AndURL:@"http://google.com"];
}

@end
