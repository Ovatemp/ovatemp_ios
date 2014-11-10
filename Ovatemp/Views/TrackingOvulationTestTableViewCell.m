//
//  TrackingOvulationTestTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/9/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingOvulationTestTableViewCell.h"

#import "TrackingViewController.h"

@implementation TrackingOvulationTestTableViewCell

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
    [self.delegate pushInfoAlertWithTitle:@"Ovulation Test" AndMessage:@"Ovulation tests detect a surge in Luteinizing Hormone (LH) and can help you time intercourse during ovulation to achieve pregnancy.\n\nNot recommended for birth control since sperm can last days in optimal conditions and it would be risky." AndURL:@"http://google.com"];
}

@end
