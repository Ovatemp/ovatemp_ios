//
//  TutorialHelper.m
//  Ovatemp
//
//  Created by Daniel Lozano on 4/23/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "TutorialHelper.h"

#import "TutorialViewController.h"

#import "OndoTutorialImageViewController.h"

@implementation TutorialHelper

+ (void)showAppWalkthroughInController:(UIViewController *)controller
{
    NSArray *ondoTutorialImages = @[[UIImage imageNamed: @"Walkthru1"],[UIImage imageNamed: @"Walkthru2"],[UIImage imageNamed: @"Walkthru3"],[UIImage imageNamed: @"Walkthru4"]];
    
    [self showTutorialWithImages: ondoTutorialImages onViewController: controller darkMode: NO];
    [self incrementWalkthroughCount];
}

+ (void)showAppTutorialInController:(UIViewController *)controller
{
    NSArray *ondoTutorialImages = @[[UIImage imageNamed: @"Tutorial1"],[UIImage imageNamed: @"Tutorial2"],[UIImage imageNamed: @"Tutorial3"],[UIImage imageNamed: @"Tutorial4"]];
    
    [self showTutorialWithImages: ondoTutorialImages onViewController: controller darkMode: NO];
    [self incrementAppTutorialCount];
}

+ (void)showTutorialForOndoInController:(UIViewController *)controller
{
//    NSArray *ondoTutorialImages = @[[UIImage imageNamed: @"OndoTutorial1"],[UIImage imageNamed: @"OndoTutorial2"],[UIImage imageNamed: @"OndoTutorial3"],[UIImage imageNamed: @"OndoTutorial4"],[UIImage imageNamed: @"OndoTutorial5"],[UIImage imageNamed: @"OndoTutorial6"]];
//    
//    [self showTutorialWithImages: ondoTutorialImages onViewController: controller darkMode: NO];
//    [self incrementOndoTutorialCount];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Tutorials" bundle: nil];
    OndoTutorialImageViewController *tutorialVC = [storyboard instantiateViewControllerWithIdentifier: @"OndoTutorialImageViewController"];
    tutorialVC.index = 0;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController: tutorialVC];
    [controller presentViewController: navVC animated: YES completion: nil];
}

+ (void)showCoachingIntroInController:(UIViewController *)controller
{
    NSArray *ondoTutorialImages = @[[UIImage imageNamed: @"Coaching1"],[UIImage imageNamed: @"Coaching2"],[UIImage imageNamed: @"Coaching3"],[UIImage imageNamed: @"Coaching4"]];
    
    [self showTutorialWithImages: ondoTutorialImages onViewController: controller darkMode: YES];
    [self incrementCoachingIntroCount];
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

+ (BOOL)shouldShowCoachingIntro
{
    NSUInteger count = [self countForKey: kCoachingIntroCountKey];
    
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

+ (void)incrementCoachingIntroCount
{
    [self incrementCountWithKey: kCoachingIntroCountKey];
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

+ (void)showTutorialWithImages:(NSArray *)images onViewController:(UIViewController *)controller darkMode:(BOOL)darkMode
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Tutorials" bundle: nil];
    TutorialViewController *tutorialVC = [storyboard instantiateInitialViewController];
    tutorialVC.images = images;
    tutorialVC.darkMode = darkMode;
    
    [controller presentViewController: tutorialVC animated: YES completion: nil];
}

@end
