//
//  TrackingPeriodTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/6/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ILDay.h"

typedef enum {
    PeriodSelectionNoSelection,
    PeriodSelectionNone,
    PeriodSelectionSpotting,
    PeriodSelectionLight,
    PeriodSelectionMedium,
    PeriodSelectionHeavy,
} PeriodSelectionType;

@protocol TrackingPeriodCellDelegate <NSObject>

- (void)didSelectPeriodWithType:(id)type;
- (void)pushInfoAlertWithTitle:(NSString *)title AndMessage:(NSString *)message AndURL:(NSString *)url;

- (ILDay *)getSelectedDay;

@end

@interface TrackingPeriodTableViewCell : UITableViewCell

@property(nonatomic,retain) id<TrackingPeriodCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodCollapsedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *periodTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *periodTypeCollapsedLabel;

@property (weak, nonatomic) IBOutlet UIButton *noneImageView;
@property (weak, nonatomic) IBOutlet UILabel *noneLabel;
@property (weak, nonatomic) IBOutlet UIButton *spottingImageView;
@property (weak, nonatomic) IBOutlet UILabel *spottingLabel;
@property (weak, nonatomic) IBOutlet UIButton *lightImageView;
@property (weak, nonatomic) IBOutlet UILabel *lightLabel;
@property (weak, nonatomic) IBOutlet UIButton *mediumImageView;
@property (weak, nonatomic) IBOutlet UILabel *mediumLabel;
@property (weak, nonatomic) IBOutlet UIButton *heavyImageView;
@property (weak, nonatomic) IBOutlet UILabel *heavyLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

- (void)updateCell;
- (void)setMinimized;
- (void)setExpanded;

@end
