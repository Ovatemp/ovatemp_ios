//
//  HeightTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 10/23/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "HeightTableViewCell.h"

@implementation HeightTableViewCell

NSMutableArray *heightPickerFeetData;
NSMutableArray *heightPickerInchesData;

- (void)awakeFromNib {
    // Initialization code
    
    heightPickerFeetData = [[NSMutableArray alloc] init];
    heightPickerInchesData = [[NSMutableArray alloc] init];
    
    for (int i = 3; i < 7; i++) {
        [heightPickerFeetData addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    for (int i = 1; i < 12; i++) {
        [heightPickerInchesData addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    self.heightPicker.delegate = self;
    
    // default value
    [self.heightPicker selectRow:2 inComponent:0 animated:NO]; // 5'
    [self.heightPicker selectRow:4 inComponent:1 animated:NO]; // 5"
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIPickerViewDelegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.heightValueLabel.text = [NSString stringWithFormat:@"%@' %@\"", [heightPickerFeetData objectAtIndex:[self.heightPicker selectedRowInComponent:0]], [heightPickerInchesData objectAtIndex:[self.heightPicker selectedRowInComponent:1]]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) { // Numbers
        return [heightPickerFeetData count];
        
    } else { // Units of Time
        return [heightPickerInchesData count];
    }
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
        return [heightPickerFeetData objectAtIndex:row];
    }
    else
    {
        return [heightPickerInchesData objectAtIndex:row];
    }
}


@end
