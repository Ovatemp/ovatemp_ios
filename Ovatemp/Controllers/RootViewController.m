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
#import "TodayNavigationController.h"
#import "SessionViewController.h"
#import "TodayViewController.h"
#import "SelectLogInOrSignUpViewController.h"
#import "TrackingViewController.h"
#import "TrackingNavigationController.h"

#import "GAI.h"
#import "ACTReporter.h"
#import <HockeySDK/HockeySDK.h>
#import "Mixpanel.h"

static CGFloat const kDissolveDuration = 0.2;

@interface RootViewController () {
    MainTabBarViewController *mainViewController;
    NSDate *lastForcedLogout;
    BOOL loggedIn;
    BOOL loaded;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure standard UI appearance
    [self configureTabBarAppearance];
    
    // Setup 3rd party libraries
    [self configureAnalytics];
    [self configureHockey];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logOutWithUnauthorized)
                                                 name:kUnauthorizedRequestNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!loaded) {
        loaded = YES;
        if ([Configuration loggedIn]) {
            [self startLoading];
            [self refreshToken];
        } else {
            [self launchAppropriateViewController];
        }
    }
}

- (void)launchAppropriateViewController {
    if (self.activeViewController) {
        [self.activeViewController.view removeFromSuperview];
        [self.activeViewController removeFromParentViewController];
    }
    
    // Require a user to log in or register
    if ([Configuration loggedIn]) {
        // Create a new main view controller every time so the
        // views get reset
        [self createMainViewController];
        
        self.activeViewController = mainViewController;
        [mainViewController setSelectedIndex:0];
        [Calendar resetDate];
    } else {
        self.activeViewController = [self createSessionViewController];
    }
    
    self.activeViewController.view.alpha = 0;
    [self.view addSubview:self.activeViewController.view];
    
    [self addChildViewController:self.activeViewController];
    [UIView animateWithDuration:kDissolveDuration animations:^{
        self.activeViewController.view.alpha = 1.0;
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

# pragma mark - Main View Controller

- (void)createMainViewController {
    MainTabBarViewController *tabController = [[MainTabBarViewController alloc] init];
    
    UIViewController *todayController = [[TodayViewController alloc] init];
    todayController = [[TodayNavigationController alloc] initWithContentViewController:todayController];
    
//    UIViewController *calendarController = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
    UIViewController *coachingController = [[UIStoryboard storyboardWithName:@"CoachingStoryboard" bundle:nil] instantiateInitialViewController];
//    UIViewController *communityController = [[UIStoryboard storyboardWithName:@"CommunityStoryboard" bundle:nil] instantiateInitialViewController];
    //  UIViewController *moreViewController = [[UIStoryboard storyboardWithName:@"MoreStoryboard" bundle:nil] instantiateInitialViewController];
    
    // Account
    UIViewController *accountController = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateInitialViewController];
    
    // Add controllers to the tab bar controller
    
    UIStoryboard *trackingStoryboard = [UIStoryboard storyboardWithName:@"Tracking" bundle:nil];
    TrackingViewController *trackingVC = [trackingStoryboard instantiateInitialViewController];
    [tabController addChildViewController: trackingVC];
    trackingVC.tabBarItem.image = [UIImage imageNamed:@"icn_tracking"];
    trackingVC.tabBarItem.selectedImage = [UIImage imageNamed:@"icn_tracking_pressed"];
    trackingVC.tabBarItem.title = @"Tracking";
    //[trackingVC startLoading];
    
//    [tabController addChildViewController:todayController];
//    todayController.tabBarItem.image = [UIImage imageNamed:@"today_unselect"];
//    todayController.tabBarItem.selectedImage = [UIImage imageNamed:@"today_select"];
//    todayController.tabBarItem.title = @"Today";
//    [todayController startLoading];
    
//    [tabController addChildViewController:calendarController];
//    calendarController.tabBarItem.image = [UIImage imageNamed:@"cal_unselected"];
//    calendarController.tabBarItem.selectedImage = [UIImage imageNamed:@"cal_selected"];
//    calendarController.tabBarItem.title = @"Calendar";
    
    [tabController addChildViewController:coachingController];
    coachingController.tabBarItem.image = [UIImage imageNamed:@"icn_coaching"];
    coachingController.tabBarItem.selectedImage = [UIImage imageNamed:@"icn_coaching_pressed"];
    coachingController.tabBarItem.title = @"Coaching";
    
//    [tabController addChildViewController:communityController];
//    communityController.tabBarItem.image = [UIImage imageNamed:@"icn_community"];
//    communityController.tabBarItem.selectedImage = [UIImage imageNamed:@"icn_community_pressed"];
//    communityController.tabBarItem.title = @"Community";
    
    //  [tabController addChildViewController:moreViewController];
    //  moreViewController.tabBarItem.image = [UIImage imageNamed:@"more_unselect"];
    //  moreViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"more_select"];
    //  moreViewController.tabBarItem.title = @"More";
    
    [tabController addChildViewController:accountController];
    accountController.tabBarItem.image = [UIImage imageNamed:@"icn_account"];
    accountController.tabBarItem.selectedImage = [UIImage imageNamed:@"icn_account_pressed"];
    accountController.tabBarItem.title = @"Account";
    
    
    
    tabController.delegate = self;
    
    mainViewController = tabController;
}

# pragma mark - Session Handling

//- (SessionViewController *)createSessionViewController {
- (SelectLogInOrSignUpViewController *)createSessionViewController {
    //  SessionViewController* sessionViewController = [[UIStoryboard storyboardWithName:@"SessionStoryboard" bundle:nil] instantiateInitialViewController];
    
    //  return sessionViewController;
    
    SelectLogInOrSignUpViewController *selectVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
    return selectVC;
}

- (void)refreshToken {
    [ConnectionManager put:@"/sessions/refresh"
                    params:nil
                   success:^(NSDictionary *response) {
                       [self stopLoading];
                       [Configuration loggedInWithResponse:response];
                       [self launchAppropriateViewController];
                   }
                   failure:^(NSError *error) {
                       [self stopLoading];
                       if(error.code == -1004 && error.domain == NSURLErrorDomain) {
                           loaded = NO;
                       } else {
                           [self logOutWithUnauthorized];
                       }
                   }
     ];
}

- (void)logOutWithUnauthorized {
    if (![Configuration loggedIn]) {
        return;
    }
    
    if(lastForcedLogout && [[NSDate date] timeIntervalSinceDate:lastForcedLogout] < 1) {
        return;
    }
    
    lastForcedLogout = [NSDate date];
    
    Alert *alert = [Alert alertWithTitle:@"Sorry for the trouble!"
                                 message:@"You've been logged out of your account. Please log in again."];
    
    [Configuration logOut];
    
    [self.activeViewController removeFromParentViewController];
    [UIView animateWithDuration:kDissolveDuration animations:^{
        self.activeViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.activeViewController.view removeFromSuperview];
        self.activeViewController = nil;
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
    [[UITabBar appearance] setTintColor:[UIColor ovatempAquaColor]];
    //  [[UITabBar appearance] setSelectedImageTintColor:PURPLE];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.activeViewController) {
        return self.activeViewController.preferredStatusBarStyle;
    } else {
        return [super preferredStatusBarStyle];
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

# pragma mark - 3rd party librarys

- (void)configureAnalytics {
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [[GAI sharedInstance] trackerWithTrackingId:kGoogleAnalyticsTrackingID];
    
    [ACTConversionReporter reportWithConversionID:kGoogleAdwordsConversionID
                                            label:kGoogleAdwordsConversionLabel
                                            value:@"0.000000"
                                     isRepeatable:NO];
    
    [Mixpanel sharedInstanceWithToken:kMixpanelToken];
}

- (void)configureHockey {
#ifndef DEBUG
    BITHockeyManager *hockey = [BITHockeyManager sharedHockeyManager];
    [hockey configureWithIdentifier:kHockeyIdentifier];
    [hockey startManager];
    [hockey.authenticator authenticateInstallation];
#endif
}

@end
