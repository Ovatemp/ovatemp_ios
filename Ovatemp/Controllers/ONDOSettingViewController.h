//
//  ONDOSettingViewController.h
//  Ovatemp
//
//  Created by Daniel Lozano on 4/9/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ONDOSettingsViewControllerDelegate <NSObject>

- (void)ondoSwitchedToState:(BOOL)state;

@end

@interface ONDOSettingViewController : UIViewController

@property (weak, nonatomic) id<ONDOSettingsViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UISwitch *ondoSwitch;
@property (weak, nonatomic) IBOutlet UILabel *batteryLevelLabel;

- (IBAction)ondoSwitchChanged:(id)sender;

@end
