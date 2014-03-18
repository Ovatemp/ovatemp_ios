//
//  FAMSettingsViewController.h
//  Ovatemp
//
//  Created by Chris Cahoon on 3/17/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAMSettingsViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *fiveDayRuleSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *dryDayRuleSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *tempShiftRuleSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *peakDayRuleSwitch;

@end
