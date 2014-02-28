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
  self.day = [Day forDate:[Calendar date]];

  if(!self.day) {
    // Create day response
    [ConnectionManager get:@"/days"
                    params:@{
                             @"day": @{
                                  @"date": [[Calendar date] shortDate],
                                 },
                             }
                    target:self
                   success:@selector(dayLoaded:)
                   failure:@selector(presentError:)
     ];
  } else {
    [(UITableView*)self.view reloadData];
  }
}

- (void)dayLoaded:(NSDictionary *)response {
  self.day = [Day withAttributes:response[@"day"]];

  [(UITableView*)self.view reloadData];
}

- (void)presentError:(NSError *)error {
  NSLog(@"done loading! error: %@", error);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch(section) {
    case 0:
      return 0;
      break;
    case 1:
      return [self.rowExemplars count];
      break;
    default:
      return 0;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if(indexPath.section == 1) {
    return [self tableView:tableView dayCellForRow:indexPath.row];
  }

  static NSString *FertileCellIdentifier = @"FertileCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FertileCellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FertileCellIdentifier];

    cell.textLabel.text = @"You're fertile! Go have sex!";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor blueColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
  }

  return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView dayCellForRow:(NSUInteger)row {
  DayCell *cell = (DayCell *)[tableView dequeueReusableCellWithIdentifier:self.rowIdentifiers[row]];
  cell.day = self.day;

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if(indexPath.section == 0) {
    return kFertilityRowHeight;
  } else {
    UIView *exemplar = self.rowExemplars[indexPath.row];
    return exemplar.frame.size.height;
  }
}

@end
