//
//  SessionViewController.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SessionViewController.h"

#import "User.h"

#import "Alert.h"
#import "UIViewController+KeyboardObservers.h"

@interface SessionViewController () {
}

@property SessionType sessionType;

@end

@implementation SessionViewController

# pragma mark - Setup

- (void)viewDidLoad {
  [super viewDidLoad];
  self.sessionType = SessionLogin;
}

- (void)viewDidAppear:(BOOL)animated {
  [self addKeyboardObservers];

}

- (void)viewDidDisappear:(BOOL)animated {
  [self removeKeyboardObservers];
}

# pragma mark - Registration, login, password reset

- (IBAction)sessionRegister:(id)sender {
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
                  failure:@selector(presentError:)];
}

- (IBAction)sessionLogin:(id)sender {
  [ConnectionManager post:@"/sessions"
                   params:@{
                            @"email": self.emailField.text,
                            @"password": self.passwordField.text
                            }
                   target:self
                  success:@selector(loggedIn:)
                  failure:@selector(presentError:)
   ];
}

- (IBAction)showResetPasswordForm:(id)sender {
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

  // TODO: Restore defaults
  //  UITextField *input = [form textFieldAtIndex:0];
  //  [input setText:self.emailField.text];
}

- (void)resetPassword:(NSString *)email {
  [ConnectionManager post:@"/password_resets"
                   params:@{
                            @"email": email,
                            }
                  success:^(NSDictionary *response) {
                    [Alert showAlertWithTitle:nil message:@"We've sent you an email! Please check your email and complete the password reset process."];
                  }
                  failure:^(NSError *error) {
                    [Alert showAlertWithTitle:nil message:@"Sorry, we couldn't reset your password. Please make sure you used the right email address and that you are connected to the internet."];
                  }];
}

- (void)loggedIn:(NSDictionary *)response {
  [Configuration loggedInWithResponse:response];
  [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)signedUp:(NSDictionary *)response {
  [Configuration loggedInWithResponse:response];

  [self performSegueWithIdentifier:@"SignUpToProfile1" sender:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.emailField resignFirstResponder];
  [self.passwordField resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == self.emailField) {
    [self.passwordField becomeFirstResponder];
  }
  if (textField == self.passwordField) {
    [self.passwordField resignFirstResponder];
    [self sessionLogin:self.passwordField];
  }

  return YES;
}

- (BOOL)shouldAutorotate {
  return FALSE;
}

@end
