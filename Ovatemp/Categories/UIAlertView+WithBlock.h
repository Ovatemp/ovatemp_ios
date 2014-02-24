//
//  UIAlertView+WithBlock.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/24/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (WithBlock)

- (void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion;

@end
