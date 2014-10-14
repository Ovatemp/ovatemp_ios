//
//  FormRow.m
//  Ovatemp
//
//  Created by Flip Sasser on 9/3/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "FormRow.h"

#import "Form.h"

@interface FormRow () {
  UIDatePicker *_datePicker;
  UIImage *_image;
  id _oldValue;
}

@property (readonly) NSString *dateString;
@property (nonatomic, weak) id representedObject;

@end

@implementation FormRow

# pragma mark - Setup and teardown

+ (FormRow *)rowWithKeyPath:(NSString *)keyPath label:(NSString *)label imageName:(NSString *)image type:(NSString *)type {
  FormRow *row = [self new];
  row.keyPath = keyPath;
  row.label = label;
  row.imageName = image;
  row.type = type;
  return row;
}

- (UIImage *)image {
  if (!_image && self.imageName) {
    _image = [UIImage imageNamed:self.imageName];
  }
  return _image;
}

# pragma mark - Handling interface interfactions

- (void)becomeFirstResponder {
  [self.control becomeFirstResponder];
}

- (void)resignFirstResponder {
  [self.control resignFirstResponder];
}

# pragma mark - Getting and setting values

- (void)setValueWith:(id)newValue {
  newValue = [self valueWith:newValue];
  [self.representedObject setValue:newValue forKeyPath:self.keyPath];
}

- (id)value {
  return [self valueWith:[self.representedObject valueForKeyPath:self.keyPath]];
}

- (void)valueChanged {
  _oldValue = nil;

  if (self.onChange) {
    self.onChange(self, self.value);
  }

  if (self.form.onChange) {
    self.form.onChange(self.form, self, self.value);
  }
}

- (id)valueWith:(id)value {
  if (self.valueTransformer) {
    value = [self.valueTransformer transformedValue:value];
  }
  return value;
}

- (void)dateFieldChanged:(UIDatePicker *)datePicker {
  [self setValueWith:datePicker.date];

  UITextField *textField = (UITextField *)self.control;
  textField.text = self.dateString;
}

- (void)switchChanged:(UISwitch *)aSwitch {
  [self setValueWith:@(aSwitch.on)];
}

- (void)textFieldChanged:(UITextField *)textField {
  [self setValueWith:textField.text];
}

# pragma mark - Building controls

- (UITableViewCell *)buildCellForObject:(id)object inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID;
  if (self.type) {
    cellID = [NSString stringWithFormat:@"%@Cell", self.type];
  } else {
    cellID = @"BasicCell";
  }

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }

  if (self.type && self.keyPath) {
    UIView *control = [self buildControlForObject:object];
//    control.inputAccessoryView = self.form.toolbar;
    control.tag = indexPath.row;
    cell.accessoryView = control;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  } else if (self.onSelect) {
    cell.accessoryType = self.accessoryType;
  }
  cell.textLabel.text = self.label;
  cell.imageView.image = self.image;

  return cell;
}

- (UIControl *)buildControlForObject:(id)object {
  self.representedObject = object;

  if (!self.control) {
    if ([self.type isEqualToString:@"NSString"]) {
      self.control = [self buildTextField];
    } else if ([self.type isEqualToString:@"NSDate"]) {
      self.control = [self buildDateField];
    } else if ([self.type isEqualToString:@"BOOL"]) {
      self.control = [self buildSwitch];
    } else {
      NSLog(@"Cannot build control for %@", self.type);
    }

    if ([self.control isKindOfClass:[UITextField class]]) {
      UITextField *textField = (UITextField *)self.control;
      textField.delegate = self;
      textField.inputAccessoryView = self.form.toolbar;
    }

    [self.control addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
  }

  return self.control;
}

- (UITextField *)buildDateField {
  UITextField *textField = [UITextField new];
  textField.text = self.dateString;
  [textField sizeToFit];
  textField.inputView = self.datePicker;
  // date cannot be nil, if for some reason it is nil, set the birthday to 13 years ago today (possible youngest age to use app)
    if (self.value) {
        self.datePicker.date = self.value;
    } else {
        NSDate *today = [[NSDate alloc] init];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents *addComponents = [[NSDateComponents alloc] init];
        addComponents.year = -13;
        
        self.datePicker.date = [calendar dateByAddingComponents:addComponents toDate:today options:0];
    }
    
  
  return textField;
}

- (UISwitch *)buildSwitch {
  UISwitch *aSwitch = [UISwitch new];
  aSwitch.on = [self.value boolValue];
  [aSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
  return aSwitch;
}

- (UITextField *)buildTextField {
  UITextField *textField = [UITextField new];
  textField.text = self.value;
  [textField sizeToFit];
  [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingDidEnd | UIControlEventEditingDidEndOnExit];
  return textField;
}

# pragma mark - Date helpers

- (UIDatePicker *)datePicker {
  if (!_datePicker) {
    _datePicker = [[UIDatePicker alloc] init];
    [_datePicker addTarget:self action:@selector(dateFieldChanged:) forControlEvents:UIControlEventValueChanged];
  }
  return _datePicker;
}

- (NSString *)dateString {
  NSDateFormatter *dateFormatter;
  if (self.dateFormat) {
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = self.dateFormat;
  } else {
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
  }
  return [dateFormatter stringFromDate:self.value];
}

# pragma mark - Text field delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  _oldValue = self.value;
  self.form.currentRow = self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  if (_oldValue && ![_oldValue isEqual:self.value]) {
    [self valueChanged];
  }
  _oldValue = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self resignFirstResponder];
  return NO;
}

@end
