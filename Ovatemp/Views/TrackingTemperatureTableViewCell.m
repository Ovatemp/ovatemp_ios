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
    
    [self setUpActivityView];
    
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

- (void)setUpActivityView
{
    self.activityView.hidden = YES;
    self.activityView.hidesWhenStopped = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(startActivity)
                                                 name: @"temp_start_activity"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(stopActivity)
                                                 name: @"temp_stop_activity"
                                               object: nil];
}

- (void)startActivity
{
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
}

- (void)stopActivity
{
    [self.activityView stopAnimating];
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
    
    if ([self.delegate respondsToSelector: @selector(didSelectDisturbance:)]) {
        [self.delegate didSelectDisturbance: disturbance];
    }
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

#pragma mark - Appearance

- (void)updateCell
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL tempPrefFahrenheit = [defaults boolForKey: @"temperatureUnitPreferenceFahrenheit"];
    Day *selectedDay = [self.delegate getSelectedDay];
    
    self.ondoIcon.alpha = 0.0f;
    
    if (selectedDay.temperature){
        
        if (tempPrefFahrenheit){
            self.temperatureValueLabel.text = [NSString stringWithFormat:@"%.2f F", [selectedDay.temperature floatValue]];
        } else {
            float tempInCelsius = (([selectedDay.temperature floatValue] - 32) / 1.8000f);
            self.temperatureValueLabel.text = [NSString stringWithFormat:@"%.2f C", tempInCelsius];
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
            self.temperatureValueLabel.text = @"98.60 F";
        } else {
            self.temperatureValueLabel.text = @"37.00 C";
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

    if (selectedDay.temperature) {
        // Minimized Cell, With Data
        self.placeholderLabel.alpha = 0.0;
        self.collapsedLabel.alpha = 1.0;
        self.temperatureValueLabel.alpha = 1.0;
        
        if (selectedDay.usedOndo) {
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
    Day *selectedDay = [self.delegate getSelectedDay];
    
    if (selectedDay.usedOndo) {
        self.ondoIcon.alpha = 1.0;
    } else {
        self.ondoIcon.alpha = 0.0;
    }
    
    self.infoButton.alpha = 0.0;
    self.disturbanceLabel.alpha = 1.0;
    self.disturbanceSwitch.alpha = 1.0;
    self.temperaturePicker.alpha = 1.0;
    
    self.placeholderLabel.alpha = 0.0;
    self.collapsedLabel.alpha = 1.0;
    self.temperatureValueLabel.alpha = 1.0;
    
}

@end
