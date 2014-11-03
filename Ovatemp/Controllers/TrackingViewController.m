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
#import "TrackingStatusTableViewCell.h"
#import "CycleViewController.h"
#import "TrackingNotesViewController.h"
#import "DateCollectionViewCell.h"

@interface TrackingViewController () <UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, TrackingCellDelegate>

@property UIImageView *arrowImageView;

@property CycleViewController *cycleViewController;

@property NSDate *selectedDate;

@property NSIndexPath *selectedIndexPath;

@end

@implementation TrackingViewController

BOOL inLandscape;

NSArray *trackingTableDataArray;

BOOL lowerDrawer;

NSMutableArray *drawerDateData;

- (id)init {
    self = [super init];
    if (self) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

# pragma mark - Autorotation

- (void)orientationChanged:(NSNotification *)notification {
    if (!self.cycleViewController) {
        self.cycleViewController = [[CycleViewController alloc] init];
        self.cycleViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    
    BOOL isAnimating = self.cycleViewController.isBeingPresented || self.cycleViewController.isBeingDismissed;
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShouldRotate"]) {
            inLandscape = YES;
            if (!isAnimating) {
                [self showCycleViewController];
            }
        }
    } else {
        inLandscape = NO;
        if (!isAnimating) {
            [self hideCycleViewController];
        }
    }
}

- (void)hideCycleViewController {
    [self dismissViewControllerAnimated:YES completion:^{
        if (inLandscape) {
            [self showCycleViewController];
        }
    }];
}

- (void)showCycleViewController {
    [self performSelector:@selector(presentChart) withObject:nil afterDelay:1.0];
}

- (void)presentChart {
    
//    [self pushViewController:self.cycleViewController];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.presentedViewController.preferredStatusBarStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // set up global date
    // start with current date, then change it whenever the user changes dates via the collection view
    self.selectedDate = [NSDate date];
    
//    self.cycleViewController = [[CycleViewController alloc] init];
    
    // table view line separator
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];

    // title
    [self setTitleView];
    
    trackingTableDataArray = [NSArray arrayWithObjects:@"Large Dummy Cell", @"Temperature", @"Cervical Fluid", @"Cervical Position", @"Period", @"Intercourse", @"Mood", @"Symptoms", @"Ovulation Test", @"Pregnancy Test", @"Supplements", @"Medicine", nil];
    
    [self.navigationController.view setTintColor:[UIColor ovatempAlmostWhiteColor]];
    
    // gesture
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(toggleDrawer:)];
    [singleTap setDelegate:self];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.navigationController.navigationBar addGestureRecognizer:singleTap];
    
    lowerDrawer = YES;
    
    self.drawerCollectionView.delegate = self;
    self.drawerCollectionView.dataSource = self;
    
    [self.drawerCollectionView registerNib:[UINib nibWithNibName:@"DateCollectionViewCell" bundle:[NSBundle mainBundle]]
forCellWithReuseIdentifier:@"dateCvCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(50, 50)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [self.drawerCollectionView setCollectionViewLayout:flowLayout];
    
//    [self.drawerCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:7 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    // status cell
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingStatusTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"statusCell"];
    
    // set up drawer
    drawerDateData = [[NSMutableArray alloc] init];
    
    // get today's date, subtrack three months, count days, add them to drawer
    NSDate *today = [NSDate date];
    NSCalendar *defaultCal = [[NSCalendar alloc] initWithCalendarIdentifier:[[NSLocale currentLocale] objectForKey:NSLocaleCalendar]];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-3];
    
    NSDate *threeMonthsAgo = [defaultCal dateByAddingComponents:offsetComponents toDate:today options:0];
    
    // array of date values subtracting one day from today's date
    
    // going to use 90 as a sloppy number of days for now
    // TODO: FIXME
    
    NSDateComponents *dayOffset = [[NSDateComponents alloc] init];
    dayOffset.day = 3;
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDate *threeDaysAfterTodayDate = [currentCalendar dateByAddingComponents:dayOffset toDate:[NSDate date] options:0];
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    for (int i = 0; i < 90; i++) {
        dayComponent.day = -i;
        
        NSDate *previousDate = [currentCalendar dateByAddingComponents:dayComponent toDate:threeDaysAfterTodayDate options:0];
        
        [drawerDateData insertObject:previousDate atIndex:0];
    }
    
    // scroll to index
    self.selectedIndexPath = [NSIndexPath indexPathForRow:86 inSection:0];
    [self.drawerCollectionView scrollToItemAtIndexPath:self.selectedIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.drawerView setHidden:NO];
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
    [self.tableView setNeedsLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"ShouldRotate"];
    [defaults synchronize];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (lowerDrawer) {
        [self.drawerView setHidden:YES];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"ShouldRotate"];
    [defaults synchronize];
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
            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y + 70, self.tableView.frame.size.width, self.tableView.frame.size.height - 70);
            
            // lower separator
            self.separatorView.frame = CGRectMake(self.separatorView.frame.origin.x, self.separatorView.frame.origin.y + 70, self.separatorView.frame.size.width, self.separatorView.frame.size.height);
            
            // flip arrow
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
            
            lowerDrawer = NO;
            
        } else {
            self.drawerView.frame = CGRectMake(self.drawerView.frame.origin.x, self.drawerView.frame.origin.y - 70, self.drawerView.frame.size.width, self.drawerView.frame.size.height);
            
            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y - 70, self.tableView.frame.size.width, self.tableView.frame.size.height + 70);
            
            // raise separator
            self.separatorView.frame = CGRectMake(self.separatorView.frame.origin.x, self.separatorView.frame.origin.y - 70, self.separatorView.frame.size.width, self.separatorView.frame.size.height);
            
            // flip arrow
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI * 180);
            
            lowerDrawer = YES;
        }
    } completion:^(BOOL finished) {
        //
    }];
}

