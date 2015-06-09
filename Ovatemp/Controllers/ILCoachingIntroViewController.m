//
//  ILCoachingIntroViewController.m
//  Ovatemp
//
//  Created by Daniel Lozano on 6/3/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILCoachingIntroViewController.h"

#import "User.h"
#import "TutorialHelper.h"
#import "QuizViewController.h"

@interface ILCoachingIntroViewController ()

@end

@implementation ILCoachingIntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self customizeAppearance];
    [self updateScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    [self showIntro];
    [self pushAppropiateController];
}

#pragma mark - Tutorial

- (void)showIntro
{
    //if ([TutorialHelper shouldShowCoachingIntro]) {
        [TutorialHelper showCoachingIntroInController: self];
    //}
}

#pragma mark - Appearance / Set-Up

- (void)pushAppropiateController
{
    BOOL hasFertilityProfile = [User current].fertilityProfileName != nil;

    if (!hasFertilityProfile) {
        UIViewController *coachingVC = [self.storyboard instantiateViewControllerWithIdentifier: @"ILCoachingSummaryViewController"];
        [self.navigationController pushViewController: coachingVC animated: YES];
    }
}

- (void)updateScreen
{
    if (!self.onSecondScreen) {
        // First Screen
        self.headingLabel.text = @"The best way to get pregnant is to act pregnant.";
        self.subHeadingLabel.text = @"";
        [self.nextButton setTitle: @"Let's build your program" forState: UIControlStateNormal];
        
    }else{
        // Second Screen
        self.headingLabel.alpha = 0.0f;
        self.subHeadingLabel.alpha = 0.0f;
        
        self.headingLabel.text = @"To get started we need to find out more about you";
        self.subHeadingLabel.text = @"Simply answer YES or NO to the following statements, as they apply to you.";
        
        [UIView animateWithDuration: 0.5 animations:^{
            self.headingLabel.alpha = 1.0f;
            self.subHeadingLabel.alpha = 1.0f;
        }];
        
        [self.nextButton setTitle: @"Get Started" forState: UIControlStateNormal];
        
    }
}

- (void)customizeAppearance
{
    self.navigationController.navigationBar.tintColor = [UIColor purpleColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor ovatempDarkGreyTitleColor]};
}

#pragma mark - IBAction

- (IBAction)didSelectNext:(id)sender
{
    if (!self.onSecondScreen) {
        self.onSecondScreen = YES;
        [self updateScreen];
    }else{
        // Go to next view controller (Start Quiz)
        QuizViewController *quizVC = [self.storyboard instantiateViewControllerWithIdentifier: @"QuizViewController"];
        [self.navigationController pushViewController: quizVC animated: YES];
    }
}

@end
