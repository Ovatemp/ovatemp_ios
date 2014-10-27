//
//  SettingsTableViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/16/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "AccountTableViewCell.h"
#import "SettingsTemperatureTableViewCell.h"
#import "FAMSettingsViewController.h"

@interface SettingsTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property AccountTableViewCell *accountTableViewCell;

@property SettingsTemperatureTableViewCell *tempCell;

@end

@implementation SettingsTableViewController

NSArray *settingsMenuItems;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    settingsMenuItems = [NSArray arrayWithObjects:@"Temperature Units", @"FAM Settings", nil];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"AccountTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"accountCell"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"SettingsTemperatureTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"settingsTempCell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([defaults objectForKey:@"temperatureUnitPreferenceFahrenheit"]) {
//        self.tempCell.tempControl.selectedSegmentIndex = 0;
//    } else {
//        self.tempCell.tempControl.selectedSegmentIndex = 1;
//    }
}

//- (void) viewDidLayoutSubviews {
////    @"temperatureUnitPreferenceFahrenheit"
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([defaults objectForKey:@"temperatureUnitPreferenceFahrenheit"]) {
//        self.tempCell.tempControl.selectedSegmentIndex = 0;
//    } else {
//        self.tempCell.tempControl.selectedSegmentIndex = 1;
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [settingsMenuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountTableViewCell *cell;
    
    if (indexPath.row == 0) {
        self.tempCell = [tableView dequeueReusableCellWithIdentifier:@"settingsTempCell" forIndexPath:indexPath];
        
        [[self.tempCell textLabel] setText:[settingsMenuItems objectAtIndex:indexPath.row]];
        
        return self.tempCell;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"accountCell" forIndexPath:indexPath];
        
        [[cell textLabel] setText:[settingsMenuItems objectAtIndex:indexPath.row]];
    }
    
    // if failure
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // do nothing if row 0 (temp units)
    
    switch (indexPath.row) {
        case 0: // Temperature unit select, do nothing
            break;
            
        case 1: // FAM Settings
        {
            FAMSettingsViewController *famController = [FAMSettingsViewController new];
            famController.title = @"FAM Settings";
            [self.navigationController pushViewController:famController animated:YES];
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
