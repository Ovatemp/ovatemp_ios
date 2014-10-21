//
//  Welcome3ViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/20/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Welcome3ViewController.h"
#import "LastPeriodTableViewCell.h"

@interface Welcome3ViewController () <UITableViewDelegate, UITableViewDataSource>

@property LastPeriodTableViewCell *lastPeriodTableViewCell;

@end

@implementation Welcome3ViewController

NSArray *welcomeInfoArray;
BOOL expandCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    expandCell = NO;
    
    self.tableView.delegate = self;
    
    welcomeInfoArray = [NSArray arrayWithObjects:@"Last Period", @"Cycle Length", @"Height", @"Weight", nil];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"LastPeriodTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"lastPeriodCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doNextScreen:(id)sender {
    [self performSegueWithIdentifier:@"toOndoPairing" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [welcomeInfoArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
//    switch (indexPath.row) {
//        case 0:
//        {
//            LastPeriodTableViewCell *lastPeriodTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"lastPeriodCell" forIndexPath:indexPath];
//            
//            [[lastPeriodTableViewCell textLabel] setText:[welcomeInfoArray objectAtIndex:indexPath.row]];
//            
//            return lastPeriodTableViewCell;
//             break;
//        }
//        case 1:
//        {
//            cell = [[UITableViewCell alloc] init];
//            [[cell textLabel] setText:[welcomeInfoArray objectAtIndex:indexPath.row]];
//             break;
//        }
//        case 2:
//        {
//            cell = [[UITableViewCell alloc] init];
//            [[cell textLabel] setText:[welcomeInfoArray objectAtIndex:indexPath.row]];
//             break;
//        }
//        case 3:
//        {
//            cell = [[UITableViewCell alloc] init];
//            [[cell textLabel] setText:[welcomeInfoArray objectAtIndex:indexPath.row]];
//             break;
//        }
//        default:
//            break;
//    }
    
    if (indexPath.row == 0) {
        LastPeriodTableViewCell *lastPeriodTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"lastPeriodCell" forIndexPath:indexPath];
        [[lastPeriodTableViewCell textLabel] setText:[welcomeInfoArray objectAtIndex:indexPath.row]];
        
        if (expandCell) {
            lastPeriodTableViewCell.datePicker.hidden = NO;
        }
        
        return lastPeriodTableViewCell;
    } else {
        cell = [[UITableViewCell alloc] init];
        [[cell textLabel] setText:[welcomeInfoArray objectAtIndex:indexPath.row]];
    }
    
    return cell;
    
//    WelcomeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"welcomeInfoCell" forIndexPath:indexPath];
//    
//    [[cell textLabel] setText:[welcomeInfoArray objectAtIndex:indexPath.row]];
    
//    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (expandCell) {
        return 200.0f;
    }
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSArray *reloadPaths = [NSArray arrayWithObject:[NSIndexPath indexPathWithIndex:0]];
        [tableView reloadRowsAtIndexPaths:reloadPaths withRowAnimation:UITableViewRowAnimationBottom];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
