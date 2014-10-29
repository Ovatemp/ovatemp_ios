//
//  TrackingViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/29/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingViewController.h"

@interface TrackingViewController ()

@end

@implementation TrackingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"Tracking";
//    self.navigationItem.prompt = @"subtitle\nhello";
    
    // title
    CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 200, 44);
    UIView* _headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
    _headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    _headerTitleSubtitleView.autoresizesSubviews = NO;
    
    CGRect titleFrame = CGRectMake(0, 12, 200, 24);
    UILabel *titleView = [[UILabel alloc] initWithFrame:titleFrame];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:20];
    titleView.textAlignment = NSTextAlignmentCenter;
//    titleView.textColor = [UIColor whiteColor];
//    titleView.shadowColor = [UIColor darkGrayColor];
    titleView.shadowOffset = CGSizeMake(0, -1);
    titleView.text = [NSString stringWithFormat:@"%@", [[NSDate date] classicDate]];
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    
    CGRect subtitleFrame = CGRectMake(0, 34, 200, 44-24);
    UILabel *subtitleView = [[UILabel alloc] initWithFrame:subtitleFrame];
    subtitleView.backgroundColor = [UIColor clearColor];
    subtitleView.font = [UIFont boldSystemFontOfSize:13];
    subtitleView.textAlignment = NSTextAlignmentCenter;
//    subtitleView.textColor = [UIColor whiteColor];
//    subtitleView.shadowColor = [UIColor darkGrayColor];
    subtitleView.shadowOffset = CGSizeMake(0, -1);
    subtitleView.text = @"Cycle Day #X";
    subtitleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:subtitleView];
    
    self.navigationItem.titleView = _headerTitleSubtitleView;
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
