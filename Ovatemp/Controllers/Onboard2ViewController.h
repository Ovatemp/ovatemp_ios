//
//  Onboard2ViewController.h
//  Ovatemp
//
//  Created by Chris Cahoon on 3/19/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+UserProfileHelpers.h"

@interface Onboard2ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextField;
@property (strong, nonatomic) UIDatePicker *dateOfBirthPicker;

@end
