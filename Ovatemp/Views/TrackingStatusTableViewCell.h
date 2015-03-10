//
//  TrackingStatusTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 10/30/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Day.h"

@protocol TrackingStatusCellDelegate <NSObject>

- (void)pressedNotes;

- (NSMutableArray *)getDatesWithPeriod;
- (NSDate *)getPeakDate;
- (NSDate *)getSelectedDate;
- (Day *)getSelectedDay;
- (NSString *)getNotes;

@end

@interface TrackingStatusTableViewCell : UITableViewCell

@property (weak, nonatomic) id<TrackingStatusCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *notesButton;
@property (weak, nonatomic) IBOutlet UILabel *notEnoughInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
@property (weak, nonatomic) IBOutlet UILabel *enterMoreInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cycleImageView;

@property (weak, nonatomic) IBOutlet UILabel *peakLabel;
@property (weak, nonatomic) IBOutlet UILabel *fertilityLabel;

- (void)updateCell;

@end
