//
//  TrackingPregnancyTestTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/10/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingPregnancyTestTableViewCell.h"
#import "TrackingViewController.h"

@implementation TrackingPregnancyTestTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectedDate = [[NSDate alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didSelectNegative:(id)sender {
}
- (IBAction)didSelectPositive:(id)sender {
}
- (IBAction)didSelectInfoButton:(id)sender {
    [self.delegate pushInfoAlertWithTitle:@"Pregnancy Test" AndMessage:@"A home pregnancy test detects the human chorionic gonadotropin (hCG) hormone in urine.\n\nWe recommend you take a pregnancy test after 18 high temperatures or 3 days after you missed your period." AndURL:@"http://google.com"];
}
@end
