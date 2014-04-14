//
//  DayCellEditView.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/11/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "DayCellEditView.h"

#import "Alert.h"
#import "CheckCell.h"
#import "DayAttribute.h"
#import "DayToggleButton.h"
#import "SharedRelation.h"

static const CGFloat kIconSize = 75.0f;

@interface DayCellEditView () {
  UIButton *_addButton;
  DayAttribute *_attribute;
  NSArray *_choices;
  UILabel *_label;
  NSMutableArray *_selectedChoices;
}

@property (readonly) UIButton *addButton;

@property UITableView *tableView;

@end

@implementation DayCellEditView

# pragma mark - Setup

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = DARK_GREY;
    self.hasLabel = YES;
  }
  return self;
}

- (void)addSubview:(UIView *)view {
  if (self.hasLabel) {
    if (view != _label && view != _addButton && view.frame.origin.y <= CGRectGetMaxY(_label.frame)) {
      CGRect frame = view.frame;
      frame.origin.y = CGRectGetMaxY(_label.frame) + SIBLING_SPACING;
      view.frame = frame;
    }
  }
  [super addSubview:view];
  CGRect myFrame = self.frame;
  myFrame.size.height = MAX(myFrame.size.height, CGRectGetMaxY(view.frame) + SUPERVIEW_SPACING);
  self.frame = myFrame;
}

- (DayAttribute *)attribute {
  return _attribute;
}

- (void)setAttribute:(DayAttribute *)attribute {
  _attribute = attribute;
  if (self.hasLabel) {
    self.label.text = attribute.title;
    [self.label sizeToFit];
  }

  CGRect frame = self.frame;
  
  if (attribute.type == DayAttributeToggle) {
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:attribute.choices.count];
    for (NSInteger i = 0; i < attribute.choices.count; i++) {
      DayToggleButton *button = [self buttonForChoiceAtIndex:i];
      [buttons addObject:button];
      [self addSubview:button];
      frame.size.height = CGRectGetMaxY(button.frame) + SUPERVIEW_SPACING;
    }
    self.buttons = buttons;
  } else if (attribute.type == DayAttributeList) {
    CGRect tableFrame = CGRectMake(SUPERVIEW_SPACING * 2, 0,
                                   frame.size.width - SUPERVIEW_SPACING * 4,
                                   SUPERVIEW_SPACING * 5);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableFrame];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.accessibilityLabel = [attribute.title stringByAppendingString:@" Options"];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    // Align separators left
    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    // Don't show separators after the last item
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Load up the check cell
    UINib *cellNib = [UINib nibWithNibName:kCheckCellIdentifier bundle:nil];
    UIView *cellView = [[[NSBundle mainBundle] loadNibNamed:kCheckCellIdentifier owner:self options:nil]
                        objectAtIndex:0];
    [tableView registerNib:cellNib forCellReuseIdentifier:kCheckCellIdentifier];
    tableView.rowHeight = cellView.frame.size.height;

    [self addSubview:tableView];

    [self.addButton addTarget:self action:@selector(addListItem:) forControlEvents:UIControlEventTouchUpInside];
    [tableView reloadData];
    
    frame.size.height = CGRectGetMaxY(tableView.frame) + SUPERVIEW_SPACING;

    self.tableView = tableView;
  } else {
    frame = [self buildCustomUI:frame];
  }
  self.frame = frame;
}

# pragma mark - UI elements

- (UIButton *)addButton {
  if (!_addButton) {
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addButton setImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
    [_addButton sizeToFit];
    CGRect frame = _addButton.frame;
    frame.origin = CGPointMake(self.frame.size.width - SUPERVIEW_SPACING - frame.size.width,
                               self.label.frame.origin.y + (self.label.frame.size.height - frame.size.height) / 2);
    _addButton.frame = frame;
    [self addSubview:_addButton];
  }
  return _addButton;
}

- (UILabel *)label {
  if (!_label) {
    _label = [[UILabel alloc] init];
    CGRect labelFrame = CGRectMake(SUPERVIEW_SPACING, SUPERVIEW_SPACING, 0, 0);
    _label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f];
    _label.frame = labelFrame;
    _label.textColor = LIGHT;
    [self addSubview:_label];
  }
  return _label;
}

