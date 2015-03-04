//
//  Welcome2ViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/20/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Welcome2ViewController.h"

#import "User.h"

@interface Welcome2ViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation Welcome2ViewController

NSArray *weeksArray;
NSArray *monthsArray;
NSArray *yearsArray;

NSArray *singularUnitsOfTimeArray;
NSArray *unitsOfTimeArray;

NSDate *startedTryingDate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeAppearance];
    
    self.tryingToConceivePicker.delegate = self;
    
    weeksArray = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", nil];
    
    monthsArray = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", nil];
    
    yearsArray = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
    
    singularUnitsOfTimeArray = [[NSArray alloc] initWithObjects:@"week", @"month", @"year", nil];
    
    unitsOfTimeArray = [[NSArray alloc] initWithObjects:@"weeks", @"months", @"years", nil];
    
    // set default picker value to 6 weeks
    [self.tryingToConceivePicker selectRow:5 inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Appearance

- (void)customizeAppearance
{
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject: [UIColor ovatempDarkGreyTitleColor]
                                                                                              forKey: NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor ovatempAquaColor];
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
    
    // convert start trying date to NSDate
    // 0 - week
    // 1 - month
    // 2 - year
    
    NSCalendar *startedTryingCalendar = [NSCalendar currentCalendar];
    NSDateComponents *startedTryingComponenets = [[NSDateComponents alloc] init];
    
    switch (timeComponent) {
        case 0: // week
            startedTryingComponenets.weekOfYear = -([pickerView selectedRowInComponent:0] + 1);
            break;
        
        case 1: // month
            startedTryingComponenets.month = -([pickerView selectedRowInComponent:0] + 1);
        
        case 2: // year
            startedTryingComponenets.year= -([pickerView selectedRowInComponent:0] + 1);
            
        default:
            break;
    }
    
    startedTryingDate = [startedTryingCalendar dateByAddingComponents:startedTryingComponenets toDate:[NSDate date] options:0];
}

- (IBAction)doNextScreen:(id)sender {
    
    // save date to NSUserDefaults
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:startedTryingDate forKey:@"startedTryingDate"];
//    [defaults synchronize];
    
    // save to user profile
    UserProfile *currentUserProfile = [UserProfile current];
    currentUserProfile.startedTryingOn = startedTryingDate;
    [currentUserProfile save];
    
    [self performSegueWithIdentifier:@"welcome2ToWelcome3" sender:self];
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
