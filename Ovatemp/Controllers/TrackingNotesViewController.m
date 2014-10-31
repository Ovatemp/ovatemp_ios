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
    
    // title
//    CGRect headerTitleSubtitleFrame = CGRectMake(0, -15, 200, 44);
//    UIView *_headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
    self.titleView.backgroundColor = [UIColor clearColor];
    self.titleView.autoresizesSubviews = NO;
    
    CGRect titleFrame = CGRectMake(0, -15, 200, 24);
    UILabel *titleView = [[UILabel alloc] initWithFrame:titleFrame];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:20];
    titleView.textAlignment = NSTextAlignmentCenter;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *dateString = [df stringFromDate:date];
    
    titleView.text = dateString;
    titleView.adjustsFontSizeToFitWidth = YES;
    [self.titleView addSubview:titleView];
    
    CGRect subtitleFrame = CGRectMake(0, 22-15, 200, 44-24);
    UILabel *subtitleView = [[UILabel alloc] initWithFrame:subtitleFrame];
    subtitleView.backgroundColor = [UIColor clearColor];
    subtitleView.font = [UIFont boldSystemFontOfSize:13];
    subtitleView.textAlignment = NSTextAlignmentCenter;
    subtitleView.text = @"Cycle Day #X";
    subtitleView.adjustsFontSizeToFitWidth = YES;
    
    [self.titleView addSubview:subtitleView];
    
//    self.navigationItem.titleView = _headerTitleSubtitleView;
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
