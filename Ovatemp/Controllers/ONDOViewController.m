//
//  ONDOViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/15/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "ONDOViewController.h"
#import "AccountTableViewCell.h"
#import "ONDO.h"
#import "BluetoothDeviceTableViewController.h"

@interface ONDOViewController () <UITableViewDelegate, UITableViewDataSource, ONDODelegate>

@property AccountTableViewCell *accountTableViewCell;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ONDOViewController

NSArray *ondoMenuItems;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"ONDO";
    
    ondoMenuItems = [NSArray arrayWithObjects:@"Buy ONDO", @"Pair ONDO", @"Manage ONDO", @"About ONDO", @"Instruction Manual", nil];
        
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"AccountTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"accountCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [ondoMenuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountCell" forIndexPath:indexPath];
    
    [[cell textLabel] setText:[ondoMenuItems objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        // Buy
        
    } else if (indexPath.row == 1) {
        // Pair
        __weak ONDOViewController *controller = self;
        [ONDO showPairingWizardWithDelegate:controller];
        
    } else if (indexPath.row == 2) {
        // Manage
        BluetoothDeviceTableViewController *bluetoothController = [BluetoothDeviceTableViewController new];
        bluetoothController.title = @"Manage ONDO";
        [self.navigationController pushViewController:bluetoothController animated:YES];
        
    } else if (indexPath.row == 3) {
        // About
        
    } else { // indexPath.row == 4
        // Instructions
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
