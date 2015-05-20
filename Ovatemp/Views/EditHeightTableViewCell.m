//
//  EditHeightTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 10/24/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "EditHeightTableViewCell.h"
#import "UserProfile.h"
#import "TAOverlay.h"

#import "HealthKitHelper.h"

@implementation EditHeightTableViewCell

NSMutableArray *heightPickerFeetData;
NSMutableArray *heightPickerInchesData;

- (void)awakeFromNib
{
    // Initialization code
    
    heightPickerFeetData = [[NSMutableArray alloc] init];
    heightPickerInchesData = [[NSMutableArray alloc] init];
    
    for (int i = 3; i < 7; i++) {
        [heightPickerFeetData addObject:[NSString stringWithFormat:@"%d'", i]];
    }
    
    for (int i = 0; i < 12; i++) {
        [heightPickerInchesData addObject:[NSString stringWithFormat:@"%d\"", i]];
    }
    
    self.heightPicker = [[UIPickerView alloc] init];
    
    self.heightPicker.delegate = self;
    
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    [doneToolbar sizeToFit];
    UIBarButtonItem *flexArea = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endEditing:)];
    doneToolbar.items = @[flexArea, doneButton];
    self.heightField.inputAccessoryView = doneToolbar;
    
    UserProfile *currentUserProfile = [UserProfile current];
    
    int feetComponent = [currentUserProfile.heightInInches intValue] / 12;
    int inchesComponent = [currentUserProfile.heightInInches intValue] % 12;

    if ((feetComponent >= 3 && feetComponent < 7) && (inchesComponent >= 0 && inchesComponent < 12)) {
        [self.heightPicker selectRow: (feetComponent - 3) inComponent:0 animated:NO];
        [self.heightPicker selectRow: inchesComponent inComponent:1 animated:NO];
    }
    
    self.heightField.inputView = self.heightPicker;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - UIPickerViewDelegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.heightField.alpha = 0.0;
    self.heightField.text = [NSString stringWithFormat:@"%@ %@", [heightPickerFeetData objectAtIndex:[self.heightPicker selectedRowInComponent:0]], [heightPickerInchesData objectAtIndex:[self.heightPicker selectedRowInComponent:1]]];
    
    [UIView animateWithDuration: 0.5 animations:^{
        self.heightField.alpha = 1.0;
    }];
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

#pragma mark - IBAction's

- (IBAction)didSelectHealthKit:(id)sender
{
    HealthKitHelper *healthKit = [HealthKitHelper sharedSession];
    [healthKit getHeightWithCompletion:^(NSNumber *height, NSError *error) {
        if (height) {
            NSInteger feetComponent = [height integerValue] / 12;
            NSInteger inchesComponent = [height integerValue] % 12;
            
            if ((feetComponent >= 3 && feetComponent < 7) && (inchesComponent >= 0 && inchesComponent < 12)) {
                [self.heightPicker selectRow: (feetComponent - 3) inComponent: 0 animated: NO];
                [self pickerView: self.heightPicker didSelectRow: (feetComponent - 3) inComponent: 0];
                
                [self.heightPicker selectRow: inchesComponent inComponent: 1 animated: NO];
                [self pickerView: self.heightPicker didSelectRow: inchesComponent inComponent: 1];
                
                [TAOverlay showOverlayWithLabel: @"Success!" Options: TAOverlayOptionAutoHide | TAOverlayOptionOverlaySizeRoundedRect | TAOverlayOptionOverlayTypeSuccess];
            }
            
        }else{
            DDLogError(@"ERROR: %@", error);
            [TAOverlay showOverlayWithLabel: error.localizedDescription Options: TAOverlayOptionAutoHide | TAOverlayOptionOverlaySizeRoundedRect | TAOverlayOptionOverlayTypeError];

        }
    }];
    
}

@end
