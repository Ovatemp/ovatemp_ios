// I am that I am Ovatemp. The app that brought FAM to all women in the world.
// Om navah shivaya.
//
//  AppDelegate.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/22/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "SubscriptionHelper.h"
#import <Reachability/Reachability.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Build the main window
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];

  // Display the app!
  [self.window makeKeyAndVisible];
  
  [self setupReachability];
  
  // Ping the in app purchase helper so we start getting notifications
  [SubscriptionHelper sharedInstance];

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

# pragma mark - Reachability

- (void)reachabilityChanged:(NSNotification *)notification {
  
  Reachability *reach = notification.object;
  
  if(reach.currentReachabilityStatus == NotReachable) {
    self.alertWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *alertController = [[UIViewController alloc] initWithNibName: @"ConnectivityAlertView" bundle: [NSBundle mainBundle]];
    
    self.alertWindow.windowLevel = UIWindowLevelAlert;
    self.alertWindow.rootViewController = alertController;
    
    [self.alertWindow makeKeyAndVisible];
  } else {
    self.alertWindow = nil;
    [self.window makeKeyAndVisible];
  }
}

- (void)setupReachability {
  Reachability *reach = [Reachability reachabilityForInternetConnection];
  reach.reachableOnWWAN = YES; // This should always be true

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(reachabilityChanged:)
                                               name:kReachabilityChangedNotification
                                             object:nil];
  [reach startNotifier];
  
  if (reach.currentReachabilityStatus == NotReachable) {
    [[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object: reach userInfo: nil];
  }
}

@end
