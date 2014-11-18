//
//  SettingsAlarmViewController.m
//  Ovatemp
//
//  Created by Josh L on 11/17/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SettingsAlarmViewController.h"

@interface SettingsAlarmViewController ()

@end

@implementation SettingsAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // reset date picker hidden view frame
    self.hideDatePickerView.frame = CGRectMake(self.hideDatePickerView.frame.origin.x, self.hideDatePickerView.frame.origin.y - 160, self.hideDatePickerView.frame.size.width, self.hideDatePickerView.frame.size.height);
    
    [self.alarmSwitch addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
    self.alarmSwitch.onTintColor = [UIColor ovatempAquaColor];
    
    [self.alarmDatePicker addTarget:self action:@selector(alarmTimeValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(doDone:)]];
    
    // find the alarm notification (if the user has one set)
    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
        
        if ([localNotification.alertBody isEqualToString:@"It's time to take your temperature."]) {
            
            self.alarmDatePicker.date = localNotification.fireDate;
            self.onLabel.text = @"ON";
            [self.alarmSwitch setOn:YES];
            [self showDatePicker];
            self.alarmTimeValueLabel.textColor = [UIColor blackColor];
            [self alarmTimeValueChanged:self.alarmDatePicker];
        } else {
            // default date
            self.onLabel.text = @"OFF";
            [self.alarmSwitch setOn:NO];
            [self hideDatePicker];
            self.alarmTimeValueLabel.textColor = [UIColor colorWithRed:68.0f/255.0f green:68.0f/255.0f blue:68.0f/255.0f alpha:1.0f];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alarmTimeValueChanged:(UIDatePicker *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a"];
    NSString *time = [formatter stringFromDate:self.alarmDatePicker.date];
    
    [self.alarmTimeValueLabel setText:time];
}

- (void)switchDidChange:(UISwitch *)alarmSwitch {
    if (alarmSwitch.isOn) {
        self.onLabel.text = @"ON";
        [self showDatePicker];
        self.alarmTimeValueLabel.textColor = [UIColor blackColor];
    } else {
        self.onLabel.text = @"OFF";
        [self hideDatePicker];
        self.alarmTimeValueLabel.textColor = [UIColor colorWithRed:68.0f/255.0f green:68.0f/255.0f blue:68.0f/255.0f alpha:1.0f];
    }
}

- (void)showDatePicker {
    
    // 252, 412
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.6f initialSpringVelocity:0.5f options:0 animations:^{
            self.hideDatePickerView.frame = CGRectMake(self.hideDatePickerView.frame.origin.x, self.hideDatePickerView.frame.origin.y + 160, self.hideDatePickerView.frame.size.width, self.hideDatePickerView.frame.size.height);
    } completion:nil];
}

- (void)hideDatePicker {
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.6f initialSpringVelocity:0.5f options:0 animations:^{
        self.hideDatePickerView.frame = CGRectMake(self.hideDatePickerView.frame.origin.x, self.hideDatePickerView.frame.origin.y - 160, self.hideDatePickerView.frame.size.width, self.hideDatePickerView.frame.size.height);
    } completion:nil];
}

- (void)doDone:(id)sender {
    // save and go back?
    // either way, we're deleting the notification
    [self cancelAlarmNotification];
    
    if ([self.alarmSwitch isOn]) {
        // set new notification at new time
        UILocalNotification *alarm = [[UILocalNotification alloc] init];
        alarm.fireDate = self.alarmDatePicker.date;
        alarm.timeZone = [NSTimeZone defaultTimeZone];
        alarm.repeatInterval = NSCalendarUnitDay;
        alarm.alertBody = @"It's time to take your temperature.";
        alarm.alertAction = @"View";
        alarm.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:alarm];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelAlarmNotification {
    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
        
        if ([localNotification.alertBody isEqualToString:@"It's time to take your temperature."]) {
            NSLog(@"Canceling notification with alertBody: %@", localNotification.alertBody);
            
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
