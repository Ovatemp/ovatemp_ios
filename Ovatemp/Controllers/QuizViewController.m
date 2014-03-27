//
//  QuizViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/26/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "QuizViewController.h"
#import "Question.h"
#import "UIViewController+Loading.h"
#import "User.h"

@interface QuizViewController ()

@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) NSMutableArray *questionQueue;

@property BOOL loadedOnce;

@end

@implementation QuizViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  for(UIButton *button in @[self.yesButton, self.noButton]) {
    button.clipsToBounds = YES;

    CGRect rect = button.frame;
    rect.size.height = rect.size.width;
    button.frame = rect;
    button.layer.cornerRadius = button.frame.size.width / 2;
    button.layer.borderColor =[UIColor redColor].CGColor;
    button.layer.borderWidth= 2.0f;
  }

  self.questionQueue = [[NSMutableArray alloc] initWithCapacity:10];
}

- (void)viewWillAppear:(BOOL)animated {
  if(self.questionQueue.count < 1) {
    self.questionLabel.text = @"Loading...";
    self.yesButton.hidden = TRUE;
    self.noButton.hidden = TRUE;

    [self startLoading];
    [ConnectionManager get:@"/fertility_profiles" params:@{}
                   success:^(id response) {
                     NSArray *questions = response[@"questions"];
                     if(questions) {
                       for(NSDictionary *q in questions) {
                         [self.questionQueue addObject:[Question withAttributes:q]];
                       }
                     }

                     NSString *fertility_profile_name = response[@"fertility_profile_name"];
                     if(fertility_profile_name) {
                       [User current].fertilityProfileName = fertility_profile_name;
                     }

                     NSDictionary *coaching_content_urls = response[@"coaching_content_urls"];
                     if(coaching_content_urls) {
                       [Configuration sharedConfiguration].coachingContentUrls = coaching_content_urls;
                     }

                     [self popQuestion];
                     [self stopLoading];
                   }
                   failure:^(NSError *error) {
                     NSLog(@"couldn't load questions");

                     [self stopLoading];
                   }];
  } else {
    [self popQuestion];
  }
}

- (Question *)popQuestion {
  if(self.questionQueue.count < 1) {
    [self.navigationController popViewControllerAnimated:NO];
    return nil;
  }

  self.yesButton.hidden = FALSE;
  self.noButton.hidden = FALSE;

  self.question = self.questionQueue[0];
  [self.questionQueue removeObjectAtIndex:0];

  return self.question;
}

- (void)answerQuestion:(BOOL)yes {
  [self.question answer:yes success:^(id response){} failure:^(id error){} ];
  [self popQuestion];
}

- (void)setQuestion:(Question *)question {
  _question = question;

  self.questionLabel.text = question.text;
}

- (IBAction)yesTapped:(id)sender {
  [self answerQuestion:YES];
}

- (IBAction)noTapped:(id)sender {
  [self answerQuestion:NO];
}

- (BOOL)shouldAutorotate {
  return FALSE;
}

@end
