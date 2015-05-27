//
//  EditWeightTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 10/24/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "EditWeightTableViewCell.h"

#import "TAOverlay.h"

#import "UserProfile.h"
#import "HealthKitHelper.h"

@implementation EditWeightTableViewCell

NSMutableArray *weightPickerData;

- (void)awakeFromNib {
    // Initialization code
    
    weightPickerData = [[NSMutableArray alloc] init];
    
    for (int i = 100; i < 1000; i++) {
        [weightPickerData addObject:[NSString stringWithFormat:@"%d lbs", i]];
    }
    
    self.weightPicker = [[UIPickerView alloc] init];
    
    self.weightPicker.delegate = self;
    
    // default row value is weight - 100
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UserProfile *currentUserProfile = [UserProfile current];
    
    if (currentUserProfile.weightInPounds) {
        [self.weightPicker selectRow:([currentUserProfile.weightInPounds intValue] - 100) inComponent:0 animated:NO];
    } else {
        [self.weightPicker selectRow:30 inComponent:0 animated:NO];
    }
    
    // done bar
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    [doneToolbar sizeToFit];
    UIBarButtonItem *flexArea = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endEditing:)];
    doneToolbar.items = @[flexArea, doneButton];
    self.weightField.inputAccessoryView = doneToolbar;
    
    self.weightField.inputView = self.weightPicker;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIPickerViewDelegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.weightField.alpha = 0.0;
    self.weightField.text = [NSString stringWithFormat:@"%@", [weightPickerData objectAtIndex:[self.weightPicker selectedRowInComponent:0]]];

    [UIView animateWithDuration: 0.5 animations:^{
        self.weightField.alpha = 1.0;
    }];
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

#pragma mark - IBAction's

- (IBAction)didSelectHealthKit:(id)sender
{
    [TAOverlay showOverlayWithLabel: @"Loading..." Options: TAOverlayOptionOverlaySizeRoundedRect];
    
    HealthKitHelper *healthKit = [HealthKitHelper sharedSession];
    [healthKit getWeightWithCompletion:^(NSNumber *weight, NSError *error) {
        if (weight) {
            NSInteger row = [weight integerValue] - 100;
            [self.weightPicker selectRow: row inComponent: 0 animated: NO];
            [self pickerView: self.weightPicker didSelectRow: row inComponent: 0];
            [TAOverlay showOverlayWithLabel: @"Success!" Options: TAOverlayOptionAutoHide | TAOverlayOptionOverlaySizeRoundedRect | TAOverlayOptionOverlayTypeSuccess];
        }else{
            DDLogError(@"ERROR: %@", error);
            [TAOverlay showOverlayWithLabel: error.localizedDescription Options: TAOverlayOptionAutoHide | TAOverlayOptionOverlaySizeRoundedRect | TAOverlayOptionOverlayTypeError];
        }
    }];
    
}

@end
