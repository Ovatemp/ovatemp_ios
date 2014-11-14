//
//  TrackingPeriodTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/6/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingPeriodTableViewCell.h"
#import "ConnectionManager.h"
#import "Cycle.h"
#import "Calendar.h"
#import "Alert.h"

#import "TrackingViewController.h"

@implementation TrackingPeriodTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectedDate = [[NSDate alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didSelectNone:(id)sender {
    if (self.selectedPeriodType == PeriodSelectionNone) {
        self.selectedPeriodType = PeriodSelectionNoSelection;
        [self hitBackendWithPeriodType:[NSNull null]];
        [self deselectAllButtons];
        self.periodTypeCollapsedLabel.text = @"";
    } else {
        self.selectedPeriodType = PeriodSelectionNone;
        self.periodTypeCollapsedLabel.text = @"None";
        self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_none"];
        [self hitBackendWithPeriodType:@"none"];
        
        [self deselectAllButtons];
        [self.noneImageView setSelected:YES];
    }
}

- (IBAction)didSelectSpotting:(id)sender {
    if (self.selectedPeriodType == PeriodSelectionSpotting) {
        self.selectedPeriodType = PeriodSelectionNoSelection;
        [self hitBackendWithPeriodType:[NSNull null]];
        [self deselectAllButtons];
        self.periodTypeCollapsedLabel.text = @"";
    } else {
        self.selectedPeriodType = PeriodSelectionSpotting;
        self.periodTypeCollapsedLabel.text = @"Spotting";
        self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_spotting"];
        [self hitBackendWithPeriodType:@"spotting"];
        
        [self deselectAllButtons];
        [self.spottingImageView setSelected:YES];
    }
}

- (IBAction)didSelectLight:(id)sender {
    if (self.selectedPeriodType == PeriodSelectionLight) {
        self.selectedPeriodType = PeriodSelectionNoSelection;
        [self hitBackendWithPeriodType:[NSNull null]];
        [self deselectAllButtons];
        self.periodTypeCollapsedLabel.text = @"";
    } else {
        self.selectedPeriodType = PeriodSelectionLight;
        self.periodTypeCollapsedLabel.text = @"Light";
        self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_light"];
        [self hitBackendWithPeriodType:@"light"];
        
        [self deselectAllButtons];
        [self.lightImageView setSelected:YES];
    }
}

- (IBAction)didSelectMedium:(id)sender {
    if (self.selectedPeriodType == PeriodSelectionMedium) {
        self.selectedPeriodType = PeriodSelectionNoSelection;
        [self hitBackendWithPeriodType:[NSNull null]];
        [self deselectAllButtons];
        self.periodTypeCollapsedLabel.text = @"";
    } else {
        self.selectedPeriodType = PeriodSelectionMedium;
        self.periodTypeCollapsedLabel.text = @"Medium";
        self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_medium"];
        [self hitBackendWithPeriodType:@"medium"];
        
        [self deselectAllButtons];
        [self.mediumImageView setSelected:YES];
    }
}

- (IBAction)didSelectHeavy:(id)sender {
    if (self.selectedPeriodType == PeriodSelectionHeavy) {
        self.selectedPeriodType = PeriodSelectionNoSelection;
        [self hitBackendWithPeriodType:[NSNull null]];
        [self deselectAllButtons];
        self.periodTypeCollapsedLabel.text = @"";
    } else {
        self.selectedPeriodType = PeriodSelectionHeavy;
        self.periodTypeCollapsedLabel.text = @"Heavy";
        self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_heavy"];
        [self hitBackendWithPeriodType:@"heavy"];
        
        [self deselectAllButtons];
        [self.heavyImageView setSelected:YES];
    }
}

- (void)deselectAllButtons {
    [self.noneImageView setSelected:NO];
    [self.spottingImageView setSelected:NO];
    [self.lightImageView setSelected:NO];
    [self.mediumImageView setSelected:NO];
    [self.heavyImageView setSelected:NO];
}

- (void)hitBackendWithPeriodType:(id)periodType {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setObject:periodType forKey:@"period"];
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
    [self.delegate pushInfoAlertWithTitle:@"Period" AndMessage:@"Your period can last for 3 to 7 days and represents the beginning of a new cycle. You should always consider the first day of bleeding as your Cycle Day 1.  Spotting does not count." AndURL:@"http://ovatemp.helpshift.com/a/ovatemp/?s=fertility-faqs&f=learn-more-about-your-period"];
}

@end
