//
//  TrackingPregnancyTestTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/10/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingPregnancyTestTableViewCell.h"
#import "TrackingViewController.h"

#import "Calendar.h"
#import "Alert.h"

@implementation TrackingPregnancyTestTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectedDate = [[NSDate alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)deselectAllButtons {
    [self.pregnancyTypeNegativeImageView setSelected:NO];
    [self.pregnancyTypePositiveImageView setSelected:NO];
}

- (IBAction)didSelectNegative:(id)sender {
    if (self.selectedPregnancyTestType == PregnancyTestSelectionNegative) {
        self.selectedPregnancyTestType = PregnancyTestSelectionNone;
        [self hitBackendWithPregnancyTestType:[NSNull null]];
        [self deselectAllButtons];
    } else {
        self.selectedPregnancyTestType = PregnancyTestSelectionNegative;
        [self hitBackendWithPregnancyTestType:@"negative"];
        self.pregnancyTypeCollapsedLabel.text = @"Negative";
        self.pregnancyTypeImageView.image = [UIImage imageNamed:@"icn_negative"];
        
        [self deselectAllButtons];
        [self.pregnancyTypeNegativeImageView setSelected:YES];
    }
}
- (IBAction)didSelectPositive:(id)sender {
}

- (void)hitBackendWithPregnancyTestType:(id)ptType {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setObject:ptType forKey:@"ferning"];
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
    [self.delegate pushInfoAlertWithTitle:@"Pregnancy Test" AndMessage:@"A home pregnancy test detects the human chorionic gonadotropin (hCG) hormone in urine.\n\nWe recommend you take a pregnancy test after 18 high temperatures or 3 days after you missed your period." AndURL:@"http://ovatemp.helpshift.com/a/ovatemp/?s=fertility-faqs&f=learn-more-about-pregnancy-tests"];
}
@end
