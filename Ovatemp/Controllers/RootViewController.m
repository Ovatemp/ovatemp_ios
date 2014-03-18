//
//  RootViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "RootViewController.h"
#import "SessionViewController.h"
#import "TodayViewController.h"
#import "OTDayNavigationController.h"
#import "CalendarViewController.h"
#import "SessionController.h"
#import "User.h"
#import "Calendar.h"

@interface RootViewController () {
  UITabBarController *mainViewController;
  NSDate *lastForcedLogout;
  BOOL loggedIn;
  UIViewController *launching;
}

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  // Configure standard UI appearance
  [self configureAlertAppearance];
  [self configureTabBarAppearance];

  [self createMainViewController];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(logOutWithUnauthorized)
                                               name:kUnauthorizedRequestNotification object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(launchAppropriateViewController)
                                               name:kSessionChangedNotificationName
                                             object:nil
   ];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [self launchAppropriateViewController];
}

- (void)launchAppropriateViewController {
  if(launching) {
    return;
  }

  if(self.presentedViewController) {
    [self dismissViewControllerAnimated:TRUE completion:^{
      [self launchAppropriateViewController];
    }];

    return;
  }

  // Require a user to log in or register
  if([SessionController loggedIn]) {
    launching = mainViewController;
    [mainViewController setSelectedIndex:0];
    [Calendar resetDate];
  } else {
    launching = [self createSessionViewController];
  }

  [self presentViewController:launching animated:YES completion:^{
    launching = nil;
  }];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

# pragma mark - Main View Controller

- (void)createMainViewController {
  UITabBarController *tabController = [[UITabBarController alloc] init];

  UIViewController *todayController = [[TodayViewController alloc] init];
  todayController = [[OTDayNavigationController alloc] initWithContentViewController:todayController];

  UIViewController *calendarController = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
 
  UIViewController *coachingController = [[UIViewController alloc] init];
  UIViewController *communityController = [[UIViewController alloc] init];
  UIViewController* moreViewController = [[UIStoryboard storyboardWithName:@"MoreStoryboard" bundle:nil] instantiateInitialViewController];

  // Add controllers to the tab bar controller
  [tabController addChildViewController:todayController];
  todayController.tabBarItem.image = [UIImage imageNamed:@"today_unselect"];
  todayController.tabBarItem.selectedImage = [UIImage imageNamed:@"today_select"];
  todayController.tabBarItem.title = @"Today";

  [tabController addChildViewController:calendarController];
  calendarController.tabBarItem.image = [UIImage imageNamed:@"cal_unselected"];
  calendarController.tabBarItem.selectedImage = [UIImage imageNamed:@"cal_selected"];
  calendarController.tabBarItem.title = @"Calendar";

  [tabController addChildViewController:coachingController];
  coachingController.tabBarItem.image = [UIImage imageNamed:@"coaching_unselect"];
  coachingController.tabBarItem.selectedImage = [UIImage imageNamed:@"coaching_select"];

  coachingController.tabBarItem.title = @"Coaching";

  [tabController addChildViewController:communityController];
  communityController.tabBarItem.image = [UIImage imageNamed:@"community_unselect"];
  communityController.tabBarItem.selectedImage = [UIImage imageNamed:@"community_select"];
  communityController.tabBarItem.title = @"Community";

  moreViewController.tabBarItem.image = [UIImage imageNamed:@"more_unselect"];
  moreViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"more_select"];
  moreViewController.tabBarItem.title = @"More";

  [tabController addChildViewController:moreViewController];

  mainViewController = tabController;
}

# pragma mark - Session Handling

- (SessionViewController *)createSessionViewController {
  SessionViewController* sessionViewController = [[UIStoryboard storyboardWithName:@"SessionStoryboard" bundle:nil] instantiateInitialViewController];

  return sessionViewController;
}

- (void)logOutWithUnauthorized {
  if(![SessionController loggedIn]) {
    return;
  }

  if(lastForcedLogout && [[NSDate date] timeIntervalSinceDate:lastForcedLogout] < 1) {
    return;
  }

  lastForcedLogout = [NSDate date];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry for the trouble!" message:@"You've been logged you out of your account. Please log in again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

  [alert show];
  [SessionController logOut];
}

# pragma mark - UIAppearance helpers

- (void)configureTabBarAppearance {
  [[UITabBar appearance] setBackgroundColor:LIGHT];
  [[UITabBar appearance] setTintColor:PURPLE];
  [[UITabBar appearance] setSelectedImageTintColor:PURPLE];
}

- (void)configureAlertAppearance {
  //  [[UIButton appearanceWhenContainedIn:[Alert class], [UIView class], nil] setBackgroundColor:DARK_BLUE];
}

@end
