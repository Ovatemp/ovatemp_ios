//
//  ILCoachingSummaryViewController.m
//  Ovatemp
//
//  Created by Daniel Lozano on 6/3/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILCoachingSummaryViewController.h"

#import "User.h"
#import "CoachingSummaryTableViewCell.h"
#import "ILSummaryDetailViewController.h"

@interface ILCoachingSummaryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray *rowNames;
@property (nonatomic) NSArray *timesOfDay;
@property (nonatomic) NSArray *imageNames;

@end

@implementation ILCoachingSummaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rowNames = @[@"Acupressure", @"Lifestyle", @"Massage", @"Meditation"];
    self.timesOfDay = @[@"Morning", @"Afternoon", @"Evening", @"Evening"];
    self.imageNames = @[@"AccupressureIcon", @"LifestyleIcon", @"MassageIcon", @"MeditationIcon"];
    
    NSString *profileName = [User current].fertilityProfileName;
    self.profileLabel.text = [profileName capitalizedString];
    self.profileImage.image = [UIImage imageNamed:[profileName stringByAppendingString:@"_small"]];
    
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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Back"
                                                                             style: UIBarButtonItemStyleDone
                                                                            target: nil action: nil];
    
    [self.navigationItem setHidesBackButton: YES animated: YES];
    self.navigationController.navigationBar.tintColor = [UIColor ovatempAquaColor];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rowNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CoachingSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"CoachingSummaryCell" forIndexPath: indexPath];
    
    cell.titleLabel.text = self.rowNames[indexPath.row];
    cell.subtitleLabel.text = self.timesOfDay[indexPath.row];
    cell.imageView.image = [UIImage imageNamed: self.imageNames[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier: @"ILSummaryDetailViewController"];
    [self.navigationController pushViewController: detailVC animated: YES];
}

@end
