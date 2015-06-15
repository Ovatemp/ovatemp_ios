//
//  ILCoachingSummaryViewController.m
//  Ovatemp
//
//  Created by Daniel Lozano on 6/3/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILCoachingSummaryViewController.h"

#import "ILSummaryDetailViewController.h"

@interface ILCoachingSummaryViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ILCoachingSummaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customizeAppearance];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    NSIndexPath *selection = [self.tableView indexPathForSelectedRow];
    if (selection) {
        [self.tableView deselectRowAtIndexPath:selection animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Appearance

- (void)customizeAppearance
{
    self.title = @"Coaching";
    
    [self.navigationItem setHidesBackButton: YES animated: YES];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"CoachingSummaryCell" forIndexPath: indexPath];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier: @"ILSummaryDetailViewController"];
    [self.navigationController pushViewController: detailVC animated: YES];
}

@end
