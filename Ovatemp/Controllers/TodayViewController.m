//
//  TodayViewController.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TodayViewController.h"
#import "Calendar.h"
#import "UIViewController+ConnectionManager.h"
#import "Day.h"
#import "DayCell.h"
#import "CycleViewController.h"
#import "Cycle.h"

@interface TodayViewController ()

@property NSArray *rowIdentifiers;
@property NSMutableArray *rowExemplars;
@property BOOL isShowingLandscapeView;
@property CycleViewController *cycleViewController;

@end

@implementation TodayViewController

#define kFertilityRowHeight 28;
#define kDayRowHeight 139;

#pragma mark - Setup

- (void)viewDidLoad {
  [super viewDidLoad];

  UITableView *table = (UITableView *)self.view;
  table.isAccessibilityElement = TRUE;
  table.accessibilityIdentifier = @"Checklist";

  // Align separators left
  table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

  // Don't show separators after the last item
  table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

  [[Calendar sharedInstance] addObserver: self
                              forKeyPath: @"day"
                                 options: NSKeyValueObservingOptionNew
                                 context: NULL];


  self.rowIdentifiers = @[@"TemperatureDayCell", @"PeriodDayCell", @"FluidDayCell", @"IntercourseDayCell", @"SymptomsDayCell", @"SupplementsDayCell", @"SignsDayCell"];
  self.rowExemplars = [NSMutableArray array];

  for(NSString *name in self.rowIdentifiers) {
    [table registerNib:[UINib nibWithNibName:name bundle:nil] forCellReuseIdentifier:name];
    UIView *cellView = [[[NSBundle mainBundle] loadNibNamed:name owner:self options:nil] objectAtIndex:0];
    [self.rowExemplars addObject:cellView];
  }

  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(applicationWillResign)
   name:UIApplicationWillResignActiveNotification
   object:NULL];

  [self setupLandscape];
}

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

- (void)orientationChanged:(NSNotification *)notification
{
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

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  self.day = nil;
  [Day resetInstances];

  [self dateChanged];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  // Make sure to save the day before we leave
  [self.day save];
  self.day = nil;
}

- (void)applicationWillResign {
  [self.day save];
  self.day = nil;
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context
{
  if([keyPath isEqualToString:@"day"] && [[Calendar sharedInstance] class] == [object class]) {
    [self dateChanged];
  }
}

#pragma mark - Table view data source

- (void)dateChanged {
  // Make sure to save the day before we leave
  [self.day save];
  self.day = [Calendar day];

  [self dayChanged];
}

- (void)dayChanged {
  [(UITableView*)self.view reloadData];
  [self.cycleViewController setCycle:self.day.cycle];
}

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
  UIView *exemplar = self.rowExemplars[indexPath.row];
  return exemplar.frame.size.height;
}

@end
