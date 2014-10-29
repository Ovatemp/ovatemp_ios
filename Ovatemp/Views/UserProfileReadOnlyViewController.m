//
//  UserProfileReadOnlyViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/24/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "UserProfileReadOnlyViewController.h"

#import "ProfileTableViewController.h"
#import "User.h"
#import "UserProfile.h"

@interface UserProfileReadOnlyViewController ()

@end

@implementation UserProfileReadOnlyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Profile";
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(goToEditProfileView)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    UserProfile *currentUserProfile = [UserProfile current];
    User *currentUser = [User current];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.nameLabel.text = currentUserProfile.fullName;
    
    if (currentUserProfile.tryingToConceive) {
        // conceive picture is default
        self.tryingToLabel.text = @"Trying to Conceive";
    } else {
        // set avoid picture
        self.tryingToImage.image = [UIImage imageNamed:@"icn_condom"];
//        self.tryingToImage.frame = CGRectMake(self.tryingToImage.frame.origin.x, self.tryingToImage.frame.origin.y, 23, 42);
        self.tryingToLabel.text = @"Trying to Avoid";
    }
    
    self.emailLabel.text = currentUser.email;
    
    self.dateLabel.text = [currentUserProfile.dateOfBirth classicDate];
    
    if ([defaults objectForKey:@"userHeightFeetComponent"] && [defaults objectForKey:@"userHeightInchesComponent"]) {
        self.heightLabel.text = [NSString stringWithFormat:@"%@' %@\"", [defaults objectForKey:@"userHeightFeetComponent"], [defaults objectForKey:@"userHeightInchesComponent"]];
    } else {
        self.heightLabel.text = @"No height recorded";
    }
    
    if ([defaults objectForKey:@"userWeight"]) {
        self.weightLabel.text = [NSString stringWithFormat:@"%@ lbs", [defaults objectForKey:@"userWeight"]];
    } else {
        self.weightLabel.text = @"No weight recorded";
    }
}

- (void)viewDidAppear:(BOOL)animated {
    UserProfile *currentUserProfile = [UserProfile current];
    User *currentUser = [User current];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.nameLabel.text = currentUserProfile.fullName;
    
    if (currentUserProfile.tryingToConceive) {
        // conceive picture is default
        self.tryingToImage.image = [UIImage imageNamed:@"icn_sperms"];
        self.tryingToLabel.text = @"Trying to Conceive";
    } else {
        // set avoid picture
        self.tryingToImage.image = [UIImage imageNamed:@"icn_condom"];
        //        self.tryingToImage.frame = CGRectMake(self.tryingToImage.frame.origin.x, self.tryingToImage.frame.origin.y, 23, 42);
        self.tryingToLabel.text = @"Trying to Avoid";
    }
    
    self.emailLabel.text = currentUser.email;
    
    self.dateLabel.text = [currentUserProfile.dateOfBirth classicDate];
    
    if ([defaults objectForKey:@"userHeightFeetComponent"] && [defaults objectForKey:@"userHeightInchesComponent"]) {
        self.heightLabel.text = [NSString stringWithFormat:@"%@' %@\"", [defaults objectForKey:@"userHeightFeetComponent"], [defaults objectForKey:@"userHeightInchesComponent"]];
    } else {
        self.heightLabel.text = @"No height recorded";
    }
    
    if ([defaults objectForKey:@"userWeight"]) {
        self.weightLabel.text = [NSString stringWithFormat:@"%@ lbs", [defaults objectForKey:@"userWeight"]];
    } else {
        self.weightLabel.text = @"No weight recorded";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goToEditProfileView {
    ProfileTableViewController *profileVC = [[ProfileTableViewController alloc] init];
    [self.navigationController pushViewController:profileVC animated:YES];
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
