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

- (void)pushInfoAlertWithTitle:(NSString *)title AndMessage:(NSString *)message AndURL:(NSString *)url;

- (Day *)getSelectedDay;
- (NSDate *)getSelectedDate;

@end

@interface TrackingMoodTableViewCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (weak,nonatomic) id<TrackingMoodCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *moodPlaceholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *moodCollapsedLabel;
@property (weak, nonatomic) IBOutlet UILabel *moodTypeLabel;
@property (weak, nonatomic) IBOutlet UITableView *moodTableView;

@property BOOL angryMoodSelected;
@property BOOL anxiousMoodSelected;
@property BOOL calmMoodSelected;
@property BOOL depressedMoodSelected;
@property BOOL emotionalModdSelected;
@property BOOL excitedMoodSelected;
@property BOOL friskyMoodSelected;
@property BOOL frustratedMoodSelected;
@property BOOL happyMoodSelected;
@property BOOL inLoveMoodSelected;
@property BOOL motivatedMoodSelected;
@property BOOL neutralMoodSelected;
@property BOOL sadMoodSelected;
@property BOOL worriedMoodSelected;

- (void)resetSelectedMood;

- (void)updateCell;
- (void)setMinimized;
- (void)setExpanded;

@end
