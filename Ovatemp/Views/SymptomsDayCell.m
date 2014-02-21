//
//  SymptomsDayCell.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SymptomsDayCell.h"
#import "CheckCell.h"

@implementation SymptomsDayCell

static NSString * const kCheckCellIdentifier = @"CheckCell";

- (void)refreshControls {
  NSLog(@"refreshControls not implemented for: %@", [self class]);

  self.symptomsTextView.text = [self.day.symptoms componentsJoinedByString:@", "];

  [self.symptomsTableView reloadData];
}

- (void)initializeControls {
  NSLog(@"initializeControls not implemented for %@", [self class]);

  UINib *cellNib = [UINib nibWithNibName:kCheckCellIdentifier bundle:nil];
  UIView *cellView = [[[NSBundle mainBundle] loadNibNamed:kCheckCellIdentifier owner:self options:nil]
                      objectAtIndex:0];

  for(UITableView* table in @[self.symptomsTableView]) {
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor clearColor];

    // Align separators left
    table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

    // Don't show separators after the last item
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [table registerNib:cellNib forCellReuseIdentifier:kCheckCellIdentifier];
    table.rowHeight = cellView.frame.size.height;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if(tableView == self.symptomsTableView) {
    return self.day.symptoms.count;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if(tableView == self.symptomsTableView) {
    return [self medicineCellForRow:indexPath.row];
  }

  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"selected table view row: %@", [NSString stringWithFormat:@"%d-%d",indexPath.section,indexPath.row]);
}

- (UITableViewCell *)medicineCellForRow:(NSUInteger)row {
  CheckCell *cell = [self.symptomsTableView dequeueReusableCellWithIdentifier:kCheckCellIdentifier];

  NSString *medicine = self.day.symptoms[row];

  cell.backgroundColor = [UIColor clearColor];
  cell.checkImage.hidden = TRUE;
  cell.label.text = medicine;

  return cell;
}

@end