//
//  CycleLengthTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 10/22/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "CycleLengthTableViewCell.h"

@implementation CycleLengthTableViewCell

NSArray *cycleLengthPickerData;

- (void)awakeFromNib {
    // Initialization code
    
    cycleLengthPickerData = @[@"26", @"27", @"28", @"29", @"30"];
    
    self.cycleLengthPicker.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.cycleLengthValueLabel.text = [cycleLengthPickerData objectAtIndex:row];
}

#pragma mark - UIPickerViewDelegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [cycleLengthPickerData count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [cycleLengthPickerData objectAtIndex:row];
}

@end
