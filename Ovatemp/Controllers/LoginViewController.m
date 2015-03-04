//
//  LoginViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/17/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "LoginViewController.h"

#import "User.h"
#import "Alert.h"

#define EMAIL_REGEX @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

@interface LoginViewController () <UITextFieldDelegate>

@end

@implementation LoginViewController

# pragma mark - Setup

- (void)viewDidLoad
{
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    
    [self customizeAppearance];
}

- (void)viewDidAppear:(BOOL)animated
{
    // add keyboard observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self trackScreenView:@"Login"];
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

#pragma mark - Appearance

- (void)customizeAppearance
{
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject: [UIColor ovatempDarkGreyTitleColor]
                                                                                              forKey: NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor ovatempAquaColor];
}

#pragma mark - Keyboard

- (void)keyboardDidShow:(NSNotification *)notification {
    
//    if ([self.fullNameField isFirstResponder] || [self.dateOfBirthField isFirstResponder]) {
//        return;
//    }
    
    CGFloat height = [self keyboardHeight:notification];
    
    [UIView animateWithDuration:.2 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = -height / 1.5;
        self.view.frame = frame;
    }];
}

- (CGFloat)keyboardHeight:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    return keyboardFrame.size.height;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:.2 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
}

- (IBAction)doLogin:(id)sender {
    
    // Email Validation
    if (![self validateEmail:self.emailField.text]) {
        [self alertUserWithTitle:@"Error" andMessage:@"Please enter a valid email address."];
        return;
    }
    
    // Password Validation
    if (([self.passwordField.text length] < 4) || ([self.passwordField.text length] > 64)) {
        [self alertUserWithTitle:@"Error" andMessage:@"The Password field must be between 4 and 64 characters long."];
        return;
    }
    
    [self startLoading];
    [ConnectionManager post:@"/sessions"
                     params:@{
                              @"email": self.emailField.text,
                              @"password": self.passwordField.text
                              }
                     target:self
                    success:@selector(loggedIn:)
                    failure:@selector(loginFailed:)
     ];
}

- (void)loggedIn:(NSDictionary *)response {
    [self stopLoading];
    [Configuration loggedInWithResponse:response];
    [self backOutToRootViewController];
}

- (void)loginFailed:(NSError *)error {
    [self stopLoading];
    [Alert presentError:error];
}

- (IBAction)doResetPassword:(id)sender {
    __weak Alert *alert = [Alert alertWithTitle:@"Reset Password"
                                        message:@"Please enter the email address you log in with"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert addButtonWithTitle:@"Reset password" callback:^{
        UITextField *input = [alert.view textFieldAtIndex:0];
        NSString *email = input.text;
        [self resetPassword:email];
    }];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    [alert.view textFieldAtIndex:0].text = self.emailField.text;
}

- (void)resetPassword:(NSString *)email {
    [self startLoading];
    [ConnectionManager post:@"/password_resets"
                     params:@{
                              @"email": email,
                              }
                    success:^(NSDictionary *response) {
                        [self stopLoading];
                        [Alert showAlertWithTitle:nil message:@"We've sent you an email! Please check your email and complete the password reset process."];
                    }
                    failure:^(NSError *error) {
                        [self stopLoading];
                        [Alert showAlertWithTitle:nil message:@"Sorry, we couldn't reset your password. Please make sure you used the right email address and that you are connected to the internet."];
                    }];
}

- (BOOL)validateEmail:(NSString *)email {
    
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL_REGEX];
    
    return [emailPredicate evaluateWithObject:email];
}

# pragma mark - Autorotation

- (BOOL)shouldAutorotate {
    return FALSE;
}

#pragma mark - Keyboard

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide keyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UIView *view = [self.view viewWithTag:textField.tag + 1];
    if (!view)
        [textField resignFirstResponder];
    else
        [view becomeFirstResponder];
    
    if (textField.tag == 1) {
        // return key should perform login
        [self doLogin:self];
    }
    return YES;
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
