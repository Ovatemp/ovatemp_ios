//
//  QuizViewController.h
//  Ovatemp
//
//  Created by Chris Cahoon on 3/26/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BorderedGradientButton, GradientButton;

@interface QuizViewController : UIViewController

@property (weak, nonatomic) IBOutlet BorderedGradientButton *yesButton;
@property (weak, nonatomic) IBOutlet BorderedGradientButton *noButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property IBOutlet GradientButton *backButton;
@property IBOutlet GradientButton *skipButton;

- (IBAction)nextQuestion:(id)sender;
- (IBAction)previousQuestion:(id)sender;

@end
