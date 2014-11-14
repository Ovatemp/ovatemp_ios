//
//  TrackingCervicalPositionTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/5/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingCervicalPositionTableViewCell.h"

#import "TrackingViewController.h"
#import "Calendar.h"
#import "Alert.h"

@implementation TrackingCervicalPositionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectedDate = [[NSDate alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didSelectLowButton:(id)sender {
    if (self.selectedCervicalPositionType == CervicalPositionSelectionLow) {
        self.selectedCervicalPositionType = CervicalPositionSelectionNone;
        [self hitBackendWithCervicalPositionType:[NSNull null]];
        [self deselectAllButtons];
        self.cpTypeCollapsedLabel.text = @"";
    } else {
        self.selectedCervicalPositionType = CervicalPositionSelectionLow;
        [self hitBackendWithCervicalPositionType:@"low/closed/firm"];
        self.cpTypeCollapsedLabel.text = @"Low/Closed/Firm";
        self.cpTypeImageView.image = [UIImage imageNamed:@"icn_cp_lowclosedfirm"];
        
        [self deselectAllButtons];
        [self.lowImageView setSelected:YES];
    }
}
- (IBAction)didSelectHighButton:(id)sender {
    if (self.selectedCervicalPositionType == CervicalPositionSelectionHigh) {
        self.selectedCervicalPositionType = CervicalPositionSelectionNone;
        [self hitBackendWithCervicalPositionType:[NSNull null]];
        [self deselectAllButtons];
        self.cpTypeCollapsedLabel.text = @"";
    } else {
        self.selectedCervicalPositionType = CervicalPositionSelectionHigh;
        [self hitBackendWithCervicalPositionType:@"high/open/soft"];
        self.cpTypeCollapsedLabel.text = @"High/Open/Soft";
        self.cpTypeImageView.image = [UIImage imageNamed:@"icn_cp_highopensoft"];
        
        [self deselectAllButtons];
        [self.highImageView setSelected:YES];
    }
}

- (void)deselectAllButtons {
    [self.highImageView setSelected:NO];
    [self.lowImageView setSelected:NO];
}

- (IBAction)didSelectInfoButton:(id)sender {
    [self.delegate pushInfoAlertWithTitle:@"Cervical Position" AndMessage:@"The position of your cervix changes throughout your cycle. When you are not fertile your cervix is low, closed and firm. When fertile your cervix moves up and opens up so that the fittest swimmers reach the egg.\n\nTo learn how to track your cervical position, tap Learn More." AndURL:@"http://ovatemp.helpshift.com/a/ovatemp/?s=fertility-faqs&f=learn-more-about-cervical-position"];
}

- (void)hitBackendWithCervicalPositionType:(id)cpType {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setObject:cpType forKey:@"cervical_position"];
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

@end
