//
//  SessionViewController.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SessionViewController.h"

#import "ButtonCell.h"
#import "TextFieldCell.h"
#import "User.h"

#import "UIViewController+ConnectionManager.h"

@interface SessionViewController () {
  UITextField *_emailField;
  UITextField *_passwordField;
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

- (IBAction)submit:(id)sender {
  [self.tableView endEditing:YES];
  switch (self.sessionType) {
    case SessionRegister:
      [self startLoadingWithMessage:@"Creating your account..."];
      [ConnectionManager post:@"/users"
                       params:@{
                                @"user":
                                  @{
                                    @"email": _emailField.text,
                                    @"password": _passwordField.text,
                                    @"password_confirmation": _passwordField.text
                                    }
                                }
                       target:self
                      success:@selector(loggedIn:)
                      failure:@selector(presentError:)
       ];
      break;
    case SessionLogin:
      [self startLoadingWithMessage:@"Logging you in..."];
      [ConnectionManager post:@"/sessions"
                       params:@{
                                @"email": _emailField.text,
                                @"password": _passwordField.text
                                }
                       target:self
                      success:@selector(loggedIn:)
                      failure:@selector(presentError:)
       ];
      break;
    case SessionResetPassword:
      [self startLoadingWithMessage:@"Resetting your password..."];
      break;
  }
}


- (void)loggedIn:(NSDictionary *)response {
  User *user = [User withAttributes:response[@"user"]];
  [User setCurrent:user];
  [Configuration sharedConfiguration].token = [[response objectForKey:@"token"] objectForKey:@"token"];
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (ButtonCell *)buttonCellForIndexPath:(NSIndexPath *)indexPath {
  ButtonCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BUTTON_CELL_IDENTIFIER];
  if (!cell) {
    cell = [[ButtonCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    [cell.button addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
  }

  switch (self.sessionType) {
    case SessionRegister:
      [cell.button setTitle:@"REGISTER" forState:UIControlStateNormal];
      break;
    case SessionLogin:
      [cell.button setTitle:@"LOG IN" forState:UIControlStateNormal];
      break;
    case SessionResetPassword:
      [cell.button setTitle:@"RESET PASSWORD" forState:UIControlStateNormal];
      break;
  }
  return cell;
}

- (NSInteger)buttonIndex {
  switch (self.sessionType) {
    case SessionRegister: case SessionLogin:
      return 2;
    case SessionResetPassword:
      return 1;
  }
}

- (TextFieldCell *)textFieldCellForIndexPath:(NSIndexPath *)indexPath {
  TextFieldCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TEXT_FIELD_CELL_IDENTIFIER];
  if (!cell) {
    cell = [[TextFieldCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
  }

  cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;

  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
      cell.textField.placeholder = @"Email Address";
      cell.textField.returnKeyType = UIReturnKeyNext;
      cell.textField.secureTextEntry = NO;
      _emailField = cell.textField;
    } else {
      cell.textField.keyboardType = UIKeyboardTypeDefault;
      cell.textField.placeholder = @"Password";
      cell.textField.returnKeyType = UIReturnKeyGo;
      cell.textField.secureTextEntry = YES;
      _passwordField = cell.textField;
    }
  }

  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (self.sessionType) {
    case SessionRegister: case SessionLogin:
      return 3;
      break;
    case SessionResetPassword:
      return 2;
      break;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell;
  if (indexPath.row == self.buttonIndex) {
    cell = [self buttonCellForIndexPath:indexPath];
  } else {
    cell = [self textFieldCellForIndexPath:indexPath];
  }
  return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the specified item to be editable.
  return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
      // Delete the row from the data source
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }
  else if (editingStyle == UITableViewCellEditingStyleInsert) {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
  }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the item to be re-orderable.
  return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
}

*/

@end
