//
//  WelcomeAlarmViewController.h
//  Ovatemp
//
//  Created by Josh L on 11/17/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeAlarmViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *alarmTimePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *skipButton;
@property (weak, nonatomic) IBOutlet UILabel *alarmTimeValueLabel;

@end
