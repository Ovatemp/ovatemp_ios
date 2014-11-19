//
//  ProfileTableViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/16/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "User.h"
#import "TryingToConceiveOrAvoidTableViewCell.h"
#import "AccountTableViewCell.h"

#import "EditNameAndEmailTableViewCell.h"
#import "EditDateOfBirthTableViewCell.h"
#import "EditHeightTableViewCell.h"
#import "EditWeightTableViewCell.h"

@interface ProfileTableViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property TryingToConceiveOrAvoidTableViewCell *tryingToConceiveCell;
@property TryingToConceiveOrAvoidTableViewCell *tryingToAvoidCell;

@property EditNameAndEmailTableViewCell *nameCell;
@property EditNameAndEmailTableViewCell *emailCell;
@property EditDateOfBirthTableViewCell *dobCell;
@property EditHeightTableViewCell *heightCell;
@property EditWeightTableViewCell *weightCell;

@end

@implementation ProfileTableViewController

NSArray *profileInfoSectionZeroArray;
NSArray *profileInfoSectionOneArray;

NSArray *profileSectionTitles;

BOOL firstEditTrying;
BOOL firstEditName;
BOOL firstEditDob;
BOOL firstEditEmail;
BOOL firstEditHeight;
BOOL firstEditWeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // table view line separator
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    firstEditTrying = YES;
    firstEditName = YES;
    firstEditDob = YES;
    firstEditEmail = YES;
    firstEditHeight = YES;
    firstEditWeight = YES;
    
    self.title = @"Profile";
    
    profileInfoSectionZeroArray = [NSArray arrayWithObjects:@"Trying to Conceive", @"Trying to Avoid", nil];
    
    profileInfoSectionOneArray = [NSArray arrayWithObjects:@"Full Name", @"Date of Birth", @"Email", @"Height", @"Weight", nil];
    
    profileSectionTitles = [NSArray arrayWithObjects:@"Goal", @"Profile Settings", nil];
    
    self.tableView.delegate = self;
    
//    [[UserProfile current] save]
    
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"TryingToConceiveOrAvoidTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"conceiveAvoidCell"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"EditNameAndEmailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"nameEmailCell"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"EditDateOfBirthTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"dobCell"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"EditHeightTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"heightCell"];
    [[self tableView] registerNib:[UINib nibWithNibName:@"EditWeightTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"weightCell"];
    
    [self.tableView setAllowsSelection:NO];
    
    // new nav bar buttons
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSaveAndReturn)]];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(saveDataAndReturn)]];
}

