//
//  SettingsAlarmViewController.m
//  Ovatemp
//
//  Created by Josh L on 11/17/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SettingsAlarmViewController.h"
#import "WebViewController.h"

@interface SettingsAlarmViewController ()

@end

@implementation SettingsAlarmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
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
            [self hideDatePickerWithAnimation: NO];
            self.alarmTimeValueLabel.textColor = [UIColor ovatempGreyColor];
        }
    }
    
    if (!self.alarmSwitch.isOn) {
        [self hideDatePickerWithAnimation: NO];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"BBT Reminder";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alarmTimeValueChanged:(UIDatePicker *)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a"];
    NSString *time = [formatter stringFromDate:self.alarmDatePicker.date];
    
    [self.alarmTimeValueLabel setText:time];
}

- (void)switchDidChange:(UISwitch *)alarmSwitch
{
    if (alarmSwitch.isOn) {
        self.onLabel.text = @"ON";
        [self showDatePicker];
        self.alarmTimeValueLabel.textColor = [UIColor blackColor];
    } else {
        self.onLabel.text = @"OFF";
        [self hideDatePickerWithAnimation: YES];
        self.alarmTimeValueLabel.textColor = [UIColor ovatempGreyColor];
    }
}

- (void)showDatePicker
{
    [UIView animateWithDuration: 0.5 animations:^{
        [self.hideDatePickerView.subviews setValue: @1 forKeyPath: @"alpha"];
        [self.hideDatePickerView.subviews setValue: @NO forKeyPath: @"hidden"];
        self.hideDatePickerView.backgroundColor = [UIColor whiteColor];
    }];
}

- (void)hideDatePickerWithAnimation:(BOOL)animation
{
    if (animation) {
        [UIView animateWithDuration: 0.5 animations:^{
            [self hideDatePicker];
        }];
    }else{
        [self hideDatePicker];
    }
    
}

- (void)hideDatePicker
{
    [self.hideDatePickerView.subviews setValue: @0 forKeyPath: @"alpha"];
    [self.hideDatePickerView.subviews setValue: @NO forKeyPath: @"hidden"];
    self.hideDatePickerView.backgroundColor = [UIColor colorWithRed: 249.0/255.0 green: 249.0/255.0 blue: 249.0/255.0 alpha: 1];
}

- (void)doDone:(id)sender
{
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

- (void)cancelAlarmNotification
{
    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
        
        if ([localNotification.alertBody isEqualToString:@"It's time to take your temperature."]) {
            NSLog(@"Canceling notification with alertBody: %@", localNotification.alertBody);
            
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
    }
}

- (IBAction)doShowInfo:(id)sender
{
    UIAlertController *infoAlert = [UIAlertController
                                    alertControllerWithTitle:@"BBT Reminder"
                                    message:@"Measuring BBT should be the first thing you do upon waking, even before taking a sip of water."
                                    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *gotIt = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault
                                                  handler:nil];
    
    UIAlertAction *learnMore = [UIAlertAction actionWithTitle:@"Learn more" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        WebViewController *webViewController = [WebViewController withURL:@"http://ovatemp.helpshift.com/a/ovatemp/?s=fertility-faqs&f=learn-more-about-the-alarm"];
        webViewController.title = @"BBT Reminder";
        
        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 320, 64)];
        
//        [self.navigationController presentViewController:webViewController animated:YES completion:nil];
//        webViewController.navigationItem.leftBarButtonItem.title = @"Back";
        
//        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goBackFromWebView)];
//        
//        [webViewController.navigationItem setLeftBarButtonItem:backButton];
        self.title = @"BBT Reminder            ";
        
        [self.navigationController pushViewController:webViewController animated:YES];
    }];
    
    [infoAlert addAction:gotIt];
    [infoAlert addAction:learnMore];
    
    infoAlert.view.tintColor = [UIColor ovatempAquaColor];
    
    [self presentViewController:infoAlert animated:YES completion:nil];
}

- (void)goBackFromWebView
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
