//
//  ProfileSettingsViewController.h
//  Ovatemp
//
//  Created by Chris Cahoon on 3/17/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileSettingsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextField;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
