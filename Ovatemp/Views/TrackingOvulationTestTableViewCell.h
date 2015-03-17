//
//  TrackingOvulationTestTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/9/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"

typedef enum {
    OvulationTestSelectionNone,
    OvulationTestSelectionNegative,
    OvulationTestSelectionPositive
} OvulationTestSelectionType;

@protocol TrackingOvulationTestCell <NSObject>

- (void)didSelectOvulationWithType:(id)type;
- (void)pushInfoAlertWithTitle:(NSString *)title AndMessage:(NSString *)message AndURL:(NSString *)url;

- (Day *)getSelectedDay;
- (NSDate *)getSelectedDate;

@end

@interface TrackingOvulationTestTableViewCell : UITableViewCell

@property (weak, nonatomic) id<TrackingOvulationTestCell> delegate;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *ovulationCollapsedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ovulationTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *ovulationTypeCollapsedLabel;

@property (weak, nonatomic) IBOutlet UIButton *ovulationTypeNegativeImageView;
@property (weak, nonatomic) IBOutlet UILabel *ovulationTypeNegativeLabel;

@property (weak, nonatomic) IBOutlet UIButton *ovulationTypePositiveImageView;
@property (weak, nonatomic) IBOutlet UILabel *ovulationTypePositiveLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

- (void)updateCell;
- (void)setMinimized;
- (void)setExpanded;

@end
