//
//  MoreViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "MoreViewController.h"
#import "SessionController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (IBAction)logoutTapped:(id)sender {
  [SessionController logOut];
}

@end
