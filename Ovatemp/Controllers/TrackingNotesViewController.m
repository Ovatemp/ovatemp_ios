//
//  TrackingNotesViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/30/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingNotesViewController.h"

@interface TrackingNotesViewController ()

@end

@implementation TrackingNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)]];
    
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    
    [self.notesTextView setTintColor:[UIColor ovatempAquaColor]];
    [self.notesTextView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.notesTextView.text length] == 0) {
        [self.notesTextView becomeFirstResponder];
    }
    
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 320, 64)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 320, 90)];
}

- (void)goBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
