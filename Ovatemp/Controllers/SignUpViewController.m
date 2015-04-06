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

#import "Localytics.h"

#define EMAIL_REGEX @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

@interface SignUpViewController () <UITextViewDelegate>

@property CGFloat kBHeight;

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // text field overrides
    self.fullNameField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    
    self.fullNameField.delegate = self;
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    
//    [[UIBarButtonItem appearance] setTintColor:[UIColor ovatempAquaColor]];
    [self.navigationController.navigationBar setTintColor: [UIColor ovatempAquaColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
//    [[UIBarButtonItem appearance] setTintColor:[UIColor ovatempAquaColor]];
    [self.navigationController.navigationBar setTintColor: [UIColor ovatempAquaColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    // add keyboard observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // remove keyboard observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard
- (void)keyboardDidShow:(NSNotification *)notification
{
    CGFloat height = [self keyboardHeight:notification];
    self.kBHeight = height;
    
    if ([self.fullNameField isFirstResponder]) {
        return;
    }
    
    [UIView animateWithDuration:.2 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = -height / 3;
        self.view.frame = frame;
    }];
}

- (CGFloat)keyboardHeight:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    return keyboardFrame.size.height;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:.2 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
}

# pragma mark - Registration

- (IBAction)sessionRegister:(id)sender
{
    
    // Text Field Checks
    if ([self.fullNameField.text length] == 0) {
        [self alertUserWithTitle:@"Error" andMessage:@"Please enter your full name."];
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

- (void)signedUp:(NSDictionary *)response
{
    [self stopLoading];
    
    NSNumber *userID = response[@"user"][@"id"];
    NSString *email = response[@"user"][@"email"];
    
    [Localytics setCustomerId: [userID stringValue]];
    [Localytics setValue: email forIdentifier: @"email"];
    
    [Configuration loggedInWithResponse:response];
        
    // profile has been created successfully, set name
    [UserProfile current].fullName = self.fullNameField.text;
    [[UserProfile current] save];
    
    [self performSegueWithIdentifier:@"signUpToWelcome1" sender:self];
}

- (void)signupFailed:(NSError *)error
{
    [self stopLoading];
    [Alert presentError:error];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 2) {
        
        [UIView animateWithDuration:.2 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = -self.kBHeight/3;
            self.view.frame = frame;
        }];

    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UIView *view = [self.view viewWithTag:textField.tag + 1];
    
    if (!view)
        [textField resignFirstResponder];
    else
        [view becomeFirstResponder];
    
    if (textField.tag == 2) {
        [self sessionRegister:self];
    }
    return YES;
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
