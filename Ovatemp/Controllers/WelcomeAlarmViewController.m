//
//  WelcomeAlarmViewController.m
//  Ovatemp
//
//  Created by Josh L on 11/17/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "WelcomeAlarmViewController.h"

@interface WelcomeAlarmViewController ()

@end

@implementation WelcomeAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.alarmTimePicker addTarget:self action:@selector(alarmTimeValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alarmTimeValueChanged:(UIDatePicker *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a"];
    NSString *time = [formatter stringFromDate:self.alarmTimePicker.date];
    
    [self.alarmTimeValueLabel setText:time];
}

- (IBAction)doSkip:(id)sender {
    [self backOutToRootViewController];
}
- (IBAction)doSetAlarm:(id)sender {
    // first, save alarm info to user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.alarmTimePicker.date forKey:@"alarmDate"];
    [defaults synchronize];
    
    // set date for notification
    UILocalNotification *alarm = [[UILocalNotification alloc] init];
    alarm.fireDate = self.alarmTimePicker.date;
    alarm.timeZone = [NSTimeZone defaultTimeZone];
    alarm.repeatInterval = NSCalendarUnitDay;
    alarm.alertBody = @"It's time to take your temperature.";
    alarm.alertAction = @"View";
    alarm.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:alarm];
    [self backOutToRootViewController];
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
