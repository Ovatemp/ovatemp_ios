//
//  UIViewController+ConnectionManager.h
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ConnectionManager.h"

@interface UIViewController (ConnectionManager)

- (void)presentError:(NSError *)error;

@end
