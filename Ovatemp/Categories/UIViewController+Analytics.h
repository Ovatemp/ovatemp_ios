//
//  UIViewController+Analytics.h
//  Ovatemp
//
//  Created by Flip Sasser on 4/14/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Analytics)

- (void)trackScreenView;
- (void)trackScreenView:(NSString *)name;

@end
