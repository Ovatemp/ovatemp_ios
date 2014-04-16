//
//  MainTabBarViewController.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/14/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "MainTabBarViewController.h"

#import "CycleViewController.h"

@interface MainTabBarViewController ()

@property CycleViewController *cycleViewController;

@end

@implementation MainTabBarViewController

- (id)init {
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

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIDeviceOrientationDidChangeNotification
                                                object:nil];
}

# pragma mark - Autorotation

- (void)orientationChanged:(NSNotification *)notification {
  if (!self.cycleViewController) {
    self.cycleViewController = [[CycleViewController alloc] init];
    self.cycleViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  }
  
  UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
  if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
    if (!self.cycleViewController.isBeingPresented && !self.cycleViewController.isBeingDismissed) {
      [self presentViewController:self.cycleViewController animated:YES completion:nil];
    }
  } else {
    if (!self.cycleViewController.isBeingPresented && !self.cycleViewController.isBeingDismissed) {
      [self.cycleViewController dismissViewControllerAnimated:YES completion:nil];
    }
  }
}

@end
