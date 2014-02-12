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
#import "NavigationViewController.h"
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

  UIViewController *currentController;
  // Set up the today controller
  TodayViewController *todayController = [[TodayViewController alloc] init];
  [tabController addChildViewController:todayController.withNavigation];

  currentController = [tabController.childViewControllers lastObject];
  currentController.tabBarItem.image = [UIImage imageNamed:@"IconToday.png"];
  currentController.tabBarItem.title = @"Today";

  // Display the app!
  [self.window makeKeyAndVisible];

  // Require a user to log in or register
  if (![Configuration sharedConfiguration].token) {
    [self performSelector:@selector(presentSessionController) withObject:nil afterDelay:0];
  } 

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

@end
