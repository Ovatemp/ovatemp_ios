//
//  TutorialHelper.m
//  Ovatemp
//
//  Created by Daniel Lozano on 4/23/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "TutorialHelper.h"

#import "TutorialViewController.h"

@implementation TutorialHelper

+ (void)showAppWalkthroughInController:(UIViewController *)controller
{
    NSArray *ondoTutorialImages = @[[UIImage imageNamed: @"Walkthru1"],[UIImage imageNamed: @"Walkthru2"],[UIImage imageNamed: @"Walkthru3"],[UIImage imageNamed: @"Walkthru4"]];
    
    [self showTutorialWithImages: ondoTutorialImages onViewController: controller];
    [self incrementWalkthroughCount];
}

+ (void)showAppTutorialInController:(UIViewController *)controller
{
    NSArray *ondoTutorialImages = @[[UIImage imageNamed: @"Tutorial1"],[UIImage imageNamed: @"Tutorial2"],[UIImage imageNamed: @"Tutorial3"],[UIImage imageNamed: @"Tutorial4"]];
    
    [self showTutorialWithImages: ondoTutorialImages onViewController: controller];
    [self incrementAppTutorialCount];
}

+ (void)showTutorialForOndoInController:(UIViewController *)controller
{
    NSArray *ondoTutorialImages = @[[UIImage imageNamed: @"OndoTutorial1"],[UIImage imageNamed: @"OndoTutorial2"],[UIImage imageNamed: @"OndoTutorial3"],[UIImage imageNamed: @"OndoTutorial4"],[UIImage imageNamed: @"OndoTutorial5"],[UIImage imageNamed: @"OndoTutorial6"]];
    
    [self showTutorialWithImages: ondoTutorialImages onViewController: controller];
    [self incrementOndoTutorialCount];
}

+ (BOOL)shouldShowAppWalkthrough
{
    NSInteger count = [self countForKey: kAppWalkthroughCountKey];
    
    if (count >= 1) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)shouldShowAppTutorial
{
    NSInteger count = [self countForKey: kAppTutorialCountKey];
    
    if (count >= 1) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)shouldShowOndoTutorial
{
    NSInteger count = [self countForKey: kOndoTutorialCountKey];
    
    if (count >= 1) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Private

+ (void)incrementWalkthroughCount
{
    [self incrementCountWithKey: kAppWalkthroughCountKey];
}

+ (void)incrementAppTutorialCount
{
    [self incrementCountWithKey: kAppTutorialCountKey];
}

+ (void)incrementOndoTutorialCount
{
    [self incrementCountWithKey: kOndoTutorialCountKey];
}

+ (void)incrementCountWithKey:(NSString *)key
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger count = [standardDefaults integerForKey: key];
    count++;
    [standardDefaults setInteger: count forKey: key];
}

+ (NSInteger)countForKey:(NSString *)key
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger count = [standardDefaults integerForKey: key];
    return count;
}

+ (void)showTutorialWithImages:(NSArray *)images onViewController:(UIViewController *)controller
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Tutorials" bundle: nil];
    TutorialViewController *tutorialVC = [storyboard instantiateInitialViewController];
    tutorialVC.images = images;
    
    [controller presentViewController: tutorialVC animated: YES completion: nil];
}

@end
