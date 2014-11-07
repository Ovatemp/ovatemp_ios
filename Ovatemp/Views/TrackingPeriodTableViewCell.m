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
    self.periodTypeCollapsedLabel.text = @"None";
    self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_none"];
    [self hitBackendWithPeriodType:@"none"];
}

- (IBAction)didSelectSpotting:(id)sender {
    self.periodTypeCollapsedLabel.text = @"Spotting";
    self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_spotting"];
    [self hitBackendWithPeriodType:@"spotting"];
}

- (IBAction)didSelectLight:(id)sender {
    self.periodTypeCollapsedLabel.text = @"Light";
    self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_light"];
    [self hitBackendWithPeriodType:@"light"];
}

- (IBAction)didSelectMedium:(id)sender {
    self.periodTypeCollapsedLabel.text = @"Medium";
    self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_medium"];
    [self hitBackendWithPeriodType:@"medium"];
}

- (IBAction)didSelectHeavy:(id)sender {
    self.periodTypeCollapsedLabel.text = @"Heavy";
    self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_heavy"];
    [self hitBackendWithPeriodType:@"heavy"];
}

- (void)hitBackendWithPeriodType:(NSString *)periodType {
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

@end
