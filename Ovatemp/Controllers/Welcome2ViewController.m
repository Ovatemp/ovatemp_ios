//
//  Welcome2ViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/20/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Welcome2ViewController.h"

@interface Welcome2ViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation Welcome2ViewController

NSArray *weeksArray;
NSArray *monthsArray;
NSArray *yearsArray;

NSArray *singularUnitsOfTimeArray;
NSArray *unitsOfTimeArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tryingToConceivePicker.delegate = self;
    
    weeksArray = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", nil];
    
    monthsArray = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", nil];
    
    yearsArray = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
    
    singularUnitsOfTimeArray = [[NSArray alloc] initWithObjects:@"week", @"month", @"year", nil];
    
    unitsOfTimeArray = [[NSArray alloc] initWithObjects:@"weeks", @"months", @"years", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2; // one for numbers, one for unit of time
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    
    if (component == 0) { // Numbers
        return [monthsArray count];
        
    } else { // Units of Time
        return [unitsOfTimeArray count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
        return [monthsArray objectAtIndex:row];
    }
    else
    {
        return [unitsOfTimeArray objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    NSLog(@"Selected Row %ld", (long)row);
    
    unsigned long timeComponent = [pickerView selectedRowInComponent:1];
    
    NSString *timeComponentAsString;
    
    if ([pickerView selectedRowInComponent:0] == 0) {
        timeComponentAsString = [singularUnitsOfTimeArray objectAtIndex:timeComponent];
    } else {
        timeComponentAsString = [unitsOfTimeArray objectAtIndex:timeComponent];
    }
    
    self.timeAgoLabel.text = [NSString stringWithFormat:@"%ld %@ ago", (long)[pickerView selectedRowInComponent:0] + 1, timeComponentAsString];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
