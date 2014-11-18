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
    
    [self.alarmSwitch addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
    
//    self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doDone:)];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doDone:)]];
    
    // find the alarm notification (if the user has one set)
    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
        
        if ([localNotification.alertBody isEqualToString:@"It's time to take your temperature."]) {
            
            self.alarmDatePicker.date = localNotification.fireDate;
            [self.alarmSwitch setOn:YES];
            [self showDatePicker];
        } else {
            // default date
            [self.alarmSwitch setOn:NO];
            [self hideDatePicker];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchDidChange:(UISwitch *)alarmSwitch {
    if (alarmSwitch.isOn) {
        [self showDatePicker];
    } else {
        [self hideDatePicker];
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
