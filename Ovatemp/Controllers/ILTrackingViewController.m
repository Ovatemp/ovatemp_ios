//
//  ILTrackingViewController.m
//  Ovatemp
//
//  Created by Daniel Lozano on 3/10/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILTrackingViewController.h"

#import "CycleViewController.h"
#import "CalendarViewController.h"
#import "WebViewController.h"
#import "TrackingNotesViewController.h"

#import "Calendar.h"
#import "Day.h"

#import "TrackingStatusTableViewCell.h"
#import "TrackingTemperatureTableViewCell.h"
#import "TrackingCervicalFluidTableViewCell.h"
#import "TrackingCervicalPositionTableViewCell.h"
#import "TrackingPeriodTableViewCell.h"
#import "TrackingIntercourseTableViewCell.h"
#import "TrackingMoodTableViewCell.h"
#import "TrackingSymptomsTableViewCell.h"

@import HealthKit;

@interface ILTrackingViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,TrackingStatusCellDelegate,TrackingTemperatureCellDelegate,TrackingCervicalFluidCellDelegate,TrackingCervicalPositionCellDelegate,TrackingPeriodCellDelegate,TrackingIntercourseCellDelegate,TrackingMoodCellDelegate,TrackingSymptomsCellDelegate>

@property (nonatomic) NSDate *selectedDate;
@property (nonatomic) NSDate *peakDate;

@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic) NSIndexPath *selectedTableRowIndex;

@property (nonatomic) NSArray *trackingTableDataArray;
@property (nonatomic) NSMutableArray *drawerDateData;
@property (nonatomic) NSMutableArray *datesWithPeriod;

@property (nonatomic) Day *day;
@property (nonatomic) CycleViewController *cycleViewController;
@property (nonatomic) NSString *notes;

@property (nonatomic) BOOL lowerDrawer;
@property (nonatomic) BOOL inLandscape;

@end

@implementation ILTrackingViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedDate = [NSDate date];
    self.lowerDrawer = YES;
    
    [self addOrientationObserver];
    
    [self setTitleView];
    [self setTitleViewGestureRecognizer];
    [self setUpDrawerCollectionView];
    [self registerTableNibs];
    
    [self refreshTrackingView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"ShouldRotate"];
    [defaults synchronize];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow: 86 inSection:0];
    [self.drawerCollectionView scrollToItemAtIndexPath: self.selectedIndexPath atScrollPosition: UICollectionViewScrollPositionCenteredHorizontally animated: YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"ShouldRotate"];
    [defaults synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self removeOrientationObserver];
}

#pragma mark - Notifications

- (void)addOrientationObserver
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

}

- (void)removeOrientationObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

#pragma mark - Appearance

- (void)customizeAppearance
{
    
}

- (void)setTitleView
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *dateString = [df stringFromDate: self.selectedDate];
    self.titleLabel.text = dateString;
    
    if (self.day.cycleDay) {
        self.subtitleLabel.text = [NSString stringWithFormat:@"Cycle Day #%@", self.day.cycleDay];
    } else {
        self.subtitleLabel.text = [NSString stringWithFormat:@"Enter Cycle Info"];
    }
    
    if (!self.lowerDrawer) {
        // flip arrow if the drawer is already open
        self.arrowButton.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

- (void)setTitleViewGestureRecognizer
{
    UITapGestureRecognizer *titleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(toggleDrawer:)];
    UITapGestureRecognizer *subtitleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(toggleDrawer:)];
    [self.titleLabel addGestureRecognizer: titleTapRecognizer];
    [self.subtitleLabel addGestureRecognizer: subtitleTapRecognizer];
    self.titleLabel.userInteractionEnabled = YES;
    self.subtitleLabel.userInteractionEnabled = YES;
}

