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
    
    cycleLengthPickerData = @[@"26", @"27", @"28", @"29", @"30", @"31", @"32", @"33", @"34", @"35", @"36"];
    
    self.cycleLengthPicker.delegate = self;
    
    // default picker value
    [self.cycleLengthPicker selectRow:2 inComponent:0 animated:NO]; // 28
    
    self.cycleLengthLabel.textColor = [UIColor ovatempGreyColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.cycleLengthValueLabel.text = [NSString stringWithFormat:@"%@ days", [cycleLengthPickerData objectAtIndex:row]];
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
