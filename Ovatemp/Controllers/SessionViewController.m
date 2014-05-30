//
//  SessionViewController.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SessionViewController.h"

#import "Alert.h"
#import "WebViewController.h"
#import "User.h"

#import <Mixpanel/Mixpanel.h>

@implementation SessionViewController

# pragma mark - Setup

- (void)viewDidAppear:(BOOL)animated {
  [self addKeyboardObservers];
  [self trackScreenView:@"Login"];
}

- (void)viewDidDisappear:(BOOL)animated {
  [self removeKeyboardObservers];
}

# pragma mark - Registration

- (IBAction)sessionRegister:(id)sender {
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

  [self performSegueWithIdentifier:@"SignUpToProfile1" sender:nil];
}

- (void)signupFailed:(NSError *)error {
  [self stopLoading];
  [Alert presentError:error];
}

# pragma mark- Login

- (IBAction)sessionLogin:(id)sender {
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

# pragma mark - Reset password

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
  [alert.view textFieldAtIndex:0].text = self.emailField.text;

// TODO: Restore defaults
//  UITextField *input = [form textFieldAtIndex:0];
//  [input setText:self.emailField.text];
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

# pragma mark - Privacy policy

- (IBAction)showPrivacyPolicy:(id)sender {
  NSString *url = [ROOT_URL stringByAppendingString:@"/terms"];
  WebViewController *webViewController = [WebViewController withURL:url];
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
  UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hidePrivacyPolicy:)];
  webViewController.navigationItem.leftBarButtonItem = closeButton;
  [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)hidePrivacyPolicy:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - Form handling

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

# pragma mark - Autorotation

- (BOOL)shouldAutorotate {
  return FALSE;
}

@end