- (void)setUpDrawerCollectionView
{
    // Initial setup
    
    self.drawerCollectionView.delegate = self;
    self.drawerCollectionView.dataSource = self;
    
    [self.drawerCollectionView registerNib: [UINib nibWithNibName: @"DateCollectionViewCell" bundle: [NSBundle mainBundle]]forCellWithReuseIdentifier: @"dateCvCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(50, 50)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [self.drawerCollectionView setCollectionViewLayout:flowLayout];
    
    [self.drawerCollectionView setShowsHorizontalScrollIndicator: NO];
    [self.drawerCollectionView setShowsVerticalScrollIndicator: NO];
    
    // Add dates to collection view
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth: -3];
    
    NSDateComponents *dayOffset = [[NSDateComponents alloc] init];
    dayOffset.day = 3;
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDate *threeDaysAfterTodayDate = [currentCalendar dateByAddingComponents:dayOffset toDate:[NSDate date] options:0];
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    
    for (int i = 0; i < 90; i++) {
        dayComponent.day = -i;
        NSDate *previousDate = [currentCalendar dateByAddingComponents:dayComponent toDate:threeDaysAfterTodayDate options:0];
        [self.drawerDateData insertObject:previousDate atIndex:0];
    }
    
}

#pragma mark - Network

- (void)refreshTrackingView
{
    self.day = [[Day alloc] init];
}

- (void)refreshDrawerCollectionViewData
{
    
}

#pragma mark - IBAction's

- (IBAction)openGraph:(id)sender
{
    // Don't present the chart here, just change device orientation and let the notification for changed orientation take care of presenting the view.
    [[UIDevice currentDevice] setValue: [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft] forKey:@"orientation"];
}

- (IBAction)openCalendar:(id)sender
{
    CalendarViewController *calendarViewController = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
    calendarViewController.title = @"Calendar";
    [Calendar setDate:self.selectedDate];
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController: calendarViewController];
    navVC.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor ovatempDarkGreyTitleColor]};
    navVC.navigationBar.translucent = NO;
    
    [self presentViewController: navVC animated: YES completion: nil];
}

