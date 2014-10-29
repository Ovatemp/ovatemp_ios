//
//  TrackingViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/29/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingViewController.h"

#import "TodayNavigationController.h"
#import "TodayViewController.h"

@interface TrackingViewController () <UIGestureRecognizerDelegate>

@property UIImageView *arrowImageView;

@end

@implementation TrackingViewController

NSArray *trackingTableDataArray;

BOOL lowerDrawer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // title
    CGRect headerTitleSubtitleFrame = CGRectMake(0, -15, 200, 44);
    UIView *_headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
    _headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    _headerTitleSubtitleView.autoresizesSubviews = NO;
    
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
    [_headerTitleSubtitleView addSubview:titleView];
    
    CGRect subtitleFrame = CGRectMake(0, 22-15, 200, 44-24);
    UILabel *subtitleView = [[UILabel alloc] initWithFrame:subtitleFrame];
    subtitleView.backgroundColor = [UIColor clearColor];
    subtitleView.font = [UIFont boldSystemFontOfSize:13];
    subtitleView.textAlignment = NSTextAlignmentCenter;
    subtitleView.text = @"Cycle Day #X";
    subtitleView.adjustsFontSizeToFitWidth = YES;
    
    // arrow
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_pulldown_arrow"]];
    
    self.arrowImageView.frame = CGRectMake(90, 30, 20, 10);
    [_headerTitleSubtitleView addSubview:self.arrowImageView];
    
    [_headerTitleSubtitleView addSubview:subtitleView];
    
    self.navigationItem.titleView = _headerTitleSubtitleView;
    
    trackingTableDataArray = [NSArray arrayWithObjects:@"Large Dummy Cell", @"Temperature", @"Cervical Fluid", @"Cervical Position", @"Period", @"Intercourse", @"Mood", @"Symptoms", @"Ovulation Test", @"Pregnancy Test", @"Supplements", @"Medicine", nil];
    
    [self.navigationController.view setTintColor:[UIColor whiteColor]];
    
    // gesture
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(toggleDrawer:)];
    [singleTap setDelegate:self];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.navigationController.navigationBar addGestureRecognizer:singleTap];
    
    lowerDrawer = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleDrawer:(UIGestureRecognizer *)recognizer {

    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.6f initialSpringVelocity:0.5f options:0 animations:^{
        if (lowerDrawer) {
            self.drawerView.frame = CGRectMake(self.drawerView.frame.origin.x, self.drawerView.frame.origin.y + 70, self.drawerView.frame.size.width, self.drawerView.frame.size.height);
            
            // lower table at same time
            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y + 70, self.tableView.frame.size.width, self.tableView.frame.size.height);
            
            // flip arrow
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
            
            lowerDrawer = NO;
            
        } else {
            self.drawerView.frame = CGRectMake(self.drawerView.frame.origin.x, self.drawerView.frame.origin.y - 70, self.drawerView.frame.size.width, self.drawerView.frame.size.height);
            
            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y - 70, self.tableView.frame.size.width, self.tableView.frame.size.height);
            
            // flip arrow
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI * 180);
            
            lowerDrawer = YES;
        }
    } completion:^(BOOL finished) {
        //
    }];
}

- (IBAction)displayChart:(id)sender {
    UIViewController *todayController = [[TodayViewController alloc] init];
    todayController = [[TodayNavigationController alloc] initWithContentViewController:todayController];
    [self.navigationController pushViewController:todayController animated:YES];
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [trackingTableDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    [[cell textLabel] setText:[trackingTableDataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 190;
    }
    return 44;
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
