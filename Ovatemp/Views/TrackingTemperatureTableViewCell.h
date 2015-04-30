//
//  TrackingTemperatureTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/4/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ConnectionManager.h"
#import "ILDay.h"

@protocol TrackingTemperatureCellDelegate <NSObject>

- (void)didSelectTemperature:(NSNumber *)temperature;
- (void)didSelectDisturbance:(BOOL)disturbance;

- (void)pushInfoAlertWithTitle:(NSString *)title AndMessage:(NSString *)message AndURL:(NSString *)url;
- (void)presentViewControllerWithViewController:(UIViewController *)viewController;

- (ILDay *)getSelectedDay;

@end

@interface TrackingTemperatureTableViewCell : UITableViewCell <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) id<TrackingTemperatureCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *temperatureValueLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *temperaturePicker;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *collapsedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ondoIcon;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UISwitch *disturbanceSwitch;
@property (weak, nonatomic) IBOutlet UILabel *disturbanceLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

- (void)updateCell;
- (void)setMinimized;
- (void)setExpanded;

@end
