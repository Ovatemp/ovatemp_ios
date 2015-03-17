//
//  TrackingCervicalFluidTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/5/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"

typedef enum {
    CervicalFluidSelectionNone,
    CervicalFluidSelectionDry,
    CervicalFluidSelectionSticky,
    CervicalFluidSelectionCreamy,
    CervicalFluidSelectionEggwhite
} CervicalFluidSelectionType;

@protocol TrackingCervicalFluidCellDelegate <NSObject>

- (void)didSelectCervicalFluidType:(id)type;
- (void)pushInfoAlertWithTitle:(NSString *)title AndMessage:(NSString *)message AndURL:(NSString *)url;

- (Day *)getSelectedDay;
- (NSDate *)getSelectedDate;

@end

@interface TrackingCervicalFluidTableViewCell : UITableViewCell

@property (weak, nonatomic) id<TrackingCervicalFluidCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *cfCollapsedLabel;
@property (weak, nonatomic) IBOutlet UILabel *cfTypeCollapsedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cfTypeImageView;

@property (weak, nonatomic) IBOutlet UIButton *dryImageView;
@property (weak, nonatomic) IBOutlet UILabel *dryLabel;
@property (weak, nonatomic) IBOutlet UIButton *stickyImageView;
@property (weak, nonatomic) IBOutlet UILabel *stickyLabel;
@property (weak, nonatomic) IBOutlet UIButton *creamyImageView;
@property (weak, nonatomic) IBOutlet UILabel *creamyLabel;
@property (weak, nonatomic) IBOutlet UIButton *eggwhiteImageView;
@property (weak, nonatomic) IBOutlet UILabel *eggwhiteLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

- (void)updateCell;
- (void)setMinimized;
- (void)setExpanded;

@end
