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

@property UIDatePicker *dateOfBirthPicker;
@property UIPickerView *heightPicker;
@property UIPickerView *weightPicker;

@end

@implementation ProfileTableViewController

NSArray *profileInfoSectionZeroArray;
NSArray *profileInfoSectionOneArray;

NSArray *profileSectionTitles;

BOOL firstEditWeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    if (currentUserProfile.tryingToConceive == YES) {
        self.tryingToConceiveCell.tryingToSwitch.on = YES;
        self.tryingToAvoidCell.tryingToSwitch.on = NO;
    } else {
        self.tryingToConceiveCell.tryingToSwitch.on = NO;
        self.tryingToAvoidCell.tryingToSwitch.on = YES;
    }
    
    [self.tryingToConceiveCell.tryingToSwitch addTarget:self action:@selector(selectedTryingToConceive) forControlEvents:UIControlEventValueChanged];
    [self.tryingToAvoidCell.tryingToSwitch addTarget:self action:@selector(selectedTryingToAvoid) forControlEvents:UIControlEventValueChanged];
    
    // trying to avoid image
    [self.tryingToAvoidCell.tryingToImage setImage:[UIImage imageNamed:@"icn_condom"]];
    
    self.nameCell.textField.text = [currentUserProfile fullName];
    self.dobCell.textField.text = [[currentUserProfile dateOfBirth] classicDate];
    self.emailCell.textField.text = [currentUserProfile email];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.heightCell.heightField.text = [NSString stringWithFormat:@"%@' %@\"", [defaults objectForKey:@"userHeightFeetComponent"], [defaults objectForKey:@"userHeightInchesComponent"]];
    
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
    self.dateOfBirthPicker = [[UIDatePicker alloc] init];
    self.dateOfBirthPicker.date = [currentUserProfile dateOfBirth]; // default date
    
    NSInteger minAgeInYears = 12;
    NSInteger day = 60 * 60 * 24;
    NSInteger year = day * 365;
    NSDate *maximumDate = [NSDate dateWithTimeIntervalSinceNow:-minAgeInYears * year];
    NSDate *minimumDate = [NSDate dateWithTimeIntervalSinceNow:-100 * year];
    
    self.dateOfBirthPicker.minimumDate = minimumDate;
    self.dateOfBirthPicker.maximumDate = maximumDate;
    
    self.dateOfBirthPicker.datePickerMode = UIDatePickerModeDate;
    
    [self.dateOfBirthPicker addTarget:self
                               action:@selector(dateOfBirthChanged:)
                     forControlEvents:UIControlEventValueChanged];
    
    // done bar
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    [doneToolbar sizeToFit];
    UIBarButtonItem *flexArea = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.view action:@selector(endEditing:)];
    doneToolbar.items = @[flexArea, doneButton];
    self.dobCell.textField.inputAccessoryView = doneToolbar;
    
    self.dobCell.textField.inputView = self.dateOfBirthPicker;
    
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
    self.dobCell.textField.text = [self.dateOfBirthPicker.date classicDate];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UIView *view = [self.view viewWithTag:textField.tag + 1];
    if (!view)
        [textField resignFirstResponder];
    else
        [view becomeFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField { //Keyboard becomes visible
    
    if (textField.tag == 1) {
        self.dobCell.textField.text = [self.dateOfBirthPicker.date classicDate];
    }
}

- (void)selectedTryingToConceive {
    [self.tryingToAvoidCell.tryingToSwitch setOn:!self.tryingToAvoidCell.tryingToSwitch.on animated:YES];
}

- (void)selectedTryingToAvoid {
    [self.tryingToConceiveCell.tryingToSwitch setOn:!self.tryingToConceiveCell.tryingToSwitch.on animated:YES];
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
