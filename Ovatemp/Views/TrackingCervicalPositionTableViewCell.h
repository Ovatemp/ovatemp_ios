//
//  TrackingCervicalPositionTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/5/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackingTemperatureTableViewCell.h" // where our delegate is

typedef enum {
    CervicalPositionSelectionNone,
    CervicalPositionSelectionLow,
    CervicalPositionSelectionHigh
} CervicalPositionSelectionType;

@interface TrackingCervicalPositionTableViewCell : UITableViewCell

@property(nonatomic,retain)id<PresentInfoAlertDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *collapsedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cpTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *cpTypeCollapsedLabel;

@property (weak, nonatomic) IBOutlet UIButton *highImageView;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UIButton *lowImageView;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;

@property NSDate *selectedDate;

@property CervicalPositionSelectionType selectedCervicalPositionType;

@end
