//
//  TrackingOvulationTestTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/9/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingOvulationTestTableViewCell.h"

#import "TrackingViewController.h"

#import "Calendar.h"
#import "Alert.h"

@implementation TrackingOvulationTestTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectedDate = [[NSDate alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) deselectAllButtons {
    [self.ovulationTypeNegativeImageView setSelected:NO];
    [self.ovulationTypePositiveImageView setSelected:NO];
}

- (IBAction)didSelectNegative:(id)sender {
    if (self.selectedOvulationTestType == OvulationTestSelectionNegative) {
        self.selectedOvulationTestType = OvulationTestSelectionNone;
        [self hitBackendWithOvulationTestType:[NSNull null]];
        [self deselectAllButtons];
        self.ovulationTypeCollapsedLabel.text = @"";
    } else {
        self.selectedOvulationTestType = OvulationTestSelectionNegative;
        [self hitBackendWithOvulationTestType:@"negative"];
        self.ovulationTypeCollapsedLabel.text = @"Negative";
        self.ovulationTypeImageView.image = [UIImage imageNamed:@"icn_negative"];
        
        [self deselectAllButtons];
        [self.ovulationTypeNegativeImageView setSelected:YES];
    }
}

- (IBAction)didSelectPositive:(id)sender {
    if (self.selectedOvulationTestType == OvulationTestSelectionPositive) {
        self.selectedOvulationTestType = OvulationTestSelectionNone;
        [self hitBackendWithOvulationTestType:[NSNull null]];
        [self deselectAllButtons];
        self.ovulationTypeCollapsedLabel.text = @"";
    } else {
        self.selectedOvulationTestType = OvulationTestSelectionPositive;
        [self hitBackendWithOvulationTestType:@"positive"];
        self.ovulationTypeCollapsedLabel.text = @"Positive";
        self.ovulationTypeImageView.image = [UIImage imageNamed:@"icn_positive"];
        
        [self deselectAllButtons];
        [self.ovulationTypePositiveImageView setSelected:YES];
    }
}

- (void)hitBackendWithOvulationTestType:(id)otType {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setObject:otType forKey:@"opk"];
    [attributes setObject:self.selectedDate forKey:@"date"];
    
    [ConnectionManager put:@"/days/"
                    params:@{
                             @"day": attributes,
                             }
                   success:^(NSDictionary *response) {
                       [Cycle cycleFromResponse:response];
                       [Calendar setDate:self.selectedDate];
                       //                       if (onSuccess) onSuccess(response);
                   }
                   failure:^(NSError *error) {
                       [Alert presentError:error];
                   }];
}

- (IBAction)didSelectInfoButton:(id)sender {
    [self.delegate pushInfoAlertWithTitle:@"Ovulation Test" AndMessage:@"Ovulation tests detect a surge in Luteinizing Hormone (LH) and can help you time intercourse during ovulation to achieve pregnancy.\n\nNot recommended for birth control since sperm can last days in optimal conditions and it would be risky." AndURL:@"http://ovatemp.helpshift.com/a/ovatemp/?s=fertility-faqs&f=learn-more-about-ovulation-tests"];
}

@end
