//
//  UITabBarController+Rotations.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/26/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "UITabBarController+Rotations.h"

@implementation UITabBarController (Rotations)

- (BOOL)shouldAutorotate
{
  return [self.selectedViewController shouldAutorotate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  return [self.selectedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (NSUInteger)supportedInterfaceOrientations
{
  return [self.selectedViewController supportedInterfaceOrientations];
}

@end

@implementation UINavigationController (navrotations)

- (BOOL)shouldAutorotate {

  return [self.topViewController shouldAutorotate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  return [self.topViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (NSUInteger)supportedInterfaceOrientations
{
  return [self.topViewController supportedInterfaceOrientations];
}

@end
