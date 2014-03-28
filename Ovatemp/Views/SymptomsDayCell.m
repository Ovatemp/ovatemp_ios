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

  if(self.day.mood) {
    self.moodLabel.text = [self.day.mood capitalizedString];
    self.moodImageView.hidden = FALSE;
  } else {
    self.moodImageView.hidden = TRUE;
    self.moodLabel.text = @"Swipe to edit";
  }

  for(DayToggleButton *button in @[self.sadButton, self.worriedButton, self.goodButton, self.amazingButton]) {
    [button refresh];
    if(button.selected) {
      self.moodImageView.image = [button imageForState:UIControlStateNormal];
    }
  }
}

- (void)initializeControls {
  [self.sadButton setImage:[UIImage imageNamed:@"Sad"] forState:UIControlStateNormal];
  [self.worriedButton    setImage:[UIImage imageNamed:@"Worried"] forState:UIControlStateNormal];
  [self.goodButton   setImage:[UIImage imageNamed:@"Good"] forState:UIControlStateNormal];
  [self.amazingButton    setImage:[UIImage imageNamed:@"Amazing"] forState:UIControlStateNormal];

  [self.sadButton setDayCell:self property:@"mood" index:MOOD_SAD];
  [self.worriedButton setDayCell:self property:@"mood" index:MOOD_WORRIED];
  [self.goodButton setDayCell:self property:@"mood" index:MOOD_GOOD];
  [self.amazingButton setDayCell:self property:@"mood" index:MOOD_AMAZING];

  UINib *cellNib = [UINib nibWithNibName:kCheckCellIdentifier bundle:nil];
  UIView *cellView = [[[NSBundle mainBundle] loadNibNamed:kCheckCellIdentifier owner:self options:nil]
                      objectAtIndex:0];

  UITableView *table = self.symptomsTableView;
  table.accessibilityIdentifier = @"Symptoms Options";
  self.page2.accessibilityIdentifier = @"Symptoms Options Page";
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

- (IBAction)createSymptom:(id)sender {
  [self showCreateFormWithTitle:@"Add new symptom" andClass:[Symptom class]];
}


@end