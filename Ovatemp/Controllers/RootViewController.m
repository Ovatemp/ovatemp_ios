//
//  RootViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "RootViewController.h"

#import "Alert.h"
#import "Calendar.h"
#import "CalendarViewController.h"
#import "MainTabBarViewController.h"
#import "OTDayNavigationController.h"
#import "SessionViewController.h"
#import "TodayViewController.h"
#import "User.h"

#import "UIViewController+Rotations.h"

static CGFloat const kDissolveDuration = 0.2;

@interface RootViewController () {
  UIViewController *activeViewController;
  MainTabBarViewController *mainViewController;
  NSDate *lastForcedLogout;
  BOOL loggedIn;
}

@end

@implementation RootViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  // Configure standard UI appearance
  [self configureTabBarAppearance];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(logOutWithUnauthorized)
                                               name:kUnauthorizedRequestNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
  if (!activeViewController) {
    [self launchAppropriateViewController];
  }
}

- (void)launchAppropriateViewController {
  // Require a user to log in or register
  if([Configuration loggedIn]) {
    // Create a new main view controller every time so the
    // views get reset
    [self createMainViewController];

    activeViewController = mainViewController;
    [mainViewController setSelectedIndex:0];
    [Calendar resetDate];
  } else {
    activeViewController = [self createSessionViewController];
  }

  activeViewController.view.alpha = 0;
  [self.view addSubview:activeViewController.view];

  [self addChildViewController:activeViewController];
  [UIView animateWithDuration:kDissolveDuration animations:^{
    activeViewController.view.alpha = 1.0;
  }];
}

# pragma mark - Main View Controller

- (void)createMainViewController {
  MainTabBarViewController *tabController = [[MainTabBarViewController alloc] init];

  UIViewController *todayController = [[TodayViewController alloc] init];
  todayController = [[OTDayNavigationController alloc] initWithContentViewController:todayController];

  UIViewController *calendarController = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
  UIViewController *coachingController = [[UIStoryboard storyboardWithName:@"CoachingStoryboard" bundle:nil] instantiateInitialViewController];
  UIViewController *communityController = [[UIStoryboard storyboardWithName:@"CommunityStoryboard" bundle:nil] instantiateInitialViewController];
  UIViewController *moreViewController = [[UIStoryboard storyboardWithName:@"MoreStoryboard" bundle:nil] instantiateInitialViewController];

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
                     // HANDLEERROR
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
  
  Alert *alert = [Alert alertWithTitle:@"Sorry for the trouble!"
                               message:@"You've been logged you out of your account. Please log in again."];
  
  [Configuration logOut];

  [activeViewController removeFromParentViewController];
  [UIView animateWithDuration:kDissolveDuration animations:^{
    activeViewController.view.alpha = 0;
  } completion:^(BOOL finished) {
    activeViewController = nil;
    [self launchAppropriateViewController];
  }];

  [alert show];
}

# pragma mark - Tab Controller Delegate Methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
  // When user presses Today tab, set date to today
  if(tabBarController.selectedIndex == 0) {
    [Calendar setDate:[NSDate date]];
  }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
  UIViewController* selected = [tabBarController selectedViewController];
  if (viewController == selected) {
    // Don't reset to the root of the Coaching view's navigation controller
    if(tabBarController.selectedIndex == 2) {
      return NO;
    }
  }

  return YES;
}

# pragma mark - UIAppearance helpers

- (void)configureTabBarAppearance {
  [[UITabBar appearance] setBackgroundColor:LIGHT];
  [[UITabBar appearance] setTintColor:PURPLE];
  [[UITabBar appearance] setSelectedImageTintColor:PURPLE];
}


- (BOOL)shouldAutorotate {
  return NO;
}

@end
