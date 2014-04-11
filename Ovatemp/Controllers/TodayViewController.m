//
//  TodayViewController.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TodayViewController.h"
#import "Calendar.h"
#import "Cycle.h"
#import "CycleViewController.h"
#import "Day.h"
#import "DayCell.h"

@interface TodayViewController ()

@property NSArray *rowIdentifiers;
@property NSMutableArray *rowExemplars;
@property BOOL isShowingLandscapeView;
@property CycleViewController *cycleViewController;

@end

@implementation TodayViewController

#pragma mark - Setup

- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableView.isAccessibilityElement = TRUE;
  self.tableView.accessibilityIdentifier = @"Checklist";

  // Align separators left
  self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

  // Don't show separators after the last item
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

  self.rowIdentifiers = @[@"TemperatureDayCell", @"PeriodDayCell", @"FluidDayCell", @"IntercourseDayCell", @"SymptomsDayCell", @"SupplementsDayCell", @"SignsDayCell"];
  self.rowExemplars = [NSMutableArray array];

  for(NSString *name in self.rowIdentifiers) {
    [self.tableView registerNib:[UINib nibWithNibName:name bundle:nil] forCellReuseIdentifier:name];
    UIView *cellView = [[[NSBundle mainBundle] loadNibNamed:name owner:self options:nil] objectAtIndex:0];
    [self.rowExemplars addObject:cellView];
  }


  [self setupLandscape];
}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [[Calendar sharedInstance] addObserver:self
                              forKeyPath:@"day"
                                 options:NSKeyValueObservingOptionNew
                                 context:NULL];


  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(applicationWillResign)
   name:UIApplicationWillResignActiveNotification
   object:NULL];

  self.day = nil;
  [self dateChanged];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  [[NSNotificationCenter defaultCenter]
   removeObserver:self
   name:UIApplicationWillResignActiveNotification
   object:nil];

  [[Calendar sharedInstance] removeObserver:self forKeyPath:@"day"];

  // Make sure to save the day before we leave
  [self.day save];
  self.day = nil;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter]
   removeObserver:self
   name:UIDeviceOrientationDidChangeNotification
   object:nil];
}

- (void)applicationWillResign {
  [self.day save];
  self.day = nil;
}

# pragma mark - Reactions to date changes

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context
{
  if([keyPath isEqualToString:@"day"] && [[Calendar sharedInstance] class] == [object class]) {
    [self dateChanged];
  }
}

- (void)dateChanged {
  // Make sure to save the day before we leave
  [self.day save];
  self.day = [Calendar day];

  [self dayChanged];
}

- (void)dayChanged {
  [self.tableView reloadData];
  [self.cycleViewController setCycle:self.day.cycle];
}


#pragma mark - Rotation

// We are using a custom rotation technique, presenting a modal view controller of the
// chart when appropriate.
- (void)setupLandscape {
  self.cycleViewController = [[CycleViewController alloc] init];
  self.cycleViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  self.isShowingLandscapeView = NO;

  [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(orientationChanged:)
                                               name:UIDeviceOrientationDidChangeNotification
                                             object:nil];
}

- (BOOL)shouldAutorotate {
  return FALSE;
}

- (void)orientationChanged:(NSNotification *)notification
{
  // We can still present a modal even if we aren't the active tab,
  // prevent that
  if(self.tabBarController.selectedIndex != 0) {
    return;
  }

  if([self isCorrectOrientation]) {
    return;
  }

  UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
  if(UIDeviceOrientationIsLandscape(deviceOrientation)) {
    [self.cycleViewController setCycle:self.day.cycle];
    self.isShowingLandscapeView = YES;
    [self presentViewController:self.cycleViewController animated:NO completion:nil];
  } else {
    [self.cycleViewController dismissViewControllerAnimated:NO completion:nil];
    self.isShowingLandscapeView = NO;
  }
}

- (BOOL)isCorrectOrientation {
  UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;

  return (UIDeviceOrientationIsLandscape(deviceOrientation) && self.isShowingLandscapeView) ||
  (UIDeviceOrientationIsPortrait(deviceOrientation) && !self.isShowingLandscapeView);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.rowExemplars count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  DayCell *cell = (DayCell *)[tableView dequeueReusableCellWithIdentifier:self.rowIdentifiers[indexPath.row]];
  cell.day = self.day;

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  // Get the height directly from the xib, so we only have to change it in one place
  // The overhead is one extra copy of the view per row.
  UIView *exemplar = self.rowExemplars[indexPath.row];
  return exemplar.frame.size.height;
}


@end
