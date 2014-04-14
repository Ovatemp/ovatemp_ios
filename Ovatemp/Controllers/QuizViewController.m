//
//  QuizViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/26/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "QuizViewController.h"

#import "Alert.h"
#import "BorderedGradientButton.h"
#import "Question.h"
#import "User.h"

@interface QuizViewController ()

@property NSInteger currentQuestion;
@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) NSMutableArray *questions;

@property BOOL loadedOnce;

@end

@implementation QuizViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  for (BorderedGradientButton *button in @[self.yesButton, self.noButton]) {
    button.clipsToBounds = YES;

    CGRect rect = button.frame;
    rect.size.height = rect.size.width;
    button.frame = rect;
    button.cornerRadius = button.frame.size.width / 2;
    button.borderWidth = 2.0f;
  }

  self.questions = [[NSMutableArray alloc] initWithCapacity:10];
}

- (void)viewWillAppear:(BOOL)animated {
  if(self.questions.count < 1) {
    self.questionLabel.text = @"Loading...";
    self.yesButton.hidden = TRUE;
    self.noButton.hidden = TRUE;

    [self loadFertilityProfile];
  } else {
    [self loadNextQuestion];
  }
}

# pragma mark - Load questions

- (void)cancelLoadQuestions:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadQuestions:(id)sender {
  [self loadQuestions];
}

- (void)loadQuestions {
  [ConnectionManager get:@"/questions"
                  target:self
                 success:@selector(questionsLoaded:)
                 failure:@selector(questionsLoadFailed:)];
}

- (void)questionsLoaded:(NSDictionary *)response {
  NSArray *questions = response[@"questions"];
  if(questions) {
    for (NSInteger i = 0; i < questions.count; i++) {
      NSDictionary *attributes = questions[i];
      Question *question = [Question withAttributes:attributes];
      [self.questions addObject:question];
      if (!question.answered && !isnormal(self.currentQuestion)) {
        self.currentQuestion = i;
      }
    }
  }

  [self loadNextQuestion];
  [self stopLoading];
}

- (void)questionsLoadFailed:(NSError *)error {
  [self stopLoading];
  Alert *alert = [Alert alertForError:error];
  [alert addButtonWithTitle:@"Cancel"
                    target:self
                    action:@selector(cancelLoadQuestions:)];
  [alert addButtonWithTitle:@"Retry"
                    target:self
                    action:@selector(loadQuestions:)];
  [alert show];
}

# pragma mark - Question navigation

- (void)nextQuestion:(id)sender {
  self.currentQuestion++;
  [self loadNextQuestion];
}

- (void)previousQuestion:(id)sender {
  self.currentQuestion--;
  [self loadNextQuestion];
}

- (void)loadNextQuestion {
  if (self.currentQuestion >= self.questions.count) {
    [self loadFertilityProfile];
    return;
  } else if (self.currentQuestion < 0) {
    self.currentQuestion = 0;
  }
  
  self.countLabel.text = [NSString stringWithFormat:@"%i of %i",
                          self.currentQuestion + 1,
                          self.questions.count];
  
  self.yesButton.hidden = FALSE;
  self.noButton.hidden = FALSE;

  self.question = self.questions[self.currentQuestion];
  
  self.backButton.hidden = self.currentQuestion == 0;
  self.skipButton.hidden = !self.question.answered;
}

- (void)answerQuestion:(BOOL)yes {
  [self.question answer:yes success:^(id response){} failure:^(id error){
    // HANDLEERROR
    NSLog(@"Could not answer question: %@", error);
  }];
  self.currentQuestion++;
  [self loadNextQuestion];
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

# pragma mark - Loading fertility profile at end of quiz

- (void)loadFertilityProfile {
  [self startLoading];
  [ConnectionManager get:@"/fertility_profiles" target:self success:@selector(fertilityProfileLoaded:) failure:@selector(fertilityProfileLoadFailed:)];
}

- (void)fertilityProfileLoaded:(id)response {
  [self stopLoading];

  NSString *fertility_profile_name = response[@"fertility_profile_name"];
  if(fertility_profile_name) {
    [User current].fertilityProfileName = fertility_profile_name;
    NSDictionary *coaching_content_urls = response[@"coaching_content_urls"];
    if(coaching_content_urls) {
      [Configuration sharedConfiguration].coachingContentUrls = coaching_content_urls;
    }
    
    [self.navigationController popViewControllerAnimated:NO];
  } else {
    [self loadQuestions];
  }
}

- (void)fertilityProfileLoadFailed:(NSError *)error {
  [self loadQuestions];
}

@end
