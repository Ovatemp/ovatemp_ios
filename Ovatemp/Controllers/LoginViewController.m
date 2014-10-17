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

@interface LoginViewController ()

@end

@implementation LoginViewController

# pragma mark - Setup

- (void)viewDidAppear:(BOOL)animated {
    [self addKeyboardObservers];
    [self trackScreenView:@"Login"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self removeKeyboardObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doLogin:(id)sender {
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

# pragma mark - Autorotation

- (BOOL)shouldAutorotate {
    return FALSE;
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