- (IBAction)toggleDrawer:(id)sender
{
    [self.view layoutIfNeeded];
    
    if (self.lowerDrawer) {
        self.calendarTopConstraint.constant = 90;
        self.lowerDrawer = NO;
    }else{
        self.calendarTopConstraint.constant = 0;
        self.lowerDrawer = YES;
    }
    
    [UIView animateWithDuration: 0.5 delay: 0.0 usingSpringWithDamping: 0.6f initialSpringVelocity: 0.4f options: 0 animations:^{
        [self.view layoutIfNeeded];
        
        if (self.lowerDrawer) {
            self.arrowButton.transform = CGAffineTransformMakeRotation(M_PI * 180);
        }else{
            self.arrowButton.transform = CGAffineTransformMakeRotation(M_PI);
        }
        
    } completion:^(BOOL finished) {
        if (!self.lowerDrawer) {
            // refresh drawer when closed
            [self refreshDrawerCollectionViewData];
        }
    }];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.trackingTableDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:{
            // Status Cell
            cell = [tableView dequeueReusableCellWithIdentifier: @"statuCell" forIndexPath: indexPath];
            ((TrackingStatusTableViewCell *)cell).delegate = self;
            [((TrackingStatusTableViewCell *)cell) updateCell];
            
            break;
        }
        case 1:{
            // Temperature Cell
            cell = [tableView dequeueReusableCellWithIdentifier: @"tempCell" forIndexPath: indexPath];
            ((TrackingTemperatureTableViewCell *)cell).delegate = self;
            [((TrackingTemperatureTableViewCell *)cell) updateCell];
            
            // Hide/Move Labels
            if (self.selectedTableRowIndex.row == 1) {
                [((TrackingTemperatureTableViewCell *)cell) setExpanded];
            }else{
                [((TrackingTemperatureTableViewCell *)cell) setMinimized];
            }
            break;
        }
        case 2:{
            // Cervical Fluid Cell
            cell = [tableView dequeueReusableCellWithIdentifier: @"cfCell" forIndexPath: indexPath];
            ((TrackingCervicalFluidTableViewCell *)cell).delegate = self;
            [((TrackingCervicalFluidTableViewCell *)cell) updateCell];
            
            // Hide/Move Labels
            if (self.selectedTableRowIndex.row == 2) {
                [((TrackingCervicalFluidTableViewCell *)cell) setExpanded];
            }else{
                [((TrackingCervicalFluidTableViewCell *)cell) setMinimized];
            }
            break;
        }
        case 3:{
            // Cervical Position Cell
            cell = [tableView dequeueReusableCellWithIdentifier: @"cpCell" forIndexPath: indexPath];
            ((TrackingCervicalPositionTableViewCell *)cell).delegate = self;
            [((TrackingCervicalPositionTableViewCell *)cell) updateCell];
            
            // Hide/Move Labels
            if (self.selectedTableRowIndex.row == 3) {
                [((TrackingCervicalPositionTableViewCell *)cell) setExpanded];
            }else{
                [((TrackingCervicalPositionTableViewCell *)cell) setMinimized];
            }
            break;
        }
        case 4:{
            // Period Cell
            cell = [tableView dequeueReusableCellWithIdentifier: @"periodCell" forIndexPath: indexPath];
            ((TrackingPeriodTableViewCell *)cell).delegate = self;
            [((TrackingPeriodTableViewCell *)cell) updateCell];
            
            // Hide/Move Labels
            if (self.selectedTableRowIndex.row == 4) {
                [((TrackingPeriodTableViewCell *)cell) setExpanded];
            }else{
                [((TrackingPeriodTableViewCell *)cell) setMinimized];
            }
            break;
        }
        case 5:{
            // Intercourse Cell
            cell = [self.tableView dequeueReusableCellWithIdentifier: @"intercourseCell" forIndexPath: indexPath];
            ((TrackingIntercourseTableViewCell *)cell).delegate = self;
            [((TrackingIntercourseTableViewCell *)cell) updateCell];
            
            // Hide/Move Labels
            if (self.selectedTableRowIndex.row == 5) {
                [((TrackingIntercourseTableViewCell *)cell) setExpanded];
            }else{
                [((TrackingIntercourseTableViewCell *)cell) setMinimized];
            }
            break;
        }
        case 6:{
            // Mood Cell
            cell = [self.tableView dequeueReusableCellWithIdentifier: @"moodCell" forIndexPath: indexPath];
            ((TrackingMoodTableViewCell *)cell).delegate = self;
            [((TrackingMoodTableViewCell *)cell) updateCell];
            
            // Hide/Move Labels
            if (self.selectedTableRowIndex.row == 6) {
                [((TrackingMoodTableViewCell *)cell) setExpanded];
            }else{
                [((TrackingMoodTableViewCell *)cell) setMinimized];
            }
            break;
        }
        case 7:{
            // Symptoms Cell
            cell = [tableView dequeueReusableCellWithIdentifier: @"symptomsCell" forIndexPath: indexPath];
            ((TrackingSymptomsTableViewCell *)cell).delegate = self;
            [((TrackingSymptomsTableViewCell *)cell) updateCell];
            
            // Hide/Move Labels
            if (self.selectedTableRowIndex.row == 7) {
                [((TrackingSymptomsTableViewCell *)cell) setExpanded];
            }else{
                [((TrackingSymptomsTableViewCell *)cell) setMinimized];
            }
            break;
        }
        case 8:{
            // Ovulation Cell
            cell = [self.tableView dequeueReusableCellWithIdentifier: @"ovulationCell" forIndexPath: indexPath];
            
            if (self.selectedTableRowIndex.row == 8) {
                // Hide/Move Labels
            }
            break;
        }
        case 9:{
            // Pregnancy Cell
            cell = [tableView dequeueReusableCellWithIdentifier: @"pregnancyCell" forIndexPath: indexPath];
            
            if (self.selectedTableRowIndex.row == 9) {
                // Hide/Move Labels
            }
            break;
        }
        case 10:{
            // Supplements Cell
            cell = [tableView dequeueReusableCellWithIdentifier: @"supplementsCell" forIndexPath: indexPath];

            if (self.selectedTableRowIndex.row == 10) {
                // Hide/Move Labels
            }
            break;
        }
        case 11:{
            // Medicines Cell
            cell = [tableView dequeueReusableCellWithIdentifier: @"medicinesCell" forIndexPath: indexPath];

            if (self.selectedTableRowIndex.row == 11) {
                // Hide/Move Labels
            }
            break;
        }
        default:
            break;
    }
    
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 190;
    }
    
    if(self.selectedTableRowIndex && indexPath.row == self.selectedTableRowIndex.row) {
        if (indexPath.row == 1) {
            return 200.0f;
        } else if (indexPath.row == 6  || indexPath.row == 10 || indexPath.row == 11) {
            return 200.0f;
        } else {
            return 150.0f;
        }
    }
    
    return 64.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UICollectionView Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.drawerDateData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == self.selectedIndexPath) {
        return CGSizeMake(44, 54);
    }
    
    return CGSizeMake(44, 44);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.drawerCollectionView && decelerate == NO) {
        NSLog(@"Centering Cell");
        [self centerCell];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.drawerCollectionView) {
        NSLog(@"Centering Cell");
        [self centerCell];
    }
}

