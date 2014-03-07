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

@interface TodayViewController ()

@property NSArray *rowIdentifiers;
@property NSMutableArray *rowExemplars;

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
                              forKeyPath: @"date"
                                 options: NSKeyValueObservingOptionNew
                                 context: NULL];


  self.rowIdentifiers = @[@"TemperatureDayCell", @"PeriodDayCell", @"FluidDayCell", @"IntercourseDayCell", @"SymptomsDayCell", @"SupplementsDayCell", @"SignsDayCell"];
  self.rowExemplars = [NSMutableArray array];

  for(NSString *name in self.rowIdentifiers) {
    [table registerNib:[UINib nibWithNibName:name bundle:nil] forCellReuseIdentifier:name];
    UIView *cellView = [[[NSBundle mainBundle] loadNibNamed:name owner:self options:nil] objectAtIndex:0];
    [self.rowExemplars addObject:cellView];
  }

  [self dateChanged];

  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(applicationWillResign)
   name:UIApplicationWillResignActiveNotification
   object:NULL];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  // Make sure to save the day before we leave
  [self.day save];
}

- (void)applicationWillResign {
  [self.day save];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context
{
  if([keyPath isEqualToString:@"date"] && [[Calendar sharedInstance] class] == [object class]) {
    [self dateChanged];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (void)dateChanged {
  // Make sure to save the day before we leave
  [self.day save];
  
  self.day = [Day forDate:[Calendar date]];

  if(self.day) {
    [(UITableView*)self.view reloadData];
  } else {
    [Day loadDate:[Calendar date]
          success:^(NSDictionary *response) {
            self.day = [Day withAttributes:response[@"day"]];
            [(UITableView*)self.view reloadData];

          }
          failure:^(NSError *error) {
            NSLog(@"done loading! error: %@", error);
          }];
  }
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
