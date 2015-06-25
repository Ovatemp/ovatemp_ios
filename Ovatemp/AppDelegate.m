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
#import "HealthKitHelper.h"
#import "CoachingDataStore.h"

#import "Stripe.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <CoreData/CoreData.h>
#import <Reachability/Reachability.h>
#import <Localytics/Localytics.h>
#import <Helpshift/Helpshift.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    [self.window makeKeyAndVisible];
    
    [self customizeAppearance];
    
    // Third Party
    [Fabric with: @[CrashlyticsKit]]; // Crash reporting
    [self setUpHelpshift]; // User Help
    [self setUpLumberjack]; // Logging
    [self setUpStripe]; // Payments, Apple Pay
    
    [self setupReachability];
    [self setupHealthKit];
    
    [self setDefaultTemperatureUnit];
    [self setUpPushNotifications: application];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // In App Purchases : Ping the in app purchase helper so we start getting notifications
    //[SubscriptionHelper sharedInstance];
    
    [Localytics autoIntegrate: @"17f522ff1be70d82cefe212-339d99c4-3dbc-11e4-255f-004a77f8b47f" launchOptions: launchOptions]; // Analyticcs

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[CoachingDataStore sharedSession] saveDataStore];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKSettings setAppID: kFacebookAppId];
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[CoachingDataStore sharedSession] saveDataStore];
    [self saveContext];
}

#pragma mark - Helpers

- (void)setDefaultTemperatureUnit
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"temperatureUnitPreferenceFahrenheit"]) {
        [defaults setBool:YES forKey:@"temperatureUnitPreferenceFahrenheit"];
    }
}

- (void)setUpPushNotifications:(UIApplication *)application
{
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
}

#pragma mark - Appearance

- (void)customizeAppearance
{
    [[UINavigationBar appearance] setBarTintColor: [UIColor colorWithRed: 249.0/255.0 green: 249.0/255.0 blue: 249.0/255.0 alpha: 1]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor ovatempAquaColor]} forState:UIControlStateNormal];
}

#pragma mark - Third Party

- (void)setUpStripe
{
    [Stripe setDefaultPublishableKey: kStripePublishableKey];
}

- (void)setUpHelpshift
{
    [Helpshift installForApiKey: @"c70867a0d520ce013be96501db20b631"
                        domainName: @"ovatemp.helpshift.com"
                          appID: @"ovatemp_platform_20130926211159051-f26e2f42401fd8c"];
}

- (void)setUpLumberjack
{
    setenv("XcodeColors", "YES", 0);
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    [[DDTTYLogger sharedInstance] setForegroundColor: [UIColor blueColor] backgroundColor: nil forFlag: DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor: [UIColor blackColor] backgroundColor: nil forFlag: DDLogFlagVerbose];
}

- (void) setupHealthKit
{
    HealthKitHelper *healthKit = [HealthKitHelper sharedSession];
    [healthKit setUpHealthKit];
}

# pragma mark - Reachability

- (void)reachabilityChanged:(NSNotification *)notification
{
    
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

- (void)setupReachability
{
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

# pragma mark - Core Data

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Test" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Test.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