# pragma mark - Button interface

- (DayToggleButton *)buttonForChoiceAtIndex:(NSInteger)index {
  CGFloat offset = SUPERVIEW_SPACING;
  if (self.attribute.choices.count < 3) {
    offset = SUPERVIEW_SPACING * 3;
  }

  CGFloat width = self.frame.size.width - offset * 2;
  CGFloat spacing = width / self.attribute.choices.count;
  
  DayToggleButton *button = [DayToggleButton buttonWithType:UIButtonTypeCustom];
  button.choice = index;

  NSString *choice = self.attribute.choices[index];
  [button setTitle:choice.capitalizedString forState:UIControlStateNormal];

  NSString *imageName = [choice.capitalizedString stringByAppendingString:@".png"];
  UIImage *image = [UIImage imageNamed:imageName];
  [button setImage:image forState:UIControlStateNormal];
  
  button.titleLabel.font = [UIFont systemFontOfSize:11];
  button.titleLabel.textColor = LIGHT;
  
  [button addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
  
  CGFloat left;
  
  if (index == 0) {
    left = offset;
  } else if (index == self.attribute.choices.count - 1) {
    left = width - kIconSize + offset;
  } else {
    left = offset;
    left += spacing * index;
    // Center in the remaining space
    left += (spacing - kIconSize) / 2;
  }
  button.frame = CGRectMake(left, 0, kIconSize, kIconSize);

  return button;
}

- (void)setChoice:(NSInteger)choice {
  for (DayToggleButton *button in self.buttons) {
    button.selected = button.choice == choice;
  }
}

- (void)toggleButton:(DayToggleButton *)button {
  button.selected = !button.selected;
  NSInteger choice;

  if (button.selected) {
    choice = button.choice;

    // Turn off other buttons
    for (DayToggleButton *otherButton in self.buttons) {
      if (button != otherButton) {
        otherButton.selected = NO;
      }
    }
  } else {
    choice = NSNotFound;
  }

  [self.delegate attributeToggled:self.attribute choice:choice];
}

# pragma mark - List interface

- (void)addListItem:(id)sender {
  NSString *title = [NSString stringWithFormat:@"Add new %@", [self.attribute.choiceClass description].lowercaseString];
  __weak Alert *alert = [Alert alertWithTitle:title message:nil];
  alert.alertViewStyle = UIAlertViewStylePlainTextInput;

  [alert addButtonWithTitle:@"Cancel"];
  [alert addButtonWithTitle:@"Save" callback:^{
    NSString *inputText = [alert.view textFieldAtIndex:0].text;
    [self.attribute.choiceClass createWithName:inputText success:^(SharedRelation *newChoice) {
      NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
      _choices = [[self.attribute.choiceClass all] sortedArrayUsingDescriptors:@[sort]];
      [_selectedChoices addObject:newChoice];
      [self.tableView reloadData];
    }];
  }];
  
  [alert show];
}

- (void)setSelectedChoices:(NSMutableArray *)selectedChoices {
  _selectedChoices = selectedChoices;
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
  _choices = [[self.attribute.choiceClass all] sortedArrayUsingDescriptors:@[sort]];
  [self.tableView reloadData];
}

# pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CheckCell *cell = [tableView dequeueReusableCellWithIdentifier:kCheckCellIdentifier];

  SharedRelation *option = _choices[indexPath.row];

  cell.backgroundColor = [UIColor clearColor];
  cell.checkImage.hidden = ![_selectedChoices containsObject:option];
  cell.label.text = option.name;

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  SharedRelation *option = _choices[indexPath.row];
  
  BOOL checked = [_selectedChoices containsObject:option];
  if (checked) {
    [_selectedChoices removeObject:option];
  } else {
    [_selectedChoices addObject:option];
  }

  [self.tableView reloadData];
  [self.delegate attributeSelectionChanged:self.attribute selected:_selectedChoices];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _choices.count;
}

# pragma mark - Custom interfaces

- (CGRect)buildCustomUI:(CGRect)frame {
  return frame;
}

- (void)setValue:(id)value {
  // NOOP for subclasses
}

@end
