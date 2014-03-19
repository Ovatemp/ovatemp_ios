//
//  ProfileSetupViewController.h
//  Ovatemp
//
//  Created by Chris Cahoon on 3/19/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"

@interface Onboard1ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *cycleDateTextField;
@property (strong, nonatomic) UIDatePicker *cycleDatePicker;

@property (weak, nonatomic) IBOutlet UISwitch *tryingToConceive;
@property (weak, nonatomic) IBOutlet UISwitch *tryingToAvoid;

@property (nonatomic, strong) Day *firstDay;

@end
