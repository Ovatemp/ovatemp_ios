//
//  NavigationViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "OTDayNavigationController.h"
#import "Calendar.h"
#import "Day.h"

@interface OTDayNavigationController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation OTDayNavigationController

- (id)initWithContentViewController:(UIViewController *)contentViewController {
  self = [super initWithNibName:@"OTDayNavigationController" bundle:nil];
  if (self) {
    self.contentViewController = contentViewController;
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  UIView *content = self.contentViewController.view;
  content.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);

  self.dayNavigationView.backgroundColor = GREY;

  // Adopt the content view controller
  [self.contentView addSubview:self.contentViewController.view];
  [self addChildViewController:self.contentViewController];
  [self.contentViewController didMoveToParentViewController:self];

  self.dateFormatter = [[NSDateFormatter alloc] init];
  [self.dateFormatter setDateFormat:@"E, MMM d y"];
}

- (void)viewWillAppear:(BOOL)animated {
  [self updateLabels];
  [[Calendar sharedInstance] addObserver: self
                              forKeyPath: @"day"
                                 options: NSKeyValueObservingOptionNew
                                 context: NULL];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[Calendar sharedInstance] removeObserver:self forKeyPath:@"day"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqualToString:@"day"] && [[Calendar sharedInstance] class] == [object class]) {
    [self updateLabels];
  }
}

- (void)updateLabels {
  CATransition *animation = [CATransition animation];
  animation.duration = 0.15;
  animation.type = kCATransitionFade;
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  [self.dateLabel.layer addAnimation:animation forKey:@"changeTextTransition"];
  self.dateLabel.text = [self.dateFormatter stringFromDate:Calendar.day.date];

  if (Calendar.day) {
    self.dayBackwardButton.enabled = YES;
    self.dayForwardButton.enabled = YES;
    self.dayForwardButton.hidden = [Calendar isOnToday];
    self.fertilityStatusView.hidden = FALSE;

    [self.fertilityStatusView updateWithDay:[Day forDate:[NSDate date]]];

    if(Calendar.day.cycle) {
      self.titleLabel.text = [NSString stringWithFormat: @"Cycle Day: #%@", Calendar.day.cycleDay];
    } else {
      self.titleLabel.text = @"No cycle found.";
    }
  } else {
    self.dayBackwardButton.enabled = NO;
    self.dayForwardButton.enabled = NO;
    self.fertilityStatusView.hidden = TRUE;

    self.titleLabel.text = @"Loading...";
  }
}

- (IBAction)moveDayForward:(id)sender {
  [Calendar stepDay:1];
}

- (IBAction)moveDayBackward:(id)sender {
  [Calendar stepDay:-1];
}

- (BOOL)shouldAutorotate {
  return [self.contentViewController shouldAutorotate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return [self.contentViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (NSUInteger)supportedInterfaceOrientations {
  return [self.contentViewController supportedInterfaceOrientations];
}

@end
