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
#import "WebViewController.h"

@interface ONDOViewController () <UITableViewDelegate, UITableViewDataSource, ONDODelegate>

@property AccountTableViewCell *accountTableViewCell;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ONDOViewController

NSArray *ondoMenuItems;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"ONDO";
    
    // table view line separator
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    ondoMenuItems = [NSArray arrayWithObjects:@"Buy ONDO", @"Pair ONDO", @"Manage ONDO", @"About ONDO", @"Instruction Manual", nil];
        
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"AccountTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"accountCell"];
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [ondoMenuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountCell" forIndexPath:indexPath];
    
    [[cell textLabel] setText:[ondoMenuItems objectAtIndex:indexPath.row]];
    
    cell.layoutMargins = UIEdgeInsetsZero;
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch (indexPath.row) {
        case 0:  // Buy
        {
            NSString *url = @"http://ovatemp.com/products/ondo";
            WebViewController *webViewController = [WebViewController withURL:url];
            webViewController.title = @"Buy ONDO";
            [self.navigationController pushViewController:webViewController animated:YES];
            break;
        }
            
        case 1: // Pair
        {
            __weak ONDOViewController *controller = self;
            [ONDO showPairingWizardWithDelegate:controller];
            break;
        }
            
        case 2: // Manage
        {
            BluetoothDeviceTableViewController *bluetoothController = [BluetoothDeviceTableViewController new];
            bluetoothController.title = @"Manage ONDO";
            [self.navigationController pushViewController:bluetoothController animated:YES];
            break;
        }
            
        case 3: // About
        {
            NSString *url = @"http://ovatemp.com/pages/ondo";
            WebViewController *webViewController = [WebViewController withURL:url];
            webViewController.title = @"About ONDO";
            [self.navigationController pushViewController:webViewController animated:YES];
            break;
        }
            
        case 4: // Instructions
        {
            NSString *url = @"https://s3.amazonaws.com/ovatemp/UserManual_2014.02.26.pdf";
            WebViewController *webViewController = [WebViewController withURL:url];
            webViewController.title = @"Instruction Manual";
            [self.navigationController pushViewController:webViewController animated:YES];
            break;
        }
            
        default:
            break;
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
