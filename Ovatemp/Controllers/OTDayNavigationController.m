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

// Temporary, until we get the actual cycle day
@property (nonatomic, strong) NSDateFormatter *dayFormatter;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

  UIView *content = self.contentViewController.view;
  content.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);

  // Adopt the content view controller
  [self.contentView addSubview:self.contentViewController.view];
  [self addChildViewController:self.contentViewController];
  [self.contentViewController didMoveToParentViewController:self];

  [[Calendar sharedInstance] addObserver: self
         forKeyPath: @"day"
            options: NSKeyValueObservingOptionNew
            context: NULL];

  self.dateFormatter = [[NSDateFormatter alloc] init];
  [self.dateFormatter setDateFormat:@"E, MMM d y"];

  self.dayFormatter = [[NSDateFormatter alloc] init];
  [self.dayFormatter setDateFormat:@"d"];

  [self updateLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
  if([keyPath isEqualToString:@"day"] && [[Calendar sharedInstance] class] == [object class]) {
    [self updateLabels];
  }
}

- (void)updateLabels {
  NSString *titleFormat = @"Cycle Day: #%@";

  self.dateLabel.text = [self.dateFormatter stringFromDate:Calendar.day.date];
  self.titleLabel.text = [NSString stringWithFormat:titleFormat, Calendar.day.cycleDay];

  self.dayForwardButton.hidden = [Calendar isOnToday];
  [self.fertilityStatusView updateWithDay:Calendar.day];
}

- (IBAction)moveDayForward:(id)sender {
  [Calendar stepDay:1];
}

- (IBAction)moveDayBackward:(id)sender {
  [Calendar stepDay:-1];
}

@end
