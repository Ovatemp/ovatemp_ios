//
//  TrackingMoodTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/7/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Day.h"

@protocol TrackingMoodCellDelegate <NSObject>

- (void)didSelectMoodWithType:(id)type;
- (void)pushInfoAlertWithTitle:(NSString *)title AndMessage:(NSString *)message AndURL:(NSString *)url;

- (Day *)getSelectedDay;
- (NSDate *)getSelectedDate;

@end

@interface TrackingMoodTableViewCell : UITableViewCell

@property (weak,nonatomic) id<TrackingMoodCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *moodPlaceholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *moodCollapsedLabel;
@property (weak, nonatomic) IBOutlet UILabel *moodTypeLabel;
@property (weak, nonatomic) IBOutlet UITableView *moodTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

- (void)updateCell;
- (void)setMinimized;
- (void)setExpanded;

@end
