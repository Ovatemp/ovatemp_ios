//
//  CoachingMenuViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/24/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "CoachingMenuViewController.h"
#import "CoachingMenuCell.h"

#import "LifestyleViewController.h"
#import "UINavigationItem+IconLabel.h"

#import "Configuration.h"
#import "Day.h"
#import "User.h"
#import "WebViewController.h"

#import "Localytics.h"

@interface CoachingMenuViewController ()

@property (nonatomic, strong) NSArray *rowNames;
@property (nonatomic, strong) NSArray *rowColors;

@end

@implementation CoachingMenuViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.rowNames = @[@"Acupressure", @"Lifestyle", @"Massage", @"Meditation"];
    self.rowColors = @[Color(125, 205, 200), Color(84, 194, 187), Color(61, 175, 168), Color(37, 145, 138)];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
    
  self.navigationItem.hidesBackButton = YES;
  NSString *profileName = [User current].fertilityProfileName;
  self.navigationItem.title = [profileName capitalizedString];
  self.navigationItem.titleIcon = [UIImage imageNamed:[profileName stringByAppendingString:@"_small"]];
  self.navigationItem.iconLabel.textColor = [UIColor ovatempDarkGreyTitleColor];

  self.navigationController.navigationBarHidden = NO;
  self.navigationController.navigationBar.barTintColor = LIGHT;
  self.navigationController.navigationBar.tintColor = DARK;

  // TODO: Have FertilityStatusView bind itself to today's value all the time
  [self.fertilityStatusView updateWithDay:[Day forDate:[NSDate date]]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    [Localytics tagScreen: @"Coaching/FertilityProfile"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UIViewController *viewController;
  NSString *categoryName = self.rowNames[indexPath.row];

  if ([self.rowNames[indexPath.row] isEqualToString:@"Lifestyle"]) {
    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LifestyleMenu"];
  } else {
    NSString *url = [Configuration sharedConfiguration].coachingContentUrls[categoryName];
    viewController = [WebViewController withURL:url];
  }

  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
  viewController.navigationItem.backBarButtonItem = backButton;
  viewController.navigationItem.title = categoryName;
  viewController.navigationItem.titleIcon = [UIImage imageNamed:[categoryName stringByAppendingString:@"Small"]];
  viewController.navigationItem.iconLabel.textColor = LIGHT;

  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  self.navigationController.navigationBar.barTintColor = cell.backgroundColor;
  self.navigationController.navigationBar.tintColor = LIGHT;
  [self.navigationController pushViewController:viewController animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.rowNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CoachingMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoachingMenuCell"];
    
  cell.titleLabel.text = self.rowNames[indexPath.row];
  cell.iconImageView.image = [UIImage imageNamed: self.rowNames[indexPath.row]];
  cell.backgroundColor = self.rowColors[indexPath.row];

  return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return tableView.frame.size.height / self.rowNames.count;
}

- (BOOL)shouldAutorotate
{
  return FALSE;
}

@end
