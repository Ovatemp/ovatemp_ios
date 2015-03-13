//
//  TrackingCervicalPositionTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/5/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"

typedef enum {
    CervicalPositionSelectionNone,
    CervicalPositionSelectionLow,
    CervicalPositionSelectionHigh
} CervicalPositionSelectionType;

@protocol TrackingCervicalPositionCellDelegate <NSObject>

- (void)didSelectCervicalPositionType:(CervicalPositionSelectionType)type;
- (void)pushInfoAlertWithTitle:(NSString *)title AndMessage:(NSString *)message AndURL:(NSString *)url;

- (Day *)getSelectedDay;
- (NSDate *)getSelectedDate;

@end

@interface TrackingCervicalPositionTableViewCell : UITableViewCell

@property(nonatomic,retain) id<TrackingCervicalPositionCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *collapsedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cpTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *cpTypeCollapsedLabel;

@property (weak, nonatomic) IBOutlet UIButton *highImageView;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UIButton *lowImageView;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;

- (void)updateCell;
- (void)setMinimized;
- (void)setExpanded;

@end
