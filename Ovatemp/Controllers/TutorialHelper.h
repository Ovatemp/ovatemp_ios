//
//  TutorialHelper.h
//  Ovatemp
//
//  Created by Daniel Lozano on 4/23/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TutorialHelper : NSObject

+ (void)showAppWalkthroughInController:(UIViewController *)controller;
+ (void)showAppTutorialInController:(UIViewController *)controller;
+ (void)showTutorialForOndoInController:(UIViewController *)controller;

+ (BOOL)shouldShowAppWalkthrough;
+ (BOOL)shouldShowAppTutorial;
+ (BOOL)shouldShowOndoTutorial;

@end
