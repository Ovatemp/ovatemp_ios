//
//  MainTabBarViewController.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/14/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "MainTabBarViewController.h"

#import "ILCycleViewController.h"
#import "CycleViewController.h"

@interface MainTabBarViewController () {
  BOOL inLandscape;
}

@property (nonatomic) UINavigationController *cycleViewController;
@property (nonatomic) CycleViewController *oldCycleViewController;

@property (nonatomic) NSNumber *currentCycleId;

@end

@implementation MainTabBarViewController

- (id)init
{
  self = [super init];
  if (self) {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
      
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(orientationChanged:)
                                                 name: UIDeviceOrientationDidChangeNotification
                                               object: nil];
      
      [[NSNotificationCenter defaultCenter] addObserver: self
                                               selector: @selector(currentCycleId:)
                                                   name: @"IsAtCurrentCycleId"
                                                 object: nil];
  }
  return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
//  [[NSNotificationCenter defaultCenter] removeObserver: self
//                                                  name: UIDeviceOrientationDidChangeNotification
//                                                object: nil];
}

- (void)currentCycleId:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *cycleId = userInfo[@"cycleId"];
    DDLogInfo(@"MAIN TAB BAR CONTROLLER : RECEIVED NOTIFICATION : CYCLE ID = %@", cycleId);
    if (cycleId) {
        self.currentCycleId = cycleId;
    }
}

# pragma mark - Autorotation

- (void)orientationChanged:(NSNotification *)notification
{
    BOOL isAnimating = self.cycleViewController.isBeingPresented || self.cycleViewController.isBeingDismissed;
    BOOL shouldRotate = [[NSUserDefaults standardUserDefaults] boolForKey: @"ShouldRotate"];
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
        if (shouldRotate) {
            inLandscape = YES;
            if (!isAnimating) {
                [self showCycleViewController];
            }
        }
    } else {
        if (shouldRotate){
            inLandscape = NO;
            if (!isAnimating) {
                [self hideCycleViewController];
            }
        }
    }
}

- (void)hideCycleViewController
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)showCycleViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Tracking" bundle: nil];
    UINavigationController *navVC = [storyboard instantiateViewControllerWithIdentifier: @"ilcycleNavViewController"];
    navVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    ILCycleViewController *cycleVC = navVC.childViewControllers[0];
    cycleVC.selectedCycleId = self.currentCycleId;
    self.currentCycleId = nil;
    
    [self presentViewController: navVC animated: YES completion: nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return self.selectedViewController.preferredStatusBarStyle;
}

#pragma mark - Set/Get

- (CycleViewController *)oldCycleViewController
{
    if (!_oldCycleViewController) {
        _oldCycleViewController = [[CycleViewController alloc] init];
        _oldCycleViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    
    return _oldCycleViewController;
}

- (UINavigationController *)cycleViewController
{
    if (!_cycleViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Tracking" bundle: nil];
        _cycleViewController = [storyboard instantiateViewControllerWithIdentifier: @"ilcycleNavViewController"];
        _cycleViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    
    return _cycleViewController;
}

@end
