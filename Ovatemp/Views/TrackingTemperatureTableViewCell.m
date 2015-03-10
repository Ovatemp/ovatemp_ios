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

#import "TrackingViewController.h"

#define SELECTED_DATE [self.delegate getSelectedDate]

@import HealthKit;

@implementation TrackingTemperatureTableViewCell

NSMutableArray *temperatureIntegerPartPickerData;
NSMutableArray *temperatureFractionalPartPickerData;

- (void)awakeFromNib
{
    // Initialization code
    
    temperatureIntegerPartPickerData = [[NSMutableArray alloc] init];
    temperatureFractionalPartPickerData = [[NSMutableArray alloc] init];
    
    // set up picker data source
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"temperatureUnitPreferenceFahrenheit"]) {
        // Celsius 32 41
        for (int i = 32; i < 42; i++) {
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
    
//    self.selectedDate = [[NSDate alloc] init];
    
    // switch
    [self.disturbanceSwitch addTarget: self action: @selector(disturbanceSwitchChanged:) forControlEvents: UIControlEventValueChanged];
    // color
    self.disturbanceSwitch.onTintColor = [UIColor ovatempAquaColor];
}

- (void)prepareForReuse
{
    // Initialization code
    
    temperatureIntegerPartPickerData = [[NSMutableArray alloc] init];
    temperatureFractionalPartPickerData = [[NSMutableArray alloc] init];
    
    // set up picker data source
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"temperatureUnitPreferenceFahrenheit"]) {
        // Celsius 32 41
        for (int i = 32; i < 42; i++) {
            [temperatureIntegerPartPickerData addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        for (int i = 0; i < 100; i++) {
            [temperatureFractionalPartPickerData addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
    } else {
        // Fahrenheit
        for (int i = 90; i < 107; i++) {
            [temperatureIntegerPartPickerData addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        for (int i = 0; i < 100; i++) {
            [temperatureFractionalPartPickerData addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    
    [self.temperaturePicker reloadAllComponents];
}

- (void)disturbanceSwitchChanged:(UISwitch *)disturbanceSwitch
{
    BOOL disturbance = disturbanceSwitch.on;
    [self postAndSaveDisturbanceWithDisturbance:disturbance];
}

- (IBAction)didSelectInfoButton:(id)sender
{
    [self.delegate pushInfoAlertWithTitle:@"Basal Body Temperature" AndMessage:@"Temperature of the body at rest, taken immediately after awakening and before any other activity (i.e. taking a sip of water, going to the bathroom).\n\nWomen have lower basal body temperatures before ovulation, and higher temperatures afterwards." AndURL:@"http://ovatemp.helpshift.com/a/ovatemp/?s=fertility-faqs&f=learn-more-about-basal-body-temperature"];
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2; // one for the integer part, one for fractional part
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    if (component == 0) { // ints
        return [temperatureIntegerPartPickerData count];
        
    } else { // fractional/decimal
        return [temperatureFractionalPartPickerData count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0){
        return [temperatureIntegerPartPickerData objectAtIndex:row];
    }
    else{
        return [temperatureFractionalPartPickerData objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.temperatureValueLabel.text = [NSString stringWithFormat:@"%@.%@", [temperatureIntegerPartPickerData objectAtIndex:[pickerView selectedRowInComponent:0]], [temperatureFractionalPartPickerData objectAtIndex:[pickerView selectedRowInComponent:1]]];
    
    // update temperature on backend
    [self postAndSaveTemperature];
}

- (void)postAndSaveTemperature
{
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
    
    // format date to yyyy-mm-dd
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *stringDateForBackend = [formatter stringFromDate: SELECTED_DATE];
    
    [attributes setObject:stringDateForBackend forKey:@"date"];
    [attributes setObject:[NSNumber numberWithFloat:tempInFahrenheit] forKey:@"temperature"];
    
    [ConnectionManager put:@"/days/"
                    params:@{
                             @"day": attributes,
                             }
                   success:^(NSDictionary *response) {
                       [Cycle cycleFromResponse:response];
                       [Calendar setDate: SELECTED_DATE];
//                       if (onSuccess) onSuccess(response);
                   }
                   failure:^(NSError *error) {
                       [Alert presentError:error];
                   }];
}

- (void)postAndSaveDisturbanceWithDisturbance:(BOOL)disturbance
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject: SELECTED_DATE forKey:@"date"];
    [attributes setObject:[NSNumber numberWithBool:disturbance] forKey:@"disturbance"];
    
    [ConnectionManager put:@"/days/"
                    params:@{
                             @"day": attributes,
                             }
                   success:^(NSDictionary *response) {
                       [Cycle cycleFromResponse:response];
                       [Calendar setDate: SELECTED_DATE];
                       //                       if (onSuccess) onSuccess(response);
                   }
                   failure:^(NSError *error) {
                       [Alert presentError:error];
                   }];
}

# pragma mark - HealthKit

- (void)updateHealthKitWithTemperature:(float)temp
{    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:HKCONNECTION]) {
        if(temp) {
            NSString *identifier = HKQuantityTypeIdentifierBodyTemperature;
            HKQuantityType *tempType = [HKObjectType quantityTypeForIdentifier:identifier];
            
            HKQuantity *myTemp = [HKQuantity quantityWithUnit:[HKUnit degreeFahrenheitUnit]
                                                  doubleValue: temp];
            
            HKQuantitySample *temperatureSample = [HKQuantitySample quantitySampleWithType: tempType
                                                                                  quantity: myTemp
                                                                                 startDate: [self.delegate getSelectedDate]
                                                                                   endDate: [self.delegate getSelectedDate]
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

- (void)setExpanded
{
    self.temperaturePicker.hidden = NO;
    self.temperatureValueLabel.hidden = NO;
    self.placeholderLabel.hidden = YES;
    self.collapsedLabel.hidden = NO;
    
    self.infoButton.hidden = YES;
    self.disturbanceLabel.hidden = NO;
    self.disturbanceSwitch.hidden = NO;
    self.ondoIcon.hidden = YES;
}

- (void)setMinimized
{
    Day *selectedDay = [self.delegate getSelectedDay];

    self.temperaturePicker.hidden = YES;
    
    if (selectedDay.temperature) {
        self.placeholderLabel.hidden = YES;
        self.collapsedLabel.hidden = NO;
        self.temperatureValueLabel.hidden = NO;
        
//        if (self.usedOndo) {
//            self.tempCell.ondoIcon.hidden = NO;
//        } else {
//            self.tempCell.ondoIcon.hidden = YES;
//        }
        
    } else {
        self.placeholderLabel.hidden = NO;
        self.collapsedLabel.hidden = YES;
        self.temperatureValueLabel.hidden = YES;
    }
    
    self.infoButton.hidden = NO;
    self.disturbanceLabel.hidden = YES;
    self.disturbanceSwitch.hidden = YES;
}

@end
