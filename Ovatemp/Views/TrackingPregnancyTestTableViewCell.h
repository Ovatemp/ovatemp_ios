//
//  TrackingPregnancyTestTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/10/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackingTemperatureTableViewCell.h" // where our delegate is

@interface TrackingPregnancyTestTableViewCell : UITableViewCell

@property(nonatomic,retain)id<PresentInfoAlertDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *pregnancyCollapsedLabel;

@property (weak, nonatomic) IBOutlet UIButton *pregnancyTypeNegativeImageView;
@property (weak, nonatomic) IBOutlet UILabel *pregnancyTypeNegtaiveLabel;
@property (weak, nonatomic) IBOutlet UIButton *pregnancyTypePositiveImageView;
@property (weak, nonatomic) IBOutlet UILabel *pregnancyTypePositiveLabel;

@property NSDate *selectedDate;

@end
