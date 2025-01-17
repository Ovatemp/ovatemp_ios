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
#import "FertilityProfile.h"
#import "Question.h"
#import "User.h"

@interface QuizViewController () {
  BOOL appeared;
}

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
}

- (void)viewWillAppear:(BOOL)animated {
  if (!appeared) {
    appeared = YES;

    if (self.questions.count < 1) {
      self.questionLabel.text = @"Loading...";
      self.yesButton.hidden = TRUE;
      self.noButton.hidden = TRUE;

      [self loadQuestions];
      [self trackScreenView:@"Quiz"];
      [self trackEvent:@"Started Quiz" action:nil label:nil value:nil];
    } else {
      [self loadNextQuestion];
    }
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
    self.questions = [[NSMutableArray alloc] initWithCapacity:questions.count];
    self.currentQuestion = 0;
    BOOL setCurrentQuestion = NO;
    for (NSInteger i = 0; i < questions.count; i++) {
      NSDictionary *attributes = questions[i];
      Question *question = [Question withAttributes:attributes];
      [self.questions addObject:question];
      if (!question.answered && !setCurrentQuestion) {
        setCurrentQuestion = YES;
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
                          (int)self.currentQuestion + 1,
                          (int)self.questions.count];

  self.yesButton.hidden = FALSE;
  self.noButton.hidden = FALSE;

  self.question = self.questions[self.currentQuestion];

  if (self.question.answered) {
    if (self.question.answer) {
      self.noButton.selected = NO;
      self.yesButton.selected = YES;
    } else {
      self.noButton.selected = YES;
      self.yesButton.selected = NO;
    }
  } else {
    self.noButton.selected = NO;
    self.yesButton.selected = NO;
  }

  self.backButton.hidden = self.currentQuestion == 0;
  self.skipButton.hidden = !self.question.answered;
}

- (void)answerQuestion:(BOOL)yes {
  [self startLoadingWithBackground:[UIColor colorWithWhite:1 alpha:0] spinnerColor:GREEN];
  [self.question answer:yes success:^(id response){
    [self stopLoading];
    self.currentQuestion++;
    [self loadNextQuestion];
  } failure:^(id error){
    [self stopLoading];
    [Alert presentError:error];
  }];
}

- (void)setQuestion:(Question *)question {
  _question = question;

  self.questionLabel.text = question.text;
}

- (IBAction)yesTapped:(id)sender {
  [self answerQuestion:YES];
  [self trackEvent:@"ui_action" action:@"tap" label:@"yes_button" value:nil];
}

- (IBAction)noTapped:(id)sender {
  [self answerQuestion:NO];
  [self trackEvent:@"ui_action" action:@"tap" label:@"no_button" value:nil];
}

- (BOOL)shouldAutorotate {
  return FALSE;
}

# pragma mark - Loading fertility profile at end of quiz

- (void)loadFertilityProfile {
  [self trackEvent:@"Finished Quiz" action:nil label:nil value:nil];
  [self startLoading];
  [FertilityProfile loadAndThen:^(id response) {
    [self fertilityProfileLoaded:response];
  } failure:^(NSError *error) {
    [self fertilityProfileLoadFailed:error];
  }];
}

- (void)fertilityProfileLoaded:(id)response {
  [self stopLoading];

  if ([User current].fertilityProfileName) {
    [self.navigationController popViewControllerAnimated:NO];
  } else {
    [self loadQuestions];
  }
}

- (void)fertilityProfileLoadFailed:(NSError *)error {
  [Alert presentError:error];
  [self loadQuestions];
}

@end
