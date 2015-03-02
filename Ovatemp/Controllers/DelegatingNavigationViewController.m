//
//  DelegatingNavigationViewController.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/4/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "DelegatingNavigationViewController.h"

@interface DelegatingNavigationViewController ()

@end

@implementation DelegatingNavigationViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return self.visibleViewController.preferredStatusBarStyle;
}

@end
