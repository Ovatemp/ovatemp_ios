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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doSkip:(id)sender {
    [self backOutToRootViewController];
}
- (IBAction)doSetAlarm:(id)sender {
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
