//
//  UIViewController+WithNavigation.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "UIViewController+WithNavigation.h"

@implementation UIViewController (WithNavigation)

#pragma mark - Navigation controller wrapping

- (UINavigationController *)withNavigation {
  UINavigationController *navigationController = self.navigationController;
  if (!navigationController) {
    navigationController = [[UINavigationController alloc] initWithRootViewController:self];
  }
  return navigationController;
}

@end
