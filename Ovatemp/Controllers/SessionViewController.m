//
//  SessionViewController.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SessionViewController.h"

#import "User.h"
#import "SessionController.h"

#import "UIViewController+ConnectionManager.h"
#import "UIViewController+Alerts.h"
#import "UIAlertView+WithBlock.h"

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
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewDidDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

# pragma mark - Registration, login, password reset

- (IBAction)sessionRegister:(id)sender {
  [self startLoadingWithMessage:@"Creating your account..."];
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
                  success:@selector(loggedIn:)
                  failure:@selector(presentError:)];
}

- (IBAction)sessionLogin:(id)sender {
  [self startLoadingWithMessage:@"Logging you in..."];
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
  UIAlertView *form = [[UIAlertView alloc] initWithTitle:@"Reset Password" message:@"Please enter the email address you log in with" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reset password", nil];

  [form setAlertViewStyle:UIAlertViewStylePlainTextInput];
  UITextField *input = [form textFieldAtIndex:0];
  [input setText:self.emailField.text];

  [form showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];

    if([buttonTitle isEqualToString:@"Reset password"]) {
      UITextField *input = [form textFieldAtIndex:0];
      NSString *email = input.text;
      [self resetPassword:email];
    }
  }];
}

- (void)resetPassword:(NSString *)email {
  [ConnectionManager post:@"/password_resets"
                   params:@{
                            @"email": email,
                            }
                  success:^(NSDictionary *response) {
                    [self showNotificationWithTitle:nil message:@"We've sent you an email! Please check your email and complete the password reset process."];
                  }
                  failure:^(NSError *error) {
                    [self showNotificationWithTitle:nil message:@"Sorry, we couldn't reset your password. Please make sure you used the right email address and that you are connected to the internet."];
                  }];
}

- (void)loggedIn:(NSDictionary *)response {
  [SessionController loggedInWithUser:response[@"user"] andToken:response[@"token"]];
  [SessionController loadSupplementsEtc:response];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.emailField resignFirstResponder];
  [self.passwordField resignFirstResponder];
}

- (void)observeKeyboard {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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

// The callback for frame-changing of keyboard
- (void)keyboardDidShow:(NSNotification *)notification {
  CGFloat height = [self keyboardHeight:notification];

  [UIView animateWithDuration:.2 animations:^{
    CGRect frame = self.view.frame;
    frame.origin.y -= height / 2;
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
    NSLog(@"frame: %@", NSStringFromCGRect(self.view.frame));
    frame.origin.y = 0;
    self.view.frame = frame;
  }];
}

@end
