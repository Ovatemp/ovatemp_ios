//
//  TrackingViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/29/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingViewController.h"

@interface TrackingViewController () <UIGestureRecognizerDelegate>

@property UIView *arrowView;

@end

@implementation TrackingViewController

NSArray *trackingTableDataArray;

BOOL lowerDrawer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"Tracking";
//    self.navigationItem.prompt = @"subtitle\nhello";
//    CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
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
//    titleView.textColor = [UIColor whiteColor];
//    titleView.shadowColor = [UIColor darkGrayColor];
//    titleView.shadowOffset = CGSizeMake(0, -1);
    
    NSDate *date = [NSDate date]; //I'm using this just to show the this is how you convert a date
    
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
//    subtitleView.textColor = [UIColor whiteColor];
//    subtitleView.shadowColor = [UIColor darkGrayColor];
//    subtitleView.shadowOffset = CGSizeMake(0, -1);
    subtitleView.text = @"Cycle Day #X";
    subtitleView.adjustsFontSizeToFitWidth = YES;
    
    // arrow
//    self.arrowView = [[UIView alloc] initWithFrame:CGRectMake(100, 30, 20, 10)];
//    self.arrowView.backgroundColor = [UIColor blackColor];
//    
//    // gesture recognizer
//    UITapGestureRecognizer *singleTap =
//    [[UITapGestureRecognizer alloc] initWithTarget: self
//                                            action: @selector(toggleDrawer:)];
//    [singleTap setDelegate:self];
//    singleTap.numberOfTapsRequired = 1;
//    singleTap.numberOfTouchesRequired = 1;
//    
//    [self.arrowView addGestureRecognizer: singleTap];
//    
//    [_headerTitleSubtitleView addSubview:self.arrowView];
    UIButton *but=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    but.frame= CGRectMake(0, 0, 20, 10);
    but.frame = CGRectMake(0, 22, 20, 10);
    [but setTitle:@"Ok" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(toggleDrawer) forControlEvents:UIControlEventTouchUpInside];
    self.arrowView = [[UIView alloc] initWithFrame:CGRectMake(50, 10, 20, 10)];
    [self.arrowView addSubview:but];
    but.backgroundColor = [UIColor redColor];
    
    [_headerTitleSubtitleView addSubview:self.arrowView];
    
//    // arrow
//    UIImage *arrowImage = [[UIImage alloc] initWithContentsOfFile:@"icn_pulldown_arrow"];
//    self.arrowView = [[UIImageView alloc] initWithImage:arrowImage];
//    
//    [self.arrowView setFrame:CGRectInset(_headerTitleSubtitleView.bounds, 100, 50)];
//    
//    // gesture recognizer
//    UITapGestureRecognizer *singleFingerTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(toggleDrawer:)];
//    [self.arrowView addGestureRecognizer:singleFingerTap];
//    
//    [_headerTitleSubtitleView addSubview:self.arrowView];
    
    [_headerTitleSubtitleView addSubview:subtitleView];
    
    self.navigationItem.titleView = _headerTitleSubtitleView;
    
    trackingTableDataArray = [NSArray arrayWithObjects:@"Large Dummy Cell", @"Temperature", @"Cervical Fluid", @"Cervical Position", @"Period", @"Intercourse", @"Mood", @"Symptoms", @"Ovulation Test", @"Pregnancy Test", @"Supplements", @"Medicine", nil];
    
    [self.navigationController.view setTintColor:[UIColor whiteColor]];
    
    // gesture
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(toggleDrawer:)];
    [singleTap setDelegate:self];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
//    [_headerTitleSubtitleView addGestureRecognizer: singleTap];
//    [[self.navigationController.navigationBar.subviews objectAtIndex:1] setUserInteractionEnabled:YES];
    [self.navigationController.navigationBar addGestureRecognizer:singleTap];
    
    lowerDrawer = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleDrawer:(UIGestureRecognizer *)recognizer {
//    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
//    NSLog(@"did tap on arrow view");
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.5f initialSpringVelocity:0.5f options:0 animations:^{
        if (lowerDrawer) {
            self.drawerView.frame = CGRectMake(self.drawerView.frame.origin.x, self.drawerView.frame.origin.y + 70, self.drawerView.frame.size.width, self.drawerView.frame.size.height);
            lowerDrawer = NO;
            
        } else {
            self.drawerView.frame = CGRectMake(self.drawerView.frame.origin.x, self.drawerView.frame.origin.y - 70, self.drawerView.frame.size.width, self.drawerView.frame.size.height);
            lowerDrawer = YES;
        }
    } completion:^(BOOL finished) {
        //
    }];
//    [UIView animateWithDuration:0.3 delay:0.1  options:UIViewAnimationOptionCurveEaseIn animations:^{
//        if (lowerDrawer) {
//            self.drawerView.frame = CGRectMake(self.drawerView.frame.origin.x, self.drawerView.frame.origin.y + 70, self.drawerView.frame.size.width, self.drawerView.frame.size.height);
//            lowerDrawer = NO;
//
//        } else {
//            self.drawerView.frame = CGRectMake(self.drawerView.frame.origin.x, self.drawerView.frame.origin.y - 70, self.drawerView.frame.size.width, self.drawerView.frame.size.height);
//            lowerDrawer = YES;
//        }
//    } completion:^(BOOL finished) {
//            }];
}

- (IBAction)displayChart:(id)sender {
    
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
