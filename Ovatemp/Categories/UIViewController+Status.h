//
//  UIViewController+Status.h
//  Ovatemp
//
//  Created by Flip Sasser on 5/22/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Status)

- (void)flashStatus:(NSString *)statusText;
- (void)flashStatus:(NSString *)statusText duration:(CGFloat)duration;
- (void)hideStatus;

@end
