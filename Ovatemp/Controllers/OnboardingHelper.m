//
//  OnboardingHelper.m
//  Ovatemp
//
//  Created by Daniel Lozano on 5/4/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "OnboardingHelper.h"

@implementation OnboardingHelper


+ (void)showOnboardingInController:(UIViewController *)controller
{
    NSString *viewControllerIdentifier;
    
    switch ([self onboardingCompletionCount]) {
        case 0:{
            viewControllerIdentifier = @"welcome1VC";
            break;
        }
        case 1:{
            viewControllerIdentifier = @"welcome1VC";
            break;
        }
        case 2:{
            viewControllerIdentifier = @"welcome1VC";
            break;
        }
        case 3:{
            viewControllerIdentifier = @"welcome3VC";
            break;
        }
        case 4:{
            viewControllerIdentifier = @"welcomeONDOVC";
            break;
        }
        case 5:{
            viewControllerIdentifier = @"welcomeALARMVC";
            break;
        }
        default:
            return;
            break;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool: YES forKey: @"OnboardingWasPresented"];
    [userDefaults synchronize];
    
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName: @"Login" bundle: nil];
    UIViewController *viewController = [loginStoryboard instantiateViewControllerWithIdentifier: viewControllerIdentifier];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController: viewController];
    
    [controller presentViewController: navVC animated: YES completion: nil];
}

+ (NSInteger)onboardingCompletionCount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger onboardingCompletionCount = [defaults integerForKey: @"OnboardingCompletionCount"];
    return onboardingCompletionCount;
}

@end
