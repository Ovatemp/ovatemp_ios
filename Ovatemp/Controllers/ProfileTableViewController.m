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
}

- (void)viewDidLayoutSubviews {
    
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; // Height and weight
    
    if (firstEditHeight) {
        self.heightCell.heightField.text = [NSString stringWithFormat:@"%@' %@\"", [defaults objectForKey:@"userHeightFeetComponent"], [defaults objectForKey:@"userHeightInchesComponent"]];
        firstEditHeight = NO;
    }
    
    if (firstEditWeight) {
        self.weightCell.weightField.text = [NSString stringWithFormat:@"%@ lbs", [defaults objectForKey:@"userWeight"]];
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
//    self.weightCell.weightField.delegate = self;
    
    // pickers
    
    
    // can't edit email field since updating email is not supported by the backend
    self.emailCell.textField.enabled = NO;
    
    // height
    
    // weight
    
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

- (void)selectedTryingToConceive {
    [self.tryingToAvoidCell.tryingToSwitch setOn:!self.tryingToAvoidCell.tryingToSwitch.on animated:YES];
}

- (void)selectedTryingToAvoid {
    [self.tryingToConceiveCell.tryingToSwitch setOn:!self.tryingToConceiveCell.tryingToSwitch.on animated:YES];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    // user went back, save data
    
    UserProfile *currentUserProfile = [UserProfile current];
    
    currentUserProfile.tryingToConceive = self.tryingToConceiveCell.tryingToSwitch.on;
    currentUserProfile.fullName = self.nameCell.textField.text;
    currentUserProfile.dateOfBirth = self.dobCell.dateOfBirthPicker.date;
    
    [[UserProfile current] save];
    
    // height and weight
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger userHeightFeetComponent = ([self.heightCell.heightPicker selectedRowInComponent:0] + 3);
    NSInteger userHeightInchesComponent = ([self.heightCell.heightPicker selectedRowInComponent:1]);
    
    [defaults setInteger:userHeightFeetComponent forKey:@"userHeightFeetComponent"];
    [defaults setInteger:userHeightInchesComponent forKey:@"userHeightInchesComponent"];
    
    [defaults setInteger:([self.weightCell.weightPicker selectedRowInComponent:0] + 100) forKey:@"userWeight"];
    
    [defaults synchronize];
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
        return @"Goal";
    if (section == 1)
        return @"Profile Settings";
    return @"undefined";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { // conceive
            self.tryingToConceiveCell = [tableView dequeueReusableCellWithIdentifier:@"conceiveAvoidCell" forIndexPath:indexPath];
            return self.tryingToConceiveCell;
        } else {
            self.tryingToAvoidCell = [tableView dequeueReusableCellWithIdentifier:@"conceiveAvoidCell" forIndexPath:indexPath];
            self.tryingToAvoidCell.tryingToLabel.text = @"Trying to Avoid";
            return self.tryingToAvoidCell;
        }
    } else { // section 1
        
        if (indexPath.row == 0) { // full name
            self.nameCell = [tableView dequeueReusableCellWithIdentifier:@"nameEmailCell" forIndexPath:indexPath];
            return self.nameCell;
        } else if (indexPath.row == 1) { // DOB
            self.dobCell = [tableView dequeueReusableCellWithIdentifier:@"dobCell" forIndexPath:indexPath];
            return self.dobCell;
        } else if (indexPath.row == 2) { // email
            self.emailCell = [tableView dequeueReusableCellWithIdentifier:@"nameEmailCell" forIndexPath:indexPath];
            self.emailCell.titleLabel.text = @"Email";
            return self.emailCell;
        } else if (indexPath.row == 3) { // height
            self.heightCell = [tableView dequeueReusableCellWithIdentifier:@"heightCell" forIndexPath:indexPath];
            return self.heightCell;
        } else if (indexPath.row == 4) { // weight
            self.weightCell = [tableView dequeueReusableCellWithIdentifier:@"weightCell" forIndexPath:indexPath];
            return self.weightCell;
        }
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

@end
