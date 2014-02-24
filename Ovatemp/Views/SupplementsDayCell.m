//
//  SupplementsDayCell.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SupplementsDayCell.h"
#import "Medicine.h"
#import "Supplement.h"

@implementation SupplementsDayCell

static NSString * const kCheckCellIdentifier = @"CheckCell";

- (void)refreshControls {
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];

  self.medicines = [[Medicine all] sortedArrayUsingDescriptors:@[sort]];
  self.supplements = [[Supplement all] sortedArrayUsingDescriptors:@[sort]];

  self.medicinesTextView.text = [[self.day.medicines valueForKey:@"name"] componentsJoinedByString:@", "];
  self.supplementsTextView.text = [[self.day.supplements valueForKey:@"name"] componentsJoinedByString:@", "];

  [self.supplementsTableView reloadData];
  [self.medicinesTableView reloadData];
}

- (void)initializeControls {
  UINib *cellNib = [UINib nibWithNibName:kCheckCellIdentifier bundle:nil];
  UIView *cellView = [[[NSBundle mainBundle] loadNibNamed:kCheckCellIdentifier owner:self options:nil]
          objectAtIndex:0];

  for(UITableView* table in @[self.supplementsTableView, self.medicinesTableView]) {
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
  if(tableView == self.medicinesTableView) {
    return self.medicines.count;
  }
  if(tableView == self.supplementsTableView) {
    return self.supplements.count;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if(tableView == self.medicinesTableView) {
    return [self medicineCellForRow:indexPath.row];
  }
  if(tableView == self.supplementsTableView) {
    return [self supplementCellForRow:indexPath.row];
  }

  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if(tableView == self.medicinesTableView) {
    Medicine *medicine = self.medicines[indexPath.row];
    [self.day toggleMedicine:medicine];
  }
  if(tableView == self.supplementsTableView) {
    Supplement *supplement = self.supplements[indexPath.row];
    [self.day toggleSupplement:supplement];
  }

  [self refreshControls];
}

- (UITableViewCell *)medicineCellForRow:(NSUInteger)row {
  CheckCell *cell = [self.medicinesTableView dequeueReusableCellWithIdentifier:kCheckCellIdentifier];

  Medicine *medicine = self.medicines[row];

  cell.backgroundColor = [UIColor clearColor];
  cell.checkImage.hidden = ![self.day hasMedicine:medicine];
  cell.label.text = medicine.name;

  return cell;
}

- (UITableViewCell *)supplementCellForRow:(NSUInteger)row {
  CheckCell *cell = [self.supplementsTableView dequeueReusableCellWithIdentifier:kCheckCellIdentifier];

  Supplement *supplement = self.supplements[row];

  cell.backgroundColor = [UIColor clearColor];
  cell.checkImage.hidden = ![self.day hasSupplement:supplement];
  cell.label.text = supplement.name;

  return cell;
}

- (IBAction)createSupplement:(id)sender {
  [self showCreateFormWithTitle:@"Add new supplement" andClass:[Supplement class]];
}

- (IBAction)createMedicine:(id)sender {
  [self showCreateFormWithTitle:@"Add new medicine" andClass:[Medicine class]];
}

@end
