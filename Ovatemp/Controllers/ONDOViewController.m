//
//  ONDOViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/15/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "ONDOViewController.h"

#import <CCMPopup/CCMPopupTransitioning.h>

#import "AccountTableViewCell.h"
#import "ONDO.h"
#import "BluetoothDeviceTableViewController.h"
#import "WebViewController.h"
#import "ONDOSettingViewController.h"
#import "TutorialHelper.h"

@interface ONDOViewController () <UITableViewDelegate, UITableViewDataSource, ONDODelegate, ONDOSettingsViewControllerDelegate>

@property AccountTableViewCell *accountTableViewCell;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL ondoSwitchedState;

@end

@implementation ONDOViewController

NSArray *ondoMenuItems;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"ONDO";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // table view line separator
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    ondoMenuItems = [NSArray arrayWithObjects:@"Buy ONDO", @"Setup ONDO", @"About ONDO", @"Instruction Manual", nil];
        
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    if (self.ondoSwitchedState) {
        self.ondoSwitchedState = NO;
        [TutorialHelper showTutorialForOndoInController: self];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:  // Buy
        {
            NSString *url = @"http://ovatemp.com/";
            WebViewController *webViewController = [WebViewController withURL:url];
            webViewController.title = @"Buy ONDO";
            [self.navigationController pushViewController:webViewController animated:YES];
            break;
        }
            
        case 1: // Pair
        {
            ONDOSettingViewController *ondoSettingVC = [[ONDOSettingViewController alloc] init];
            ondoSettingVC.delegate = self;
            
            CCMPopupTransitioning *popup = [CCMPopupTransitioning sharedInstance];
            popup.destinationBounds = CGRectMake(0, 0, 200, 200);
            popup.presentedController = ondoSettingVC;
            popup.presentingController = self;
            popup.dismissableByTouchingBackground = YES;
            popup.backgroundViewColor = [UIColor blackColor];
            popup.backgroundViewAlpha = 0.5f;
            popup.backgroundBlurRadius = 0;
            
            ondoSettingVC.view.layer.cornerRadius = 5;
            
            [self presentViewController: ondoSettingVC animated: YES completion: nil];
            
            break;
        }
            
        case 2: // About
        {
            NSString *url = @"http://ovatemp.com/pages/ondo";
            WebViewController *webViewController = [WebViewController withURL:url];
            webViewController.title = @"About ONDO";
            [self.navigationController pushViewController:webViewController animated:YES];
            break;
        }
            
        case 3: // Instructions
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

#pragma mark - ONDOSettingsViewController Delegate

- (void)ondoSwitchedToState:(BOOL)state
{
    self.ondoSwitchedState = state;
}

@end