- (IBAction)displayChart:(id)sender {
    if (!self.cycleViewController) {
        self.cycleViewController = [[CycleViewController alloc] init];
        self.cycleViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    
    // don't present the chart here, just change device orientation and let the notification for changed orientation take care of presenting the view.
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
    
}

- (void)setTitleView {
    CGRect headerTitleSubtitleFrame = CGRectMake(0, -15, 200, 44);
    UIView *_headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
    _headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    _headerTitleSubtitleView.autoresizesSubviews = NO;
    
    CGRect titleFrame = CGRectMake(0, -15, 200, 24);
    UILabel *titleView = [[UILabel alloc] initWithFrame:titleFrame];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:17];
    titleView.textAlignment = NSTextAlignmentCenter;
    
    //    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *dateString = [df stringFromDate:self.selectedDate];
    
    titleView.text = dateString;
    titleView.textColor = [UIColor ovatempDarkGreyTitleColor];
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    
    CGRect subtitleFrame = CGRectMake(0, 22-15, 200, 44-24);
    UILabel *subtitleView = [[UILabel alloc] initWithFrame:subtitleFrame];
    subtitleView.backgroundColor = [UIColor clearColor];
    subtitleView.font = [UIFont boldSystemFontOfSize:13];
    subtitleView.textAlignment = NSTextAlignmentCenter;
    subtitleView.text = @"Cycle Day #X";
    subtitleView.textColor = [UIColor ovatempAquaColor];
    subtitleView.adjustsFontSizeToFitWidth = YES;
    
    // arrow
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_pulldown_arrow"]];
    
    self.arrowImageView.frame = CGRectMake(90, 30, 20, 10);
    [_headerTitleSubtitleView addSubview:self.arrowImageView];
    
    [_headerTitleSubtitleView addSubview:subtitleView];
    
    self.navigationItem.titleView = _headerTitleSubtitleView;

}

- (void)refreshTrackingView {
    // here the user has selected a new date
    // we will need to change all the labels and update the cells accordingly after hitting the backend
    
    // don't have the backend stuff set up currently
    // TODO: FIXME, hit backend for new data from date
    
    // for now, just change labels
    [self setTitleView];
    // drawer stays down, arrow should be facing upward
    self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    
    // load new data into tableview data sources
    [self.tableView reloadData];
    
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
    
    if (indexPath.row == 0) {
        TrackingStatusTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"statusCell" forIndexPath:indexPath];;
        cell.delegate = self;
        
        cell.layoutMargins = UIEdgeInsetsZero;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        // change notes button picture if we have a note saved for that date
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateKeyString = [dateFormatter stringFromDate:self.selectedDate];
        NSString *keyString = [NSString stringWithFormat:@"note_%@", dateKeyString];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:keyString]) {
            [cell.notesButton setImage:[UIImage imageNamed:@"icn_notes_entered"] forState:UIControlStateNormal];
        } else {
            [cell.notesButton setImage:[UIImage imageNamed:@"icn_notes_empty"] forState:UIControlStateNormal];
        }
        
        return cell;
    }
    
   UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    [[cell textLabel] setText:[trackingTableDataArray objectAtIndex:indexPath.row]]; 
    
    cell.layoutMargins = UIEdgeInsetsZero;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 190;
    }
    return 44;
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [drawerDateData count];
}

