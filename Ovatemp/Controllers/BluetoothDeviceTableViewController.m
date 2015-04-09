//
//  BluetoothDeviceTableViewController.m
//  Ovatemp
//
//  Created by Flip Sasser on 9/4/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "BluetoothDeviceTableViewController.h"

#import "ONDO.h"

@interface BluetoothDeviceTableViewController () <ONDODelegate>

@end

@implementation BluetoothDeviceTableViewController

- (void)viewDidLoad {
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDevice:)];
}

- (IBAction)addDevice:(id)sender {
  //[ONDO showPairingWizardWithDelegate:self];
}

# pragma mark - Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = @"ONDOCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  //ONDODevice *device = [[ONDO sharedInstance].devices objectAtIndex:indexPath.row];
  //cell.textLabel.text = device.name;
  return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    //ONDODevice *device = [[ONDO sharedInstance].devices objectAtIndex:indexPath.row];
    //[device delete];
  }
  [tableView reloadData];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewCellEditingStyleDelete;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  //return [ONDO sharedInstance].devices.count;
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // fix to avoid persistent cell highlighting
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Override "Delete" text in case we want to use something else
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"Remove";
//}

# pragma mark - ONDO delegate methods

- (void)ONDO:(ONDO *)ondo didConnectToDevice:(ONDODevice *)device {
  [self.tableView reloadData];
}

@end
