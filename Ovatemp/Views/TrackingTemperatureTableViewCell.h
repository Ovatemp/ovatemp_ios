//
//  TrackingTemperatureTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/4/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackingTemperatureTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *temperatureValueLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *temperaturePicker;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@end
