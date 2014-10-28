//
//  SignUpViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/17/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SignUpViewController.h"
#import "Alert.h"
#import "User.h"
#import "UserProfile.h"
#import "UIViewController+UserProfileHelpers.h"

#import "Mixpanel.h"

#define EMAIL_REGEX @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

@interface SignUpViewController () <UITextViewDelegate>

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateOfBirthPicker = [self useDatePickerForTextField:self.dateOfBirthField];
    NSInteger minAgeInYears = 12;
    NSInteger day = 60 * 60 * 24;
    NSInteger year = day * 365;
    NSDate *maximumDate = [NSDate dateWithTimeIntervalSinceNow:-minAgeInYears * year];
    NSDate *minimumDate = [NSDate dateWithTimeIntervalSinceNow:-100 * year];
    
    // default date
    NSCalendar *defaultDate = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *defaultDateComponents = [[NSDateComponents alloc] init];
    [defaultDateComponents setYear:-30];
    
    self.dateOfBirthPicker.date = [defaultDate dateByAddingComponents:defaultDateComponents toDate:[NSDate date] options:0];
    
    self.dateOfBirthPicker.maximumDate = maximumDate;
    self.dateOfBirthPicker.minimumDate = minimumDate;
    
    [self.dateOfBirthPicker addTarget:self
                               action:@selector(dateOfBirthChanged:)
                     forControlEvents:UIControlEventValueChanged];
    
    // text field overrides
    self.fullNameField.borderStyle = UITextBorderStyleRoundedRect;
    self.dateOfBirthField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    
    self.fullNameField.delegate = self;
    self.dateOfBirthField.delegate = self;
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    
//    [[UIBarButtonItem appearance] setTintColor:[UIColor ovatempAquaColor]];
    [self.navigationController.navigationBar setTintColor: [UIColor ovatempAquaColor]];
}

- (void)viewWillAppear:(BOOL)animated {
//    [[UIBarButtonItem appearance] setTintColor:[UIColor ovatempAquaColor]];
    [self.navigationController.navigationBar setTintColor: [UIColor ovatempAquaColor]];
}

- (void)viewDidAppear:(BOOL)animated {
    [self addKeyboardObservers];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self removeKeyboardObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dateOfBirthChanged:(UIDatePicker *)sender {
    self.dateOfBirthField.text = [self.dateOfBirthPicker.date classicDate];
}

# pragma mark - Registration

- (IBAction)sessionRegister:(id)sender {
    
    // Text Field Checks
    if ([self.fullNameField.text length] == 0) {
        [self alertUserWithTitle:@"Error" andMessage:@"Please enter your full name."];
        return;
    }
    
    if ([self.dateOfBirthField.text length] == 0) {
        [self alertUserWithTitle:@"Error" andMessage:@"Please enter your full date of birth."];
        return;
    }
    
    if (([self.fullNameField.text length] < 4) || ([self.fullNameField.text length] > 64)) {
        [self alertUserWithTitle:@"Error" andMessage:@"The Full Name field must be between 4 and 64 characters long."];
        return;
    }
    
    if (([self.passwordField.text length] < 4) || ([self.passwordField.text length] > 64)) {
        [self alertUserWithTitle:@"Error" andMessage:@"The Password field must be between 4 and 64 characters long."];
        return;
    }
    
    // Email Validation
    if (![self validateEmail:self.emailField.text]) {
        
        [self alertUserWithTitle:@"Error" andMessage:@"Please enter a valid email address."];
        return;
    }
    
    // Passed all checks, continue with registration
    [self startLoading];
    [ConnectionManager post:@"/users"
                     params:@{
                              @"user":
                                  @{
                                      @"email": self.emailField.text,
                                      @"password": self.passwordField.text,
                                      @"password_confirmation": self.passwordField.text
                                      }
                              }
                     target:self
                    success:@selector(signedUp:)
                    failure:@selector(signupFailed:)];
}

- (void)signedUp:(NSDictionary *)response {
    [self stopLoading];
    NSNumber *userID = response[@"user"][@"id"];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel createAlias:userID.stringValue forDistinctID:mixpanel.distinctId];
    
    [Configuration loggedInWithResponse:response];
    
    [self trackEvent:@"Signed Up" action:nil label:nil value:nil];
    
    // profile has been created successfully, set birthday and name
    [UserProfile current].dateOfBirth = self.dateOfBirthPicker.date;
    [UserProfile current].fullName = self.fullNameField.text;
    [[UserProfile current] save];
    
    [self performSegueWithIdentifier:@"signUpToWelcome1" sender:self];
}

- (void)signupFailed:(NSError *)error {
    [self stopLoading];
    [Alert presentError:error];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UIView *view = [self.view viewWithTag:textField.tag + 1];
    if (!view)
        [textField resignFirstResponder];
    else
        [view becomeFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField { //Keyboard becomes visible
    
    if (textField.tag == 1) {
        self.dateOfBirthField.text = [self.dateOfBirthPicker.date classicDate];
    }
}

- (BOOL)validateEmail:(NSString *)email {
    
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL_REGEX];
    
    return [emailPredicate evaluateWithObject:email];
}

#pragma mark - UIAlertController

- (void)alertUserWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *errorAlert = [UIAlertController
                                     alertControllerWithTitle:title
                                     message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                               handler:nil];
    
    [errorAlert addAction:ok];
    
    [self presentViewController:errorAlert animated:YES completion:nil];
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
