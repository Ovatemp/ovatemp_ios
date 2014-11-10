//
//  TrackingCervicalFluidTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/5/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingCervicalFluidTableViewCell.h"
#import "Alert.h"
#import "ConnectionManager.h"
#import "Cycle.h"
#import "Calendar.h"

#import "TrackingViewController.h"

@implementation TrackingCervicalFluidTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectedDate = [[NSDate alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didSelectDry:(id)sender {
    if (self.selectedCervicalFluidType == CervicalFluidSelectionDry) { // deselect
        self.selectedCervicalFluidType = CervicalFluidSelectionNone;
        [self hitBackendWithCervicalFluidType:[NSNull null]];
    } else {
        self.selectedCervicalFluidType = CervicalFluidSelectionDry;
        [self hitBackendWithCervicalFluidType:@"dry"];
        
        // update local labels
        self.cfTypeCollapsedLabel.text = @"Dry";
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_dry"];
    }
}

- (IBAction)didSelectSticky:(id)sender {
    if (self.selectedCervicalFluidType == CervicalFluidSelectionSticky) {
        self.selectedCervicalFluidType = CervicalFluidSelectionNone;
        [self hitBackendWithCervicalFluidType:[NSNull null]];
    } else {
        self.selectedCervicalFluidType = CervicalFluidSelectionSticky;
        [self hitBackendWithCervicalFluidType:@"sticky"];
        self.cfTypeCollapsedLabel.text = @"Sticky";
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_sticky"];
    }
}
- (IBAction)didSelectCreamy:(id)sender {
    if (self.selectedCervicalFluidType == CervicalFluidSelectionCreamy) {
        self.selectedCervicalFluidType = CervicalFluidSelectionNone;
        [self hitBackendWithCervicalFluidType:[NSNull null]];
    } else {
        self.selectedCervicalFluidType = CervicalFluidSelectionCreamy;
        [self hitBackendWithCervicalFluidType:@"creamy"];
        self.cfTypeCollapsedLabel.text = @"Creamy";
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_creamy"];
    }
}
- (IBAction)didSelectEggwhite:(id)sender {
    if (self.selectedCervicalFluidType == CervicalFluidSelectionEggwhite) {
        self.selectedCervicalFluidType = CervicalFluidSelectionNone;
        [self hitBackendWithCervicalFluidType:[NSNull null]];
    } else {
        self.selectedCervicalFluidType = CervicalFluidSelectionEggwhite;
        [self hitBackendWithCervicalFluidType:@"eggwhite"];
        self.cfTypeCollapsedLabel.text = @"Eggwhite";
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_eggwhite"];
    }
}

- (void)hitBackendWithCervicalFluidType:(id)cfType {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setObject:cfType forKey:@"cervical_fluid"];
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

- (IBAction)didSelectInfo:(id)sender {
    [self.delegate pushInfoAlertWithTitle:@"Cervical Fluid" AndMessage:@"Cervical fluid is like the “water for the swimmers”. The wetter the fluid the more chances you have of getting pregnant.\n\nThere are three types of cervical fluid: sticky; the LEAST fertile, creamy; SOMEWHAT fertile and eggwhite; MOST fertile." AndURL:@"http://google.com"];
}

@end
