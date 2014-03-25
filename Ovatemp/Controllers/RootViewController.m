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
}

- (void)viewDidAppear:(BOOL)animated {
  [self launchAppropriateViewController];
}

- (void)launchAppropriateViewController {
  // Require a user to log in or register
  if([Configuration loggedIn]) {
    launching = mainViewController;
    [mainViewController setSelectedIndex:0];
    [Calendar resetDate];
  } else {
    launching = [self createSessionViewController];
  }

  launching.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

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
 
  UIViewController *coachingController = [[UIStoryboard storyboardWithName:@"CoachingStoryboard" bundle:nil] instantiateInitialViewController];

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

  tabController.delegate = self;
  
  mainViewController = tabController;
}



# pragma mark - Session Handling

- (SessionViewController *)createSessionViewController {
  SessionViewController* sessionViewController = [[UIStoryboard storyboardWithName:@"SessionStoryboard" bundle:nil] instantiateInitialViewController];

  return sessionViewController;
}

- (void)refreshToken {
  if([Configuration sharedConfiguration].token != nil) {
    [ConnectionManager put:@"/sessions/refresh"
                    params:nil
                   success:^(NSDictionary *response) {
                     [Configuration loggedInWithResponse:response];
                   }
                   failure:^(NSError *error) {
                     [self logOutWithUnauthorized];
                   }
     ];
  }
}

- (void)logOutWithUnauthorized {
  NSLog(@"unauthorized");
  if(![Configuration loggedIn]) {
    return;
  }

  if(lastForcedLogout && [[NSDate date] timeIntervalSinceDate:lastForcedLogout] < 1) {
    return;
  }

  lastForcedLogout = [NSDate date];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry for the trouble!" message:@"You've been logged you out of your account. Please log in again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

  [Configuration logOut];
  [self.presentedViewController dismissViewControllerAnimated:FALSE completion:^{
    [self launchAppropriateViewController];
  }];

  [alert show];
}

# pragma mark - Tab Controller Delegate Methods

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
  if(tabBarController.selectedIndex == 0) {
    [Calendar setDate:[NSDate date]];
  }
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
