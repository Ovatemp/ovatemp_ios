//
//  TrackingTemperatureTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/4/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingTemperatureTableViewCell.h"
#import "DayAttribute.h"
#import "Alert.h"
#import "Cycle.h"
#import "Calendar.h"

@import HealthKit;

@implementation TrackingTemperatureTableViewCell

NSMutableArray *temperatureIntegerPartPickerData;
NSMutableArray *temperatureFractionalPartPickerData;

- (void)awakeFromNib {
    // Initialization code
    
    temperatureIntegerPartPickerData = [[NSMutableArray alloc] init];
    temperatureFractionalPartPickerData = [[NSMutableArray alloc] init];
    
    // set up picker data source
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"temperatureUnitPreferenceFahrenheit"]) {
        // Celsius 32 41
        for (int i = 32; i < 41; i++) {
            [temperatureIntegerPartPickerData addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        for (int i = 0; i < 100; i++) {
            [temperatureFractionalPartPickerData addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        [self.temperaturePicker selectRow:5 inComponent:0 animated:YES];
        [self.temperaturePicker selectRow:0 inComponent:1 animated:YES];
        
        self.temperatureValueLabel.text = @"37.00";
        
    } else {
        // Fahrenheit
        for (int i = 90; i < 107; i++) {
            [temperatureIntegerPartPickerData addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        for (int i = 0; i < 100; i++) {
            [temperatureFractionalPartPickerData addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        [self.temperaturePicker selectRow:8 inComponent:0 animated:YES];
        [self.temperaturePicker selectRow:60 inComponent:1 animated:YES];
        
        self.temperatureValueLabel.text = @"98.60";
    }
    
    
    
    self.temperaturePicker.delegate = self;
    self.temperaturePicker.dataSource = self;
    self.temperaturePicker.showsSelectionIndicator = YES;
    
    self.selectedDate = [[NSDate alloc] init];
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
    self.temperatureValueLabel.text = [NSString stringWithFormat:@"%@.%@", [temperatureIntegerPartPickerData objectAtIndex:[pickerView selectedRowInComponent:0]], [temperatureFractionalPartPickerData objectAtIndex:[pickerView selectedRowInComponent:1]]];
    
    // update temperature on backend
    [self postAndSaveTemperature];
}

- (void)postAndSaveTemperature {
    
    float tempInFahrenheit;
    // if Celsius, convert to Fahrenheit
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"temperatureUnitPreferenceFahrenheit"]) {
        tempInFahrenheit = (([self.temperatureValueLabel.text floatValue] * 1.8000f) + 32);
    } else {
        tempInFahrenheit = [self.temperatureValueLabel.text floatValue];
    }
    
    // first save to HealthKit
    [self updateHealthKitWithTemperature:tempInFahrenheit];
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:self.selectedDate forKey:@"date"];
    [attributes setObject:[NSNumber numberWithFloat:tempInFahrenheit] forKey:@"temperature"];
    
    [ConnectionManager put:@"/days/"
                    params:@{
                             @"day": attributes,
                             }
                   success:^(NSDictionary *response) {
                       [Cycle cycleFromResponse:response];
                       [Calendar setDate:self.selectedDate];
//                       if (onSuccess) onSuccess(response);
                   }
                   failure:^(NSError *error) {
                       [Alert presentError:error];
                   }];
}

# pragma mark - HealthKit

- (void)updateHealthKitWithTemperature:(float)temp {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:HKCONNECTION]) {
        if(temp) {
            NSString *identifier = HKQuantityTypeIdentifierBodyTemperature;
            HKQuantityType *tempType = [HKObjectType quantityTypeForIdentifier:identifier];
            
            HKQuantity *myTemp = [HKQuantity quantityWithUnit:[HKUnit degreeFahrenheitUnit]
                                                  doubleValue: temp];
            
            HKQuantitySample *temperatureSample = [HKQuantitySample quantitySampleWithType: tempType
                                                                                  quantity: myTemp
                                                                                 startDate: self.selectedDate
                                                                                   endDate: self.selectedDate
                                                                                  metadata: nil];
            HKHealthStore *healthStore = [[HKHealthStore alloc] init];
            [healthStore saveObject: temperatureSample withCompletion:^(BOOL success, NSError *error) {
                NSLog(@"I saved to healthkit");
            }];
        }
    }
    else {
        NSLog(@"Could not save to healthkit. No connection could be made");
    }
}

@end
