//
//  Welcome1ViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/20/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Welcome1ViewController.h"

@interface Welcome1ViewController ()

@end

@implementation Welcome1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didSelectTryingToConceive:(id)sender {
    [self performSegueWithIdentifier:@"tryingToConceive" sender:self];
}

- (IBAction)didSelectTryingToAvoid:(id)sender {
    [self performSegueWithIdentifier:@"tryingToAvoid" sender:self];
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
