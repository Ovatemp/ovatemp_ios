//
//  TrackingTemperatureTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/4/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"

@protocol PresentInfoAlertDelegate <NSObject>

- (void)pushInfoAlertWithTitle:(NSString *)title AndMessage:(NSString *)message AndURL:(NSString *)url;

@end

@interface TrackingTemperatureTableViewCell : UITableViewCell <UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic,retain)id<PresentInfoAlertDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *temperatureValueLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *temperaturePicker;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *collapsedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ondoIcon;

@property NSDate *selectedDate;

@end
