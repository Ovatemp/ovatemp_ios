//
//  SymptomsDayCell.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SymptomsDayCell.h"
#import "CheckCell.h"
#import "Symptom.h"

@implementation SymptomsDayCell

static NSString * const kCheckCellIdentifier = @"CheckCell";

- (void)refreshControls {
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];

  self.symptoms = [[Symptom all] sortedArrayUsingDescriptors:@[sort]];
  self.symptomsTextView.text = [[self.day.symptoms valueForKey:@"name"] componentsJoinedByString:@", "];

  [self.symptomsTableView reloadData];
}

- (void)initializeControls {
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
    return self.symptoms.count;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if(tableView == self.symptomsTableView) {
    return [self symptomCellForRow:indexPath.row];
  }

  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Symptom *symptom = self.symptoms[indexPath.row];
  [self.day toggleSymptom:symptom];

  [self refreshControls];
  [tableView reloadData];
}

- (UITableViewCell *)symptomCellForRow:(NSUInteger)row {
  CheckCell *cell = [self.symptomsTableView dequeueReusableCellWithIdentifier:kCheckCellIdentifier];

  Symptom *symptom = self.symptoms[row];

  cell.backgroundColor = [UIColor clearColor];
  cell.checkImage.hidden = ![self.day hasSymptom:symptom];
  cell.label.text = symptom.name;

  return cell;
}

@end