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

#import "TrackingViewController.h"

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
    if (self.selectedIntercourseType == IntercourseSelectionUnprotected) {
        self.selectedIntercourseType = IntercourseSelectionNone;
        [self hitBackendWithIntercourseType:[NSNull null]];
        [self.protectedImageView setSelected:NO];
        [self.unprotectedImageView setSelected:NO];
    } else {
        self.selectedIntercourseType = IntercourseSelectionUnprotected;
        self.intercourseTypeCollapsedLabel.text = @"Unprotected";
        self.intercourseTypeCollapsedImageView.image = [UIImage imageNamed:@"icn_i_unprotected"];
        [self hitBackendWithIntercourseType:@"unprotected"];
        [self.protectedImageView setSelected:NO];
        [self.unprotectedImageView setSelected:YES];
    }
}

- (IBAction)didSelectProtected:(id)sender {
    if (self.selectedIntercourseType == IntercourseSelectionProtected) {
        self.selectedIntercourseType = IntercourseSelectionNone;
        [self hitBackendWithIntercourseType:[NSNull null]];
        [self.protectedImageView setSelected:NO];
        [self.unprotectedImageView setSelected:NO];
    } else {
        self.selectedIntercourseType = IntercourseSelectionProtected;
        self.intercourseTypeCollapsedLabel.text = @"Protected";
        self.intercourseTypeCollapsedImageView.image = [UIImage imageNamed:@"icn_i_protected"];
        [self hitBackendWithIntercourseType:@"protected"];
        [self.protectedImageView setSelected:YES];
        [self.unprotectedImageView setSelected:NO];
        
    }
}

- (IBAction)didSelectInfoButton:(id)sender {
    [self.delegate pushInfoAlertWithTitle:@"Intercourse" AndMessage:@"Fancy word for sex. When trying to conceive you should have unprotected sex. When trying to avoid we recommend that you have protected sex when you are not on a dry day or your temperature has not risen yet  since a temperature shift is the only way to confirm ovulation.\n\nAlways use protection against STDs when you are not in a committed relationship." AndURL:@"http://google.com"];
}

- (void)hitBackendWithIntercourseType:(id)intercourseType {
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
