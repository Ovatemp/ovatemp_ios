//
//  QuizViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/26/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "QuizViewController.h"
#import "Question.h"

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
  for(int i=0; i < 10; i++) {
    Question *question = [[Question alloc] init];
    question.text = [NSString stringWithFormat:@"Do you have %d friends?", i];
    [self.questionQueue addObject:question];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [self popQuestion];
}

- (Question *)popQuestion {
  if(self.questionQueue.count < 1) {
    NSLog(@"stop this quiz.");
    [self.navigationController popViewControllerAnimated:NO];
    return nil;
  }

  self.question = self.questionQueue[0];
  [self.questionQueue removeObjectAtIndex:0];

  return self.question;
}

- (void)answerQuestion:(BOOL)yes {
  [self.question answer:yes success:nil failure:nil];
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
