//
//  WeightTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 10/23/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "WeightTableViewCell.h"

@implementation WeightTableViewCell

NSMutableArray *weightPickerData;

- (void)awakeFromNib {
    // Initialization code
    
    weightPickerData = [[NSMutableArray alloc] init];
    
    for (int i = 100; i < 1000; i++) {
        [weightPickerData addObject:[NSString stringWithFormat:@"%d lbs", i]];
    }
    
    self.weightPicker.delegate = self;
    
    [self.weightPicker selectRow:30 inComponent:0 animated:NO];
    
    self.weightLabel.textColor = [UIColor ovatempGreyColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIPickerViewDelegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.weightValueLabel.text = [NSString stringWithFormat:@"%@", [weightPickerData objectAtIndex:[self.weightPicker selectedRowInComponent:0]]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [weightPickerData count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [weightPickerData objectAtIndex:row];
}

@end