- (void)viewDidLayoutSubviews {
    
    self.nameCell.textField.borderStyle = UITextBorderStyleNone;
    [self.nameCell.textField setBackgroundColor:[UIColor clearColor]];
    
    self.dobCell.textField.borderStyle = UITextBorderStyleNone;
    [self.dobCell.textField setBackgroundColor:[UIColor clearColor]];
    
    self.emailCell.textField.borderStyle = UITextBorderStyleNone;
    [self.emailCell.textField setBackgroundColor:[UIColor clearColor]];
    
    self.heightCell.heightField.borderStyle = UITextBorderStyleNone;
    [self.heightCell.heightField setBackgroundColor:[UIColor clearColor]];
    
    self.weightCell.weightField.borderStyle = UITextBorderStyleNone;
    [self.weightCell.weightField setBackgroundColor:[UIColor clearColor]];
    
    // Default values
    UserProfile *currentUserProfile = [UserProfile current];
    
    if (firstEditTrying) {
        if (currentUserProfile.tryingToConceive == YES) {
            self.tryingToConceiveCell.tryingToSwitch.on = YES;
            self.tryingToAvoidCell.tryingToSwitch.on = NO;
        } else {
            self.tryingToConceiveCell.tryingToSwitch.on = NO;
            self.tryingToAvoidCell.tryingToSwitch.on = YES;
        }
        firstEditTrying = NO;
    }
    
    [self.tryingToConceiveCell.tryingToSwitch addTarget:self action:@selector(selectedTryingToConceive) forControlEvents:UIControlEventValueChanged];
    [self.tryingToAvoidCell.tryingToSwitch addTarget:self action:@selector(selectedTryingToAvoid) forControlEvents:UIControlEventValueChanged];
    
    // trying to avoid image
    [self.tryingToAvoidCell.tryingToImage setImage:[UIImage imageNamed:@"icn_condom"]];
    
    if (firstEditName) {
        self.nameCell.textField.text = [currentUserProfile fullName];
        firstEditName = NO;
    }
    
    if (firstEditDob) {
        self.dobCell.textField.text = [[currentUserProfile dateOfBirth] classicDate];
        firstEditDob = NO;
    }
    
    if (firstEditEmail) {
        self.emailCell.textField.text = [currentUserProfile email];
        firstEditEmail = NO;
    }
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; // Height and weight
    if (firstEditHeight) {
        if (currentUserProfile.heightInInches) {
            int feetComponent = [currentUserProfile.heightInInches intValue] / 12;
            int inchesComponent = [currentUserProfile.heightInInches intValue] % 12;
            self.heightCell.heightField.text = [NSString stringWithFormat:@"%d' %d\"", feetComponent, inchesComponent];;
        } else {
            self.heightCell.heightField.text = @"";
        }
        firstEditHeight = NO;
    }
    
    if (firstEditWeight) {
        if (currentUserProfile.weightInPounds) {
            self.weightCell.weightField.text = [NSString stringWithFormat:@"%d lbs", [currentUserProfile.weightInPounds intValue]];
        } else {
            self.weightCell.weightField.text = @"";
        }
        firstEditWeight = NO;
    }
    
    // tags
    self.nameCell.textField.tag = 0;
    self.dobCell.textField.tag = 1;
    self.emailCell.textField.tag = 2;
    self.heightCell.heightField.tag = 3;
    self.weightCell.weightField.tag = 4;
    
    self.nameCell.textField.delegate = self;
    self.dobCell.textField.delegate = self;
    self.emailCell.textField.delegate = self;
    self.heightCell.heightField.delegate = self;
    self.weightCell.weightField.delegate = self;
    
    // can't edit email field since updating email is not supported by the backend
    self.emailCell.textField.enabled = NO;
    
    // table view line separator
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]];
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
//    self.dobCell.textField.text = [self.dateOfBirthPicker.date classicDate];
//    [self.dobCell.textField setText:[self.dateOfBirthPicker.date classicDate]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![self fullNameCheck]) {
        [self alertUserWithTitle:@"Error" andMessage:@"Your full name should be between 4 and 48 characters."];
        return NO;
    }
    
    UIView *view = [self.view viewWithTag:textField.tag + 1];
    if (!view)
        [textField resignFirstResponder];
    else
        [view becomeFirstResponder];
    return YES;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    if (textField.tag == 0) {
//        if (([textField.text length] < 4) || ([textField.text length] > 48)) {
//            [self alertUserWithTitle:@"Error" andMessage:@"Your full name should be between 4 and 48 characters."];
//        }
//    }
//}

- (BOOL)fullNameCheck {
    if (([self.nameCell.textField.text length] < 4) || ([self.nameCell.textField.text length] > 48)) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField.accessibilityLabel isEqual: @"heightField"]) {
        if ([textField.text length] == 0) {
            textField.text = [NSString stringWithFormat:@"%ld' %ld\"", (long)([self.heightCell.heightPicker selectedRowInComponent:0] + 3), (long)[self.heightCell.heightPicker selectedRowInComponent:1]];
        }
    }
    
    if ([textField.accessibilityLabel isEqual: @"weightField"]) {
        if ([textField.text length] == 0) {
            textField.text = [NSString stringWithFormat:@"%ld lbs", (long)([self.weightCell.weightPicker selectedRowInComponent:0] + 100)];
        }
    }
    return YES;
}

- (void)selectedTryingToConceive {
    [self.tryingToAvoidCell.tryingToSwitch setOn:!self.tryingToAvoidCell.tryingToSwitch.on animated:YES];
}

- (void)selectedTryingToAvoid {
    [self.tryingToConceiveCell.tryingToSwitch setOn:!self.tryingToConceiveCell.tryingToSwitch.on animated:YES];
}

