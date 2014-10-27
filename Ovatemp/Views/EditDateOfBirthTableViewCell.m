//
//  EditDateOfBirthTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 10/24/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "EditDateOfBirthTableViewCell.h"

#import "User.h"

@implementation EditDateOfBirthTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.dateOfBirthPicker = [[UIDatePicker alloc] init];
    self.dateOfBirthPicker.date = [[UserProfile current] dateOfBirth]; // default date
    
    NSInteger minAgeInYears = 12;
    NSInteger day = 60 * 60 * 24;
    NSInteger year = day * 365;
    NSDate *maximumDate = [NSDate dateWithTimeIntervalSinceNow:-minAgeInYears * year];
    NSDate *minimumDate = [NSDate dateWithTimeIntervalSinceNow:-100 * year];
    
    self.dateOfBirthPicker.minimumDate = minimumDate;
    self.dateOfBirthPicker.maximumDate = maximumDate;
    
    self.dateOfBirthPicker.datePickerMode = UIDatePickerModeDate;
    
    [self.dateOfBirthPicker addTarget:self
                               action:@selector(dateOfBirthChanged:)
                     forControlEvents:UIControlEventValueChanged];
    
    // done bar
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    [doneToolbar sizeToFit];
    UIBarButtonItem *flexArea = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endEditing:)];
    doneToolbar.items = @[flexArea, doneButton];
    self.textField.inputAccessoryView = doneToolbar;
    
    self.textField.inputView = self.dateOfBirthPicker;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dateOfBirthChanged:(UIDatePicker *)sender {
    //    self.dobCell.textField.text = [self.dateOfBirthPicker.date classicDate];
    [self.textField setText:[self.dateOfBirthPicker.date classicDate]];
}

@end
