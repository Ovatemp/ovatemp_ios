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

@interface ProfileTableViewController () <UITableViewDataSource, UITableViewDelegate>

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

BOOL userIsEditing;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    userIsEditing = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(doEditInfo)];
    
    [self.tableView setAllowsSelection:NO];
}

- (void)viewDidLayoutSubviews {
    // set switch defaults
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectedTryingToConceive {
    [self.tryingToAvoidCell.tryingToSwitch setOn:!self.tryingToAvoidCell.tryingToSwitch.on animated:YES];
}

- (void)selectedTryingToAvoid {
    [self.tryingToConceiveCell.tryingToSwitch setOn:!self.tryingToConceiveCell.tryingToSwitch.on animated:YES];
}

- (void)doEditInfo {
    userIsEditing = !userIsEditing;
    
    if (userIsEditing) {
//        self.
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (userIsEditing) {
        
    }
}

@end
