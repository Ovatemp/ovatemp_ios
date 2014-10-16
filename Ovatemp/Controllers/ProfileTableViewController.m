//
//  ProfileTableViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/16/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "Form.h"
#import "User.h"
#import "AccountTableViewCell.h"

@interface ProfileTableViewController ()

@property Form *form;

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Profile";
    
    self.form = [Form withViewController:self];
    self.form.representedObject = [UserProfile current];
    self.form.onChange = ^(Form *form, FormRow *row, id value) {
        [[UserProfile current] save];
    };
    
    // Set up radio buttons
    FormRow *conceive = [self.form addKeyPath:@"tryingToConceive"
                                    withLabel:@"Trying to Conceive"
                                     andImage:@"MoreTryingToConceive.png"
                                    toSection:@"Goal"];
    FormRow *avoid = [self.form addKeyPath:@"tryingToConceive"
                                 withLabel:@"Trying to Avoid"
                                  andImage:@"MoreTryingToAvoid.png"
                                 toSection:@"Goal"];
    avoid.valueTransformer = [NSValueTransformer valueTransformerForName:NSNegateBooleanTransformerName];
    
    conceive.onChange = ^ (FormRow *row, id value) {
        UISwitch *avoidSwitch = (UISwitch *)avoid.control;
        UISwitch *conceiveSwitch = (UISwitch *)row.control;
        [avoidSwitch setOn:!conceiveSwitch.on animated:YES];
    };
    
    avoid.onChange = ^ (FormRow *row, id value) {
        UISwitch *avoidSwitch = (UISwitch *)row.control;
        UISwitch *conceiveSwitch = (UISwitch *)conceive.control;
        [conceiveSwitch setOn:!avoidSwitch.on animated:YES];
    };
    
    // name and birthday
    // If fullName is nil, initialize the form with a dummy name.
    if (![UserProfile current].fullName || [[UserProfile current].fullName length] == 0) {
        [UserProfile current].fullName = @"Jane Doe";
    }
    // dateOfBirth cannot be nil.  If for some reason it is nil, set the birthday to 12 years ago today (youngest age to use app).
    if (![UserProfile current].dateOfBirth) {
        NSDate *today = [[NSDate alloc] init];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents *addComponents = [[NSDateComponents alloc] init];
        addComponents.year = -12;
        
        
        [UserProfile current].dateOfBirth = [calendar dateByAddingComponents:addComponents toDate:today options:0];
    }
    self.form.representedObject = [UserProfile current];
    self.form.onChange = ^(Form *form, FormRow *row, id value) {
        [[UserProfile current] save];
    };
    
    [self.form addKeyPath:@"fullName" withLabel:@"Full Name" toSection:@"Profile Settings"];
    
    NSInteger minAgeInYears = 12;
    NSInteger day = 60 * 60 * 24;
    NSInteger year = day * 365;
    NSDate *maximumDate = [NSDate dateWithTimeIntervalSinceNow:-minAgeInYears * year];
    NSDate *minimumDate = [NSDate dateWithTimeIntervalSinceNow:-50 * year];
    
    FormRow *birthDate = [self.form addKeyPath:@"dateOfBirth"
                                     withLabel:@"Date of Birth"
                                  // andImage:@"MoreBirthday.png"
                                     andImage:nil
                                     toSection:@"Profile Settings"];
    birthDate.datePicker.datePickerMode = UIDatePickerModeDate;
    birthDate.datePicker.minimumDate = minimumDate;
    birthDate.datePicker.maximumDate = maximumDate;
    
    // email
    [self.form addKeyPath:@"email" withLabel:@"Email" andImage:nil toSection:@"Profile Settings"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
