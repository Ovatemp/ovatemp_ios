//
//  UIViewController+WithNavigation.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "UIViewController+WithNavigation.h"
#import "NavigationViewController.h"

@implementation UIViewController (WithNavigation)

#pragma mark - Navigation controller wrapping

- (NavigationViewController *)withNavigation {
  NavigationViewController *controller = [[NavigationViewController alloc] initWithContentViewController:self];
  return controller;
}

@end
