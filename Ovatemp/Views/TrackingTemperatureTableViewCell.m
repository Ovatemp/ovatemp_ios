//
//  TrackingTemperatureTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/4/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingTemperatureTableViewCell.h"

@implementation TrackingTemperatureTableViewCell

NSMutableArray *temperatureIntegerPartPickerData;
NSMutableArray *temperatureFractionalPartPickerData;

- (void)awakeFromNib {
    // Initialization code
    
    temperatureIntegerPartPickerData = [[NSMutableArray alloc] init];
    temperatureFractionalPartPickerData = [[NSMutableArray alloc] init];
    
    // set up picker data source
    for (int i = 90; i < 107; i++) {
        [temperatureIntegerPartPickerData addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    for (int i = 0; i < 100; i++) {
        [temperatureFractionalPartPickerData addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    self.temperaturePicker.delegate = self;
    self.temperaturePicker.dataSource = self;
    self.temperaturePicker.showsSelectionIndicator = YES;
    
//    [self.temperaturePicker selectRow:4 inComponent:0 animated:YES];
//    [self.temperaturePicker selectRow:60 inComponent:1 animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2; // one for the integer part, one for fractional part
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    
    if (component == 0) { // ints
        return [temperatureIntegerPartPickerData count];
        
    } else { // fractional/decimal
        return [temperatureFractionalPartPickerData count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
        return [temperatureIntegerPartPickerData objectAtIndex:row];
    }
    else
    {
        return [temperatureFractionalPartPickerData objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *temperatureUnit;
    
    if ([defaults boolForKey:@"temperatureUnitPreferenceFahrenheit"]) {
        // fahrenheit
        temperatureUnit = @"F";
    } else {
        // celsius
        temperatureUnit = @"C";
    }
    
    self.temperatureValueLabel.text = [NSString stringWithFormat:@"%@.%@º%@", [temperatureIntegerPartPickerData objectAtIndex:[pickerView selectedRowInComponent:0]], [temperatureFractionalPartPickerData objectAtIndex:[pickerView selectedRowInComponent:1]], temperatureUnit];
}

@end