- (void)centerCell
{
    NSIndexPath *pathForCenterCell = [self.drawerCollectionView indexPathForItemAtPoint:CGPointMake(CGRectGetMidX(self.drawerCollectionView.bounds), CGRectGetMidY(self.drawerCollectionView.bounds))];
    
    // we need +/- 10 as an offset here in case the user scrolls in between two cells, the indexPath will never be nil we will always snap to a cell
    
    if (!pathForCenterCell) {
        pathForCenterCell = [self.drawerCollectionView indexPathForItemAtPoint:CGPointMake(CGRectGetMidX(self.drawerCollectionView.bounds) - 10, CGRectGetMidY(self.drawerCollectionView.bounds))];
    }
    
    if (!pathForCenterCell) {
        pathForCenterCell = [self.drawerCollectionView indexPathForItemAtPoint:CGPointMake(CGRectGetMidX(self.drawerCollectionView.bounds) + 10, CGRectGetMidY(self.drawerCollectionView.bounds))];
    }
    
    if (!pathForCenterCell) { // still nil
        // I tried
        NSLog(@"You're Tearing Me Apart, Lisa!");
        return; // Oh Hi Mark
    }
    
    [self.drawerCollectionView scrollToItemAtIndexPath:pathForCenterCell atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    self.selectedIndexPath = pathForCenterCell;
    [self.drawerCollectionView reloadData];
    
    [self collectionView: self.drawerCollectionView didSelectItemAtIndexPath: pathForCenterCell];
}

#pragma mark - TrackingStatusCell Delegate

- (void)pressedNotes
{
    TrackingNotesViewController *trackingVC = [self.storyboard instantiateViewControllerWithIdentifier: @"trackingNotesViewController"];
    trackingVC.selectedDate = self.selectedDate;
    trackingVC.notesText = self.notes;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController: trackingVC];
    
    [self presentViewController: navVC animated: YES completion: nil];
}

- (NSMutableArray *)getDatesWithPeriod
{
    return self.datesWithPeriod;
}

- (NSDate *)getSelectedDate
{
    return self.selectedDate;
}

- (NSDate *)getPeakDate
{
    return self.peakDate;
}

- (NSString *)getNotes
{
    return self.notes;
}

# pragma mark - HealthKit

- (void)updateHealthKitWithTemp:(float)temp
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:HKCONNECTION]) {
        if(temp) {
            NSString *identifier = HKQuantityTypeIdentifierBodyTemperature;
            HKQuantityType *tempType = [HKObjectType quantityTypeForIdentifier:identifier];
            
            HKQuantity *myTemp = [HKQuantity quantityWithUnit:[HKUnit degreeFahrenheitUnit]
                                                  doubleValue: temp];
            
            HKQuantitySample *temperatureSample = [HKQuantitySample quantitySampleWithType: tempType
                                                                                  quantity: myTemp
                                                                                 startDate: self.selectedDate
                                                                                   endDate: self.selectedDate
                                                                                  metadata: nil];
            HKHealthStore *healthStore = [[HKHealthStore alloc] init];
            [healthStore saveObject: temperatureSample withCompletion:^(BOOL success, NSError *error) {
                NSLog(@"I saved to healthkit");
            }];
        }
    }
    else {
        NSLog(@"Could not save to healthkit. No connection could be made");
    }
}

