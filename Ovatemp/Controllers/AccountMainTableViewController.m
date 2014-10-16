//
//  AccountMainTableViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/15/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "AccountMainTableViewController.h"
#import "AccountTableViewCell.h"
#import "WebViewController.h"
#import "ONDOViewController.h"
#import "ProfileTableViewController.h"

@interface AccountMainTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property AccountTableViewCell *accountTableViewCell;
@property (strong, nonatomic) UIActivityViewController *activityViewController;

@end

@implementation AccountMainTableViewController

NSArray *accountMenuItems;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    accountMenuItems = [NSArray arrayWithObjects:@"Profile", @"Settings", @"ONDO Thermometer", @"Help", @"Share Ovatemp", @"Rate this App", @"How it Works", @"Terms of Service", nil];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"AccountTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"accountCell"];
    
    // logout
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(doLogout)];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doLogout {
    [self logout];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [accountMenuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountCell" forIndexPath:indexPath];
    
    [[cell textLabel] setText:[accountMenuItems objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        // Profile
        ProfileTableViewController *profileVC = [[ProfileTableViewController alloc] init];
        [self.navigationController pushViewController:profileVC animated:YES];
        
    } else if (indexPath.row == 1) {
        // Settings
        
    } else if (indexPath.row == 2) {
        // ONDO
        
        ONDOViewController *ondoVC = [[ONDOViewController alloc] init];
        [self.navigationController pushViewController:ondoVC animated:YES];
        
    } else if (indexPath.row == 3) {
        // Help
        
    } else if (indexPath.row == 4) {
        // Share
        
        NSString *shareString = @"Are you fertile? Find out now with Ovatemp! https://itunes.apple.com/us/app/ovatemp/id692187268?mt=8";
        
        self.activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:@[shareString]
                                          applicationActivities:nil];
        
        self.activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop, UIActivityTypeCopyToPasteboard];
        [self.activityViewController setValue:@"Ovatemp" forKey:@"subject"];
        
        // TODO: FIXME, activityViewController will sometimes dismiss by itself
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:self.activityViewController animated:YES completion:nil];
        
    } else if (indexPath.row == 5) {
        // Rate app
        // https://itunes.apple.com/us/app/ovatemp/id692187268?mt=8
        // http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=xxxxxxxx&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8
        NSURL *appStoreURL = [NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=692187268&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"];
        if ([[UIApplication sharedApplication]canOpenURL:appStoreURL]) {
            [[UIApplication sharedApplication]openURL:appStoreURL];
        } else {
            NSLog(@"error opening link in AppStore");
        }
    
    } else if (indexPath.row == 6) {
        // How it Works
        
    } else { // indexPath.row == 7
        // TOS
        NSString *url = [ROOT_URL stringByAppendingString:@"/terms"];
        WebViewController *webViewController = [WebViewController withURL:url];
        [self.navigationController pushViewController:webViewController animated:YES];
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