- (void)saveDataAndReturn {
    // user went back, save data
    
    UserProfile *currentUserProfile = [UserProfile current];
    
    currentUserProfile.tryingToConceive = self.tryingToConceiveCell.tryingToSwitch.on;
    currentUserProfile.fullName = self.nameCell.textField.text;
    currentUserProfile.dateOfBirth = self.dobCell.dateOfBirthPicker.date;
    
    [[UserProfile current] save];
    
    // height and weight
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger userHeightFeetComponent = ([self.heightCell.heightPicker selectedRowInComponent:0] + 3);
    NSInteger userHeightInchesComponent = ([self.heightCell.heightPicker selectedRowInComponent:1]);
    
    if ([self.heightCell.heightField.text length] > 0) {
//        [defaults setInteger:userHeightFeetComponent forKey:@"userHeightFeetComponent"];
//        [defaults setInteger:userHeightInchesComponent forKey:@"userHeightInchesComponent"];
//        
//        [defaults setInteger:([self.weightCell.weightPicker selectedRowInComponent:0] + 100) forKey:@"userWeight"];
        currentUserProfile.weightInPounds = [NSNumber numberWithInt:[self.weightCell.weightPicker selectedRowInComponent:0] + 100];
//
//        [defaults synchronize];
        NSNumber *newHeight = [NSNumber numberWithInt:(userHeightFeetComponent * 12) + userHeightInchesComponent];
        currentUserProfile.heightInInches = newHeight;
        [currentUserProfile save];
    }
    
    // pop
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelSaveAndReturn {
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if (section == 0) {
        return [profileInfoSectionZeroArray count];
    } else {
        return [profileInfoSectionOneArray count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"   Goal";
    if (section == 1)
        return @"   Profile Settings";
    return @"undefined";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { // conceive
            self.tryingToConceiveCell = [tableView dequeueReusableCellWithIdentifier:@"conceiveAvoidCell" forIndexPath:indexPath];
            self.tryingToConceiveCell.layoutMargins = UIEdgeInsetsZero;
            return self.tryingToConceiveCell;
        } else {
            self.tryingToAvoidCell = [tableView dequeueReusableCellWithIdentifier:@"conceiveAvoidCell" forIndexPath:indexPath];
            self.tryingToAvoidCell.tryingToLabel.text = @"Trying to Avoid";
            self.tryingToAvoidCell.layoutMargins = UIEdgeInsetsZero;
            return self.tryingToAvoidCell;
        }
    } else { // section 1
        
        if (indexPath.row == 0) { // full name
            self.nameCell = [tableView dequeueReusableCellWithIdentifier:@"nameEmailCell" forIndexPath:indexPath];
            self.nameCell.layoutMargins = UIEdgeInsetsZero;
            return self.nameCell;
        } else if (indexPath.row == 1) { // DOB
            self.dobCell = [tableView dequeueReusableCellWithIdentifier:@"dobCell" forIndexPath:indexPath];
            self.dobCell.layoutMargins = UIEdgeInsetsZero;
            return self.dobCell;
        } else if (indexPath.row == 2) { // email
            self.emailCell = [tableView dequeueReusableCellWithIdentifier:@"nameEmailCell" forIndexPath:indexPath];
            self.emailCell.titleLabel.text = @"Email";
            self.emailCell.layoutMargins = UIEdgeInsetsZero;
            return self.emailCell;
        } else if (indexPath.row == 3) { // height
            self.heightCell = [tableView dequeueReusableCellWithIdentifier:@"heightCell" forIndexPath:indexPath];
            self.heightCell.layoutMargins = UIEdgeInsetsZero;
            return self.heightCell;
        } else if (indexPath.row == 4) { // weight
            self.weightCell = [tableView dequeueReusableCellWithIdentifier:@"weightCell" forIndexPath:indexPath];
            self.weightCell.layoutMargins = UIEdgeInsetsZero;
            return self.weightCell;
        }
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 58;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 35;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 30)];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 200, 25)];
//    
//    // 15 pixel padding will come from CGRectMake(15, 5, 200, 25).
//    if (section == 0) {
//        label.text = @"Goal";
//    } else {
//        label.text = @"Profile Settings";
//    }
//    
//    view.tintColor = [UIColor grayColor];
//    
//    [view addSubview: label];
//    return view;
//}

@end
