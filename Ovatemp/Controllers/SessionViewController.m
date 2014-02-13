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

- (IBAction)sessionReset:(id)sender {
  [self startLoadingWithMessage:@"Resetting your password..."];
}

- (void)loggedIn:(NSDictionary *)response {  
  [SessionController loggedInWithUser:response[@"user"] andToken:response[@"token"]];

  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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

@end
