//
//  MoreViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "MoreViewController.h"

#import "BluetoothDeviceTableViewController.h"
#import "FAMSettingsViewController.h"
#import "Form.h"
#import "ProfileSettingsViewController.h"
#import "User.h"
#import "WebViewController.h"

#import "ONDO.h"

@interface MoreViewController () <ONDODelegate>

@property Form *form;

@end

@implementation MoreViewController

- (void)viewDidLoad {
  self.form = [Form withViewController:self];
  self.form.representedObject = [UserProfile current];
  self.form.onChange = ^(Form *form, FormRow *row, id value) {
    [[UserProfile current] save];
  };

  // Set up radio buttons
  FormRow *conceive = [self.form addKeyPath:@"tryingToConceive"
                                  withLabel:@"Trying to conceive:"
                                   andImage:@"MoreTryingToConceive.png"
                                  toSection:@"Goal"];
  FormRow *avoid = [self.form addKeyPath:@"tryingToConceive"
                               withLabel:@"Trying to avoid:"
                                andImage:@"MoreTryingToAvoid.png"
                               toSection:@"Goal"];
  avoid.valueTransformer = [NSValueTransformer valueTransformerForName:NSNegateBooleanTransformerName];

  conceive.onChange = ^ (FormRow *row, id value) {
    UISwitch *avoidSwitch = (UISwitch *)avoid.control;
    UISwitch *conceiveSwitch = (UISwitch *)row.control;
    [avoidSwitch setOn:!conceiveSwitch.on animated:YES];
  };

  avoid.onChange = ^ (FormRow *row, id value) {
    UISwitch *avoidSwitch = (UISwitch *)row.control;
    UISwitch *conceiveSwitch = (UISwitch *)conceive.control;
    [conceiveSwitch setOn:!avoidSwitch.on animated:YES];
  };

  __weak MoreViewController *controller = self;

  [self.form addLabel:@"Pair" withImage:nil andAccessoryType:UITableViewCellAccessoryNone toSection:@"ONDO™" whenTapped:^(FormRow *row) {
    [ONDO showPairingWizardWithDelegate:controller];
  }];

  [self.form addLabel:@"Manage thermometers" withImage:nil toSection:@"ONDO™" whenTapped:^(FormRow *row) {
    BluetoothDeviceTableViewController *bluetoothController = [BluetoothDeviceTableViewController new];
    bluetoothController.title = @"ONDO Thermometers";
    [controller.navigationController pushViewController:bluetoothController animated:YES];
  }];

  [self.form addLabel:@"Profile Settings" withImage:nil toSection:@"General Settings" whenTapped:^(FormRow *row) {
    ProfileSettingsViewController *profileController = [ProfileSettingsViewController new];
    profileController.title = @"Profile Settings";
    [controller.navigationController pushViewController:profileController animated:YES];
  }];

  [self.form addLabel:@"FAM Settings" withImage:nil toSection:@"General Settings" whenTapped:^(FormRow *row) {
    FAMSettingsViewController *famController = [FAMSettingsViewController new];
    famController.title = @"FAM Settings";
    [controller.navigationController pushViewController:famController animated:YES];
  }];

  [self.form addLabel:@"Privacy & Terms" withImage:@"MorePrivacyTerms.png" toSection:@"Help Center" whenTapped:^(FormRow *row) {
    NSString *url = [ROOT_URL stringByAppendingString:@"/terms"];
    WebViewController *webViewController = [WebViewController withURL:url];
    [controller.navigationController pushViewController:webViewController animated:YES];
  }];

}

- (void)viewWillLayoutSubviews {
  [self updateControls];
}

- (IBAction)logoutTapped:(id)sender {
  [self logout];
}

-(void)updateControls {
  self.fullNameLabel.text = [[UserProfile current] fullName];
}

- (BOOL)shouldAutorotate {
  return FALSE;
}

@end