#pragma mark - Orientation/Cycle Chart

- (void)orientationChanged:(NSNotification *)notification
{
    BOOL isAnimating = self.cycleViewController.isBeingPresented || self.cycleViewController.isBeingDismissed;
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShouldRotate"]) {
            self.inLandscape = YES;
            if (!isAnimating) {
                [self showCycleViewController];
            }
        }
    } else {
        self.inLandscape = NO;
        if (!isAnimating) {
            [self hideCycleViewController];
        }
    }
}

- (void)hideCycleViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.inLandscape) {
            [self showCycleViewController];
        }
    }];
}

- (void)showCycleViewController
{
    [self performSelector: @selector(presentChart) withObject:nil afterDelay:1.0];
}

- (void)presentChart
{
    //    [self pushViewController:self.cycleViewController];
}

#pragma mark - Helper's

- (void)registerTableNibs
{
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingStatusTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"statusCell"];
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingTemperatureTableViewCell" bundle:nil] forCellReuseIdentifier:@"tempCell"];
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingCervicalFluidTableViewCell" bundle:nil] forCellReuseIdentifier:@"cfCell"];
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingCervicalPositionTableViewCell" bundle:nil] forCellReuseIdentifier:@"cpCell"];
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingPeriodTableViewCell" bundle:nil] forCellReuseIdentifier:@"periodCell"];
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingIntercourseTableViewCell" bundle:nil] forCellReuseIdentifier:@"intercourseCell"];
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingMoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"moodCell"];
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingSymptomsTableViewCell" bundle:nil] forCellReuseIdentifier:@"symptomsCell"];
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingOvulationTestTableViewCell" bundle:nil] forCellReuseIdentifier:@"ovulationCell"];
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingPregnancyTestTableViewCell" bundle:nil] forCellReuseIdentifier:@"pregnancyCell"];
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingSupplementsTableViewCell" bundle:nil] forCellReuseIdentifier:@"supplementsCell"];
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingMedicinesTableViewCell" bundle:nil] forCellReuseIdentifier:@"medicinesCell"];
}

- (void)pushInfoAlertWithTitle:(NSString *)title AndMessage:(NSString *)message AndURL:(NSString *)url
{
    UIAlertController *infoAlert = [UIAlertController
                                    alertControllerWithTitle:title
                                    message:message
                                    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *gotIt = [UIAlertAction actionWithTitle:@"Got it"
                                                    style:UIAlertActionStyleDefault
                                                  handler:nil];
    
    UIAlertAction *learnMore = [UIAlertAction actionWithTitle:@"Learn more"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          
                                                          WebViewController *webViewController = [WebViewController withURL:url];
                                                          webViewController.title = title;
                                                          
                                                          [self presentViewController: webViewController animated: YES completion: nil];
                                                          
                                                      }];
    
    [infoAlert addAction:gotIt];
    [infoAlert addAction:learnMore];
    infoAlert.view.tintColor = [UIColor ovatempAquaColor];
    
    [self presentViewController:infoAlert animated:YES completion:nil];
}

#pragma mark - Set/Get

- (NSArray *)trackingTableDataArray
{
    if (!_trackingTableDataArray) {
        _trackingTableDataArray = @[@"Status", @"Temperature", @"Cervical Fluid", @"Cervical Position", @"Period", @"Intercourse", @"Mood", @"Symptoms",
                                    @"Ovulation Test", @"Pregnancy Test", @"Supplements", @"Medicines"];
    }
    
    return _trackingTableDataArray;
}

- (CycleViewController *)cycleViewController
{
    if (!_cycleViewController) {
        _cycleViewController = [[CycleViewController alloc] init];
        _cycleViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    
    return _cycleViewController;
}

- (NSMutableArray *)drawerDateData
{
    if (!_drawerDateData) {
        _drawerDateData = [[NSMutableArray alloc] init];
    }
    
    return _drawerDateData;
}

- (NSMutableArray *)datesWithPeriod
{
    if (!_datesWithPeriod) {
        _datesWithPeriod = [[NSMutableArray alloc] init];
    }
    
    return _datesWithPeriod;
}

@end
