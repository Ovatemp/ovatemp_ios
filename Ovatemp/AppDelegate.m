//
//  AppDelegate.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/22/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "AppDelegate.h"

#import "Alert.h"
#import "SessionViewController.h"
#import "TodayViewController.h"
#import "OTDayNavigationController.h"
#import "SessionController.h"
#import "User.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Configure standard UI appearance
  [self configureAlertAppearance];
  [self configureTabBarAppearance];

  // Build the main window
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  UITabBarController *tabController = [[UITabBarController alloc] init];
  self.window.rootViewController = tabController;

  UIViewController *todayController = [[TodayViewController alloc] init];
  todayController = [[OTDayNavigationController alloc] initWithContentViewController:todayController];

  UIViewController *calendarController = [[UIViewController alloc] init];
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

  // Display the app!
  [self.window makeKeyAndVisible];

  // Require a user to log in or register
  if (![Configuration sharedConfiguration].token) {
    [self performSelector:@selector(presentSessionController) withObject:nil afterDelay:0];
  }

  [[Configuration sharedConfiguration] addObserver: self
                              forKeyPath: @"token"
                                 options: NSKeyValueObservingOptionNew
                                 context: NULL];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(logOutWithUnauthorized)
                                               name:kUnauthorizedRequestNotification object:nil];

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

  [SessionController refreshToken];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

# pragma mark - UIAppearance helpers

- (void)configureAlertAppearance {
//  [[UIButton appearanceWhenContainedIn:[Alert class], [UIView class], nil] setBackgroundColor:DARK_BLUE];
}

- (void)configureTabBarAppearance {
  [[UITabBar appearance] setBackgroundColor:LIGHT];
  [[UITabBar appearance] setTintColor:PURPLE];
  [[UITabBar appearance] setSelectedImageTintColor:PURPLE];
}

# pragma mark - Session methods

- (void)presentSessionController {
  SessionViewController *sessionController = [[SessionViewController alloc] initWithNibName:@"SessionViewController" bundle:nil];
  [self.window.rootViewController presentViewController:sessionController animated:YES completion:nil];
}

- (void)logOutWithUnauthorized {
  if(![Configuration sharedConfiguration].token) {
    return;
  }

  if(self.lastForcedLogout && [[NSDate date] timeIntervalSinceDate:self.lastForcedLogout] < 1) {
    return;
  }

  self.lastForcedLogout = [NSDate date];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry for the trouble!" message:@"You've been logged you out of your account. Please log in again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

  [alert show];
  [SessionController logOut];
}

# pragma mark - Observers

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context
{
  if([keyPath isEqualToString:@"token"] && [[Configuration sharedConfiguration] class] == [object class]) {
    [self presentSessionController];
  }
}

@end
