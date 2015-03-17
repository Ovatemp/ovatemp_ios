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

@interface TrackingTemperatureTableViewCell ()

@property (nonatomic) NSNumber *selectedTemperature;

@end

@implementation TrackingTemperatureTableViewCell

NSMutableArray *temperatureIntegerPartPickerData;
NSMutableArray *temperatureFractionalPartPickerData;

- (void)awakeFromNib
{
    // Initialization code
    
    temperatureIntegerPartPickerData = [[NSMutableArray alloc] init];
    temperatureFractionalPartPickerData = [[NSMutableArray alloc] init];
    
    // Set up picker data source
    
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
    
    self.disturbanceSwitch.onTintColor = [UIColor ovatempAquaColor];
    [self.disturbanceSwitch addTarget: self action: @selector(disturbanceSwitchChanged:) forControlEvents: UIControlEventValueChanged];
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

#pragma mark - IBAction's

- (IBAction)didSelectInfoButton:(id)sender
{
    [self.delegate pushInfoAlertWithTitle:@"Basal Body Temperature" AndMessage:@"Temperature of the body at rest, taken immediately after awakening and before any other activity (i.e. taking a sip of water, going to the bathroom).\n\nWomen have lower basal body temperatures before ovulation, and higher temperatures afterwards." AndURL:@"http://ovatemp.helpshift.com/a/ovatemp/?s=fertility-faqs&f=learn-more-about-basal-body-temperature"];
}

- (void)disturbanceSwitchChanged:(UISwitch *)disturbanceSwitch
{
    BOOL disturbance = disturbanceSwitch.on;
    
    [self postAndSaveDisturbanceWithDisturbance:disturbance];
}

#pragma mark - UIPickerView Data Source

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
    NSString *tempInteger = [temperatureIntegerPartPickerData objectAtIndex: [pickerView selectedRowInComponent: 0]];
    NSString *tempFractional = [temperatureFractionalPartPickerData objectAtIndex: [pickerView selectedRowInComponent: 1]];
    NSString *temperatureString = [NSString stringWithFormat: @"%@.%@", tempInteger, tempFractional];
    
    self.temperatureValueLabel.text = temperatureString;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.selectedTemperature = [formatter numberFromString: temperatureString];
    
    if ([self.delegate respondsToSelector: @selector(didSelectTemperature:)]) {
        [self.delegate didSelectTemperature: self.selectedTemperature];
    }
}

#pragma mark - Network

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

#pragma mark - Appearance

- (void)updateCell
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL tempPrefFahrenheit = [defaults boolForKey:@"temperatureUnitPreferenceFahrenheit"];
    Day *selectedDay = [self.delegate getSelectedDay];
    
    if (selectedDay.temperature){
        
        if (tempPrefFahrenheit){
            self.temperatureValueLabel.text = [NSString stringWithFormat:@"%.2f", [selectedDay.temperature floatValue]];
        } else {
            float tempInCelsius = (([selectedDay.temperature floatValue] - 32) / 1.8000f);
            selectedDay.temperature = [NSNumber numberWithFloat:tempInCelsius];
            self.temperatureValueLabel.text = [NSString stringWithFormat:@"%.2f", tempInCelsius];
        }
        
        if (selectedDay.usedOndo) {
            self.ondoIcon.alpha = 1.0;
        } else {
            self.ondoIcon.alpha = 0.0;
        }
        
    }else{
        
        self.placeholderLabel.alpha = 1.0;
        self.temperatureValueLabel.alpha = 0.0;
        self.collapsedLabel.alpha = 0.0;
        
        if (tempPrefFahrenheit) {
            self.temperatureValueLabel.text = @"98.60";
        } else {
            self.temperatureValueLabel.text = @"37.00";
        }
        
    }
    
    if (selectedDay.disturbance) {
        [self.disturbanceSwitch setOn: YES];
    } else {
        [self.disturbanceSwitch setOn: NO];
    }
    
    [self setPickerSelection];
}

- (void)setPickerSelection
{
    NSArray *tempChunks = [self.temperatureValueLabel.text componentsSeparatedByString: @"."];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int componentZeroSelection;
    int componenetOneSelection;
    
    if ([defaults boolForKey:@"temperatureUnitPreferenceFahrenheit"]) {
        componentZeroSelection = [tempChunks[0] intValue];
        componentZeroSelection -= 90;
        componenetOneSelection = [tempChunks[1] intValue];
        
        if (componenetOneSelection < 0) {
            componenetOneSelection = 60;
        }
        
        if (componentZeroSelection < 0) {
            componentZeroSelection = 8;
        }
        
        [self.temperaturePicker selectRow:componentZeroSelection inComponent:0 animated:NO];
        [self.temperaturePicker selectRow:componenetOneSelection inComponent:1 animated:NO];
    } else {
        componentZeroSelection = [tempChunks[0] intValue];
        componentZeroSelection -= 32;
        
        componenetOneSelection = [tempChunks[1] intValue];
        
        if (componenetOneSelection < 0) {
            componenetOneSelection = 5;
        }
        
        if (componentZeroSelection < 0) {
            componentZeroSelection = 0;
        }
        
        [self.temperaturePicker selectRow:componentZeroSelection inComponent:0 animated:NO];
        [self.temperaturePicker selectRow:componenetOneSelection inComponent:1 animated:NO];
    }
}

- (void)setMinimized
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    self.infoButton.alpha = 1.0;
    self.disturbanceLabel.alpha = 0.0;
    self.disturbanceSwitch.alpha = 0.0;
    self.temperaturePicker.alpha = 0.0;
    
    if (selectedDay.usedOndo) {
        self.ondoIcon.alpha = 1.0;
    } else {
        self.ondoIcon.alpha = 0.0;
    }
    
    if (selectedDay.temperature) {
        // Minimized Cell, With Data
        self.placeholderLabel.alpha = 0.0;
        self.collapsedLabel.alpha = 1.0;
        self.temperatureValueLabel.alpha = 1.0;
        
        if ([self.delegate usedOndo]) {
            self.ondoIcon.alpha = 1.0;
        } else {
            self.ondoIcon.alpha = 0.0;
        }
        
    } else {
        // Minimized Cell, Without Data
        self.placeholderLabel.alpha = 1.0;
        self.collapsedLabel.alpha = 0.0;
        self.temperatureValueLabel.alpha = 0.0;
    }
}

- (void)setExpanded
{
    self.infoButton.alpha = 0.0;
    self.disturbanceLabel.alpha = 1.0;
    self.disturbanceSwitch.alpha = 1.0;
    self.temperaturePicker.alpha = 1.0;
    
    self.placeholderLabel.alpha = 0.0;
    self.collapsedLabel.alpha = 1.0;
    self.temperatureValueLabel.alpha = 1.0;
    
    self.ondoIcon.alpha = 0.0;
}

@end
