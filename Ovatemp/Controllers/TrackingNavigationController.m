//
//  TrackingNavigationController.m
//  Ovatemp
//
//  Created by Josh L on 10/29/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingNavigationController.h"
#import "TrackingNavigationBar.h"

@interface TrackingNavigationController ()

@end

@implementation TrackingNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.tintColor = [UIColor blueColor];
//    self.view.backgroundColor = [UIColor blueColor];
    self.navigationBar.backgroundColor = [UIColor ovatempAlmostWhiteColor];
    
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
