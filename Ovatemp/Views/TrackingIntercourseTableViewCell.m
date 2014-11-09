//
//  TrackingIntercourseTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/7/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingIntercourseTableViewCell.h"
#import "ConnectionManager.h"
#import "Calendar.h"
#import "Alert.h"

@implementation TrackingIntercourseTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectedDate = [[NSDate alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didSelectUnprotected:(id)sender {
    self.intercourseTypeCollapsedLabel.text = @"Unprotected";
    self.intercourseTypeCollapsedImageView.image = [UIImage imageNamed:@"icn_i_unprotected"];
    [self hitBackendWithIntercourseType:@"unprotected"];
}

- (IBAction)didSelectProtected:(id)sender {
    self.intercourseTypeCollapsedLabel.text = @"Protected";
    self.intercourseTypeCollapsedImageView.image = [UIImage imageNamed:@"icn_i_protected"];
    [self hitBackendWithIntercourseType:@"protected"];
}

- (IBAction)didSelectInfoButton:(id)sender {
    // TODO: present UIAlertController
}

- (void)hitBackendWithIntercourseType:(NSString *)intercourseType {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setObject:intercourseType forKey:@"intercourse"];
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