- (DateCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dateCvCell" forIndexPath:indexPath];
    
    // two labels, month and day
    // get date object for array, set labels, return
    NSDate *cellDate = [drawerDateData objectAtIndex:indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setDateFormat:@"yyyy"];
//    NSString *year = [formatter stringFromDate:cellDate];
    [formatter setDateFormat:@"MMM"];
    NSString *month = [formatter stringFromDate:cellDate];
    [formatter setDateFormat:@"dd"];
    NSString *day = [formatter stringFromDate:cellDate];
    
    cell.monthLabel.text = month;
    cell.dayLabel.text = day;
    
    // if cell date is today, make it larger
    if (indexPath == self.selectedIndexPath) {
        CGRect cellFrame = cell.frame;
        cellFrame.size.height = 49.0f;
        cellFrame.size.width = 49.0f;
        cell.frame = cellFrame;
    } else {
        CGRect cellFrame = cell.frame;
        cellFrame.size.height = 44.0f;
        cellFrame.size.width = 44.0f;
        cell.frame = cellFrame;
    }
    
    // use outline for future dates
    if ([cellDate compare:[NSDate date]] == NSOrderedDescending) {
        // celldate is earlier than today
        cell.statusImageView.image = [UIImage imageNamed:@"icn_pulldown_notfertile_empty"];
    } else {
        cell.statusImageView.image = [UIImage imageNamed:@"icn_pulldown_fertile_small"];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 86) {
//        return CGSizeMake(44, 44);
//    }
//    return CGSizeMake(34, 34);
    
    if (indexPath == self.selectedIndexPath) {
        return CGSizeMake(44, 54);
    }
    
    return CGSizeMake(44, 44);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDate *dateAtIndex = [drawerDateData objectAtIndex:indexPath.row];
    
    if ([dateAtIndex compare:[NSDate date]] == NSOrderedDescending) {
        // today is earlier than selected date, don't allow user to access that date
        return;
        
    }
    
    if (self.selectedDate == dateAtIndex) {
        // do nothing, select date is the date we're already on
        return;
    }
    
    // change date
    self.selectedDate = dateAtIndex;
    
    self.selectedIndexPath = indexPath;
    
    // center cell
     [self.drawerCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    // increase cell size
    DateCollectionViewCell *selectedCell = (DateCollectionViewCell *)[self.drawerCollectionView cellForItemAtIndexPath:indexPath];
    
    CGRect cellFrame = selectedCell.frame;
    cellFrame.size.height += 5;
//    cellFrame.size.width += 5;
    selectedCell.frame = cellFrame;
//    [self.drawerCollectionView reloadData];
    
//    CGRect imageFrame = selectedCell.statusImageView.frame;
//    imageFrame.size.height += 5;
//    imageFrame.size.width += 5;
//    selectedCell.statusImageView.frame = imageFrame;
    
    [self.drawerCollectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    // load new data
    [self refreshTrackingView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // if decelerating, let scrollViewDidEndDecelerating: handle it
    if (decelerate == NO) {
        [self centerCell];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self centerCell];
}

- (void)centerCell {
     NSIndexPath *pathForCenterCell = [self.drawerCollectionView indexPathForItemAtPoint:CGPointMake(CGRectGetMidX(self.drawerCollectionView.bounds), CGRectGetMidY(self.drawerCollectionView.bounds))];
    
    if (pathForCenterCell == nil) {
        return;
    }
    
    [self.drawerCollectionView scrollToItemAtIndexPath:pathForCenterCell atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    self.selectedIndexPath = pathForCenterCell;
    [self.drawerCollectionView reloadData];
    
    [self collectionView:self.drawerCollectionView didSelectItemAtIndexPath:pathForCenterCell];
}

#pragma mark - Push View Controller Delegate
- (void)pushViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[TrackingNotesViewController class]]) {
        [self performSegueWithIdentifier:@"presentNotesVC" sender:self.selectedDate];
    } else {
        [[self navigationController] pushViewController:viewController animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isMemberOfClass:[TrackingNotesViewController class]]) {
        [segue.destinationViewController setSelectedDate:self.selectedDate];
    }
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
