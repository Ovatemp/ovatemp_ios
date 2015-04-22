//
//  TutorialContentViewController.m
//  Ovatemp
//
//  Created by Daniel Lozano on 4/22/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "TutorialContentViewController.h"

@interface TutorialContentViewController ()

@end

@implementation TutorialContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.image) {
        self.imageView.image = self.image;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
