//
//  TrackingPregnancyTestTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/10/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"

typedef enum {
    PregnancyTestSelectionNone,
    PregnancyTestSelectionNegative,
    PregnancyTestSelectionPositive
} PregnancyTestSelectionType;

@protocol TrackingPregnancyCellDelegate <NSObject>

- (void)didSelectPregnancyWithType:(id)type;
- (void)pushInfoAlertWithTitle:(NSString *)title AndMessage:(NSString *)message AndURL:(NSString *)url;

- (Day *)getSelectedDay;
- (NSDate *)getSelectedDate;

@end

@interface TrackingPregnancyTestTableViewCell : UITableViewCell

@property (weak, nonatomic) id<TrackingPregnancyCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *pregnancyCollapsedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pregnancyTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *pregnancyTypeCollapsedLabel;

@property (weak, nonatomic) IBOutlet UIButton *pregnancyTypeNegativeImageView;
@property (weak, nonatomic) IBOutlet UILabel *pregnancyTypeNegtaiveLabel;
@property (weak, nonatomic) IBOutlet UIButton *pregnancyTypePositiveImageView;
@property (weak, nonatomic) IBOutlet UILabel *pregnancyTypePositiveLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

- (void)updateCell;
- (void)setMinimized;
- (void)setExpanded;

@end
