//
//  MainTabBarViewController.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/14/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "MainTabBarViewController.h"

#import "ILCycleViewController.h"

@interface MainTabBarViewController () {
  BOOL inLandscape;
}

@property (nonatomic) ILCycleViewController *cycleViewController;

@end

@implementation MainTabBarViewController

- (id)init
{
  self = [super init];
  if (self) {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
  }
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIDeviceOrientationDidChangeNotification
                                                object:nil];
}

# pragma mark - Autorotation

- (void)orientationChanged:(NSNotification *)notification
{
    BOOL isAnimating = self.cycleViewController.isBeingPresented || self.cycleViewController.isBeingDismissed;

    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShouldRotate"]) {
            inLandscape = YES;
            if (!isAnimating) {
                [self showCycleViewController];
            }
        }
    } else {
        inLandscape = NO;
        if (!isAnimating) {
            [self hideCycleViewController];
        }
    }
}

- (void)hideCycleViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
//        if (inLandscape) {
//            [self showCycleViewController];
//        }
    }];
}

- (void)showCycleViewController
{
    [self presentViewController:self.cycleViewController animated:YES completion:^{
//        if (!inLandscape) {
//            [self hideCycleViewController];
//        }
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return self.selectedViewController.preferredStatusBarStyle;
}

#pragma mark - Set/Get

- (ILCycleViewController *)cycleViewController
{
    if (!_cycleViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Tracking" bundle: nil];
        _cycleViewController = [storyboard instantiateViewControllerWithIdentifier: @"ilcycleNavViewController"];
        _cycleViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    
    return _cycleViewController;
}

@end
