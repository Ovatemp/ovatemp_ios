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
    
    accountMenuItems = [NSArray arrayWithObjects:@"Profile", @"Settings", @"ONDO Thermometer", @"Help", @"Share Ovatemp", @"Rate this App", @"How it works", @"Terms of Service", nil];
    
//    self.accountTableViewCell = [UINib nibWithNibName:@"AccountTableViewCell" bundle:nil];
//    [self.tableView registerNib:self.accountTableViewCell forCellReuseIdentifier:@"accountCell"];
    [[self tableView] registerNib:[UINib nibWithNibName:@"AccountTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"accountCell"];
}

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
    return [accountMenuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountCell" forIndexPath:indexPath];
    
    [[cell textLabel] setText:[accountMenuItems objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected row %ld", (long)indexPath.row);
    
    if (indexPath.row == 4) {
        // share sheet
        
        NSString *shareString = @"Are you fertile? Find out now with Ovatemp! https://itunes.apple.com/us/app/ovatemp/id692187268?mt=8";
        
        self.activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:@[shareString]
                                          applicationActivities:nil];
        
        [self.activityViewController setValue:@"Ovatemp" forKey:@"subject"];
        
//        [self.navigationController presentViewController:self. activityViewController animated:YES completion:nil];
//        [[[self parentViewController] parentViewController] presentViewController:self.activityViewController animated:YES completion:^{
//            NSLog(@"completed");
//        }];
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:self.activityViewController animated:YES completion:nil];
    }
    
    if (indexPath.row == 5) {
        // rate app
        // https://itunes.apple.com/us/app/ovatemp/id692187268?mt=8
        // http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=xxxxxxxx&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8
        NSURL *appStoreURL = [NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=692187268&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"];
        if ([[UIApplication sharedApplication]canOpenURL:appStoreURL]) {
            [[UIApplication sharedApplication]openURL:appStoreURL];
        } else {
            NSLog(@"error opening link in AppStore");
        }
    }
    
    if (indexPath.row == 6) {
        NSLog(@"How it works");
    }
    
    if (indexPath.row == 7) {
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
