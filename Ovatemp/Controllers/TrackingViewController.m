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
#import "CycleViewController.h"
#import "TrackingNotesViewController.h"
#import "DateCollectionViewCell.h"

#import "TrackingStatusTableViewCell.h"
#import "TrackingTemperatureTableViewCell.h"
#import "TrackingCervicalFluidTableViewCell.h"

typedef enum {
    TableStateAllClosed,
    TableStateTemperatureExpanded,
    TableStateCervicalFluidExpanded,
    TableStateCervicalPositionExpanded,
    TableStatePeriodExpanded,
    TableStateIntercourseExpanded,
    TableStateMoodExpanded,
    TableStateSymptomsExpanded,
    TableStateOvulationTestExpanded,
    TableStatePregnancyTestExpanded,
    TableStateSupplementsExpanded,
    TableStateMedicineExpanded,
} TableStateType;

@interface TrackingViewController () <UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, TrackingCellDelegate>

@property UIImageView *arrowImageView;

@property CycleViewController *cycleViewController;

@property NSDate *selectedDate;

@property NSIndexPath *selectedIndexPath;

@property NSIndexPath *selectedTableRowIndex;

// cells
@property TrackingStatusTableViewCell *statusCell;
@property TrackingTemperatureTableViewCell *tempCell;
@property TrackingCervicalFluidTableViewCell *cfCell;

// info
@property CGFloat temperature;
@property NSString *cervicalFluid;

@end

@implementation TrackingViewController

BOOL inLandscape;

NSArray *trackingTableDataArray;

BOOL lowerDrawer;

NSMutableArray *drawerDateData;

// table view cell states
BOOL expandTemperatureCell;
BOOL expandCervicalFluidCell;
BOOL expandCervicalPositionCell;
BOOL expandPeriodCell;
BOOL expandIntercourseCell;
BOOL expandMoodCell;
BOOL expandSymptomsCell;
BOOL expandOvulationTestCell;
BOOL expandPregnancyTestCell;
BOOL expandSupplementsCell;
BOOL expandMedicineCell;

BOOL firstOpenTemperatureCell;
BOOL firstOpenCervicalFluidCell;
BOOL firstOpenCervicalPositionCell;
BOOL firstOpenPeriodCell;
BOOL firstOpenIntercourseCell;
BOOL firstOpenMoodCell;
BOOL firstOpenSymptomsCell;
BOOL firstOpenOvulationTestCell;
BOOL firstOpenPregnancyTestCell;
BOOL firstOpenSupplementsCell;
BOOL firstOpenMedicineCell;

BOOL TemperatureCellHasData;
BOOL CervicalFluidCellHasData;
BOOL CervicalPositionCellHasData;
BOOL PeriodCellHasData;
BOOL IntercourseCellHasData;
BOOL MoodCellHasData;
BOOL SymptomsCellHasData;
BOOL OvulationTestCellHasData;
BOOL PregnancyTestCellHasData;
BOOL SupplementsCellHasData;
BOOL MedicineCellHasData;

TableStateType currentState;

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
    
    trackingTableDataArray = [NSArray arrayWithObjects:@"Status", @"Temperature", @"Cervical Fluid", @"Cervical Position", @"Period", @"Intercourse", @"Mood", @"Symptoms", @"Ovulation Test", @"Pregnancy Test", @"Supplements", @"Medicine", nil];
    
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
    
    // hide scroll bars
    [self.drawerCollectionView setShowsHorizontalScrollIndicator:NO];
    [self.drawerCollectionView setShowsVerticalScrollIndicator:NO];
    
    // bools for table view cells
    expandTemperatureCell = NO;
    expandCervicalFluidCell = NO;
    expandCervicalPositionCell = NO;
    expandPeriodCell = NO;
    expandIntercourseCell = NO;
    expandMoodCell = NO;
    expandSymptomsCell = NO;
    expandOvulationTestCell = NO;
    expandPregnancyTestCell = NO;
    expandSupplementsCell = NO;
    expandMedicineCell = NO;
    
    firstOpenTemperatureCell = YES;
    firstOpenCervicalFluidCell = YES;
    firstOpenCervicalPositionCell = YES;
    firstOpenPeriodCell = YES;
    firstOpenIntercourseCell = YES;
    firstOpenMoodCell = YES;
    firstOpenSymptomsCell = YES;
    firstOpenOvulationTestCell = YES;
    firstOpenPregnancyTestCell = YES;
    firstOpenSupplementsCell = YES;
    firstOpenMedicineCell = YES;
    
    TemperatureCellHasData = NO;
    CervicalFluidCellHasData = NO;
    CervicalPositionCellHasData = NO;
    PeriodCellHasData = NO;
    IntercourseCellHasData = NO;
    MoodCellHasData = NO;
    SymptomsCellHasData = NO;
    OvulationTestCellHasData = NO;
    PregnancyTestCellHasData = NO;
    SupplementsCellHasData = NO;
    MedicineCellHasData = NO;
    
    currentState = TableStateAllClosed;
    [self setTableStateForState:currentState];
    
    // register cells
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingStatusTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"statusCell"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingTemperatureTableViewCell" bundle:nil] forCellReuseIdentifier:@"tempCell"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingCervicalFluidTableViewCell" bundle:nil] forCellReuseIdentifier:@"cfCell"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // bools for table view cells
    expandTemperatureCell = NO;
    expandCervicalFluidCell = NO;
    expandCervicalPositionCell = NO;
    expandPeriodCell = NO;
    expandIntercourseCell = NO;
    expandMoodCell = NO;
    expandSymptomsCell = NO;
    expandOvulationTestCell = NO;
    expandPregnancyTestCell = NO;
    expandSupplementsCell = NO;
    expandMedicineCell = NO;
    
    firstOpenTemperatureCell = YES;
    firstOpenCervicalFluidCell = YES;
    firstOpenCervicalPositionCell = YES;
    firstOpenPeriodCell = YES;
    firstOpenIntercourseCell = YES;
    firstOpenMoodCell = YES;
    firstOpenSymptomsCell = YES;
    firstOpenOvulationTestCell = YES;
    firstOpenPregnancyTestCell = YES;
    firstOpenSupplementsCell = YES;
    firstOpenMedicineCell = YES;
    
    TemperatureCellHasData = NO;
    CervicalFluidCellHasData = NO;
    CervicalPositionCellHasData = NO;
    PeriodCellHasData = NO;
    IntercourseCellHasData = NO;
    MoodCellHasData = NO;
    SymptomsCellHasData = NO;
    OvulationTestCellHasData = NO;
    PregnancyTestCellHasData = NO;
    SupplementsCellHasData = NO;
    MedicineCellHasData = NO;
    
    currentState = TableStateAllClosed;
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
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pulldown_arrow"]];
    
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
    
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
        {
            self.statusCell = [self.tableView dequeueReusableCellWithIdentifier:@"statusCell" forIndexPath:indexPath];
            self.statusCell.delegate = self;
            
            self.statusCell.layoutMargins = UIEdgeInsetsZero;
            
            [self.statusCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            // change notes button picture if we have a note saved for that date
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateKeyString = [dateFormatter stringFromDate:self.selectedDate];
            NSString *keyString = [NSString stringWithFormat:@"note_%@", dateKeyString];
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:keyString]) {
                [self.statusCell.notesButton setImage:[UIImage imageNamed:@"icn_notes_entered"] forState:UIControlStateNormal];
            } else {
                [self.statusCell.notesButton setImage:[UIImage imageNamed:@"icn_notes_empty"] forState:UIControlStateNormal];
            }
            
            self.statusCell.layoutMargins = UIEdgeInsetsZero;
            
            [self.statusCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return self.statusCell;
            break;
        }
            
        case 1:
        {
            self.tempCell = (TrackingTemperatureTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"tempCell" forIndexPath:indexPath];
            
            if (expandTemperatureCell) {
                self.tempCell.temperaturePicker.hidden = NO;
            }
            
            self.tempCell.layoutMargins = UIEdgeInsetsZero;
            
            [self.tempCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return self.tempCell;
            break;
        }
            
        case 2:
        {
            
            self.cfCell = [self.tableView dequeueReusableCellWithIdentifier:@"cfCell" forIndexPath:indexPath];

            // TODO: Finish custom cell implementation
            if (expandCervicalFluidCell) {
                self.cfCell.dryImageView.hidden = NO;
                self.cfCell.dryLabel.hidden = NO;
                
                self.cfCell.stickyImageView.hidden = NO;
                self.cfCell.stickyLabel.hidden = NO;
                
                self.cfCell.creamyImageView.hidden = NO;
                self.cfCell.creamyLabel.hidden = NO;
                
                self.cfCell.eggwhiteImageView.hidden = NO;
                self.cfCell.eggwhiteLabel.hidden = NO;
                
                // unhide selection components
                self.cfCell.placeholderLabel.hidden = YES;
                self.cfCell.cfCollapsedLabel.hidden = NO;
                self.cfCell.cfTypeImageView.hidden = NO;
            }
            
            self.cfCell.layoutMargins = UIEdgeInsetsZero;
            
            return self.cfCell;
            
            break;
        }
        
        case 3:
        {
            cell = [[UITableViewCell alloc] init];
            
            [[cell textLabel] setText:[trackingTableDataArray objectAtIndex:indexPath.row]];
            
            cell.layoutMargins = UIEdgeInsetsZero;
            
            // TODO: Finish custom cell implementation
//            if (expandCervicalPositionCell) {
//                // unhide component
//            }
            break;
        }
        
        case 4:
        {
            cell = [[UITableViewCell alloc] init];
            
            [[cell textLabel] setText:[trackingTableDataArray objectAtIndex:indexPath.row]];
            
            cell.layoutMargins = UIEdgeInsetsZero;
            
            // TODO: Finish custom cell implementation
//            if (expandPeriodCell) {
//                // unhide component
//            }
            break;
        }
            
        case 5:
        {
            cell = [[UITableViewCell alloc] init];
            
            [[cell textLabel] setText:[trackingTableDataArray objectAtIndex:indexPath.row]];
            
            cell.layoutMargins = UIEdgeInsetsZero;
            
            // TODO: Finish custom cell implementation
//            if (expandIntercourseCell) {
//                // unhide component
//            }
            break;
        }
            
        case 6:
        {
            cell = [[UITableViewCell alloc] init];
            
            [[cell textLabel] setText:[trackingTableDataArray objectAtIndex:indexPath.row]];
            
            cell.layoutMargins = UIEdgeInsetsZero;
            
            // TODO: Finish custom cell implementation
//            if (expandMoodCell) {
//                // unhide component
//            }
            break;
        }
            
        case 7:
        {
            cell = [[UITableViewCell alloc] init];
            
            [[cell textLabel] setText:[trackingTableDataArray objectAtIndex:indexPath.row]];
            
            cell.layoutMargins = UIEdgeInsetsZero;
            
            // TODO: Finish custom cell implementation
//            if (expandSymptomsCell) {
//                // unhide component
//            }
            break;
        }
        
        case 8:
        {
            cell = [[UITableViewCell alloc] init];
            
            [[cell textLabel] setText:[trackingTableDataArray objectAtIndex:indexPath.row]];
            
            cell.layoutMargins = UIEdgeInsetsZero;
            
            // TODO: Finish custom cell implementation
//            if (expandOvulationTestCell) {
//                // unhide component
//            }
            break;
        }
            
        case 9:
        {
            cell = [[UITableViewCell alloc] init];
            
            [[cell textLabel] setText:[trackingTableDataArray objectAtIndex:indexPath.row]];
            
            cell.layoutMargins = UIEdgeInsetsZero;
            
            // TODO: Finish custom cell implementation
//            if (expandPregnancyTestCell) {
//                // unhide component
//            }
            break;
        }
            
        case 10:
        {
            cell = [[UITableViewCell alloc] init];
            
            [[cell textLabel] setText:[trackingTableDataArray objectAtIndex:indexPath.row]];
            
            cell.layoutMargins = UIEdgeInsetsZero;

            // TODO: Finish custom cell implementation
//            if (expandSupplementsCell) {
//                // unhide component
//            }
            break;
        }
            
        case 11:
        {
            cell = [[UITableViewCell alloc] init];
            
            [[cell textLabel] setText:[trackingTableDataArray objectAtIndex:indexPath.row]];
            
            cell.layoutMargins = UIEdgeInsetsZero;
            
            // TODO: Finish custom cell implementation
//            if (expandMedicineCell) {
//                // unhide component
//            }
            break;
        }
            
        default:
            break;
    }
    
    cell.layoutMargins = UIEdgeInsetsZero;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 190;
    }
    
    if(self.selectedTableRowIndex && indexPath.row == self.selectedTableRowIndex.row) {
        if (expandTemperatureCell || expandCervicalFluidCell || expandCervicalPositionCell || expandPeriodCell || expandIntercourseCell || expandMoodCell || expandSymptomsCell || expandOvulationTestCell || expandPregnancyTestCell || expandSupplementsCell || expandMedicineCell) {
            return 200.0f;
        }
    }
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedTableRowIndex = indexPath;
    
    switch (indexPath.row) {
        case 0:
        {
            // status cell, do nothing
            break;
        }
            
        case 1:
        {
            if (currentState == TableStateTemperatureExpanded) {
                [self setTableStateForState:TableStateAllClosed];
            } else {
                [self setTableStateForState:TableStateTemperatureExpanded];
            }
            
            // first time the cell is opened we need to save the temp
            if (firstOpenTemperatureCell) {
                self.temperature = [self.tempCell.temperatureValueLabel.text floatValue];
                firstOpenTemperatureCell = NO;
                TemperatureCellHasData = YES;
            }
            
            // record temp
            if (!expandTemperatureCell) {
                self.temperature = [self.tempCell.temperatureValueLabel.text floatValue];
            }
            break;
        }
           
        // TODO: Finish implementaiton for custom cells
        case 2:
        {
            if (currentState == TableStateCervicalFluidExpanded) {
                [self setTableStateForState:TableStateAllClosed];
            } else {
                [self setTableStateForState:TableStateCervicalFluidExpanded];
            }
            
            // first time the cell is opened we need to save the temp
            if (firstOpenCervicalFluidCell) {
                
                // No initial data until user makes a selection
//                self.temperature = [self.tempCell.temperatureValueLabel.text floatValue];
                firstOpenTemperatureCell = NO;
//                TemperatureCellHasData = YES;
            }
            
            // record temp
            if (!expandCervicalFluidCell) {
                if (CervicalFluidCellHasData) {
                    self.cervicalFluid = self.cfCell.cfTypeCollapsedLabel.text;
                }
            }
            
            break;
        }
//
//        case 3:
//        {
//            break;
//        }
//            
//        case 4:
//        {
//            break;
//        }
//            
//        case 5:
//        {
//            break;
//        }
//            
//        case 6:
//        {
//            break;
//        }
//            
//        case 7:
//        {
//            break;
//        }
//            
//        case 8:
//        {
//            break;
//        }
//            
//        case 9:
//        {
//            break;
//        }
//            
//        case 10:
//        {
//            break;
//        }
//            
//        case 11:
//        {
//            break;
//        }
            
        default:
            break;
    }
    
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (int i = 0; i < 12; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // refreshed cells, set content
    switch (indexPath.row) {
        case 0:
        {
            // status cell, do nothing
            break;
        }
            
        case 1:
        {
            self.tempCell.temperatureValueLabel.text = [NSString stringWithFormat:@"%f.2", self.temperature];
            break;
        }

        // TODO: Finish implementation for custom cells
        case 2:
        {
            if (CervicalFluidCellHasData) {
                self.cfCell.cfTypeCollapsedLabel.text = self.cervicalFluid;
            }
            break;
        }
//
//        case 3:
//        {
//            break;
//        }
//            
//        case 4:
//        {
//            break;
//        }
//            
//        case 5:
//        {
//            break;
//        }
//            
//        case 6:
//        {
//            break;
//        }
//            
//        case 7:
//        {
//            break;
//        }
//            
//        case 8:
//        {
//            break;
//        }
//            
//        case 9:
//        {
//            break;
//        }
//            
//        case 10:
//        {
//            break;
//        }
//            
//        case 11:
//        {
//            break;
//        }
            
        default:
            break;
    }
    
    // if we opened a cell earlier, set the data we have
    if (TemperatureCellHasData) {
        self.tempCell.temperatureValueLabel.text = [NSString stringWithFormat:@"%f.2", self.temperature];
    }
    
    // TODO: Finish implementation for custom cells
    if (CervicalFluidCellHasData) {
        // TODO
        self.cfCell.cfTypeCollapsedLabel.text = self.cervicalFluid;
    }
//    if (CervicalPositionCellHasData) {
//        // TODO
//    }
//    
//    if (PeriodCellHasData) {
//        // TODO
//    }
//    
//    if (IntercourseCellHasData) {
//        // TODO
//    }
//    
//    if (MoodCellHasData) {
//        // TODO
//    }
//    if (SymptomsCellHasData) {
//        // TODO
//    }
//    
//    if (OvulationTestCellHasData) {
//        // TODO
//    }
//    
//    if (PregnancyTestCellHasData) {
//        // TODO
//    }
//    if (SupplementsCellHasData) {
//        // TODO
//    }
//    if (MedicineCellHasData) {
//        // TODO
//    }
    
    [self setTableStateForState:currentState]; // make sure current state is set
    
    [tableView setNeedsDisplay];
    [tableView setNeedsLayout];
}

- (void)setTableStateForState:(TableStateType)state {
    
//    TableStateAllClosed,
//    TableStateTemperatureExpanded,
//    TableStateCervicalFluidExpanded,
//    TableStateCervicalPositionExpanded,
//    TableStatePeriodExpanded,
//    TableStateIntercourseExpanded,
//    TableStateMoodExpanded,
//    TableStateSymptomsExpanded,
//    TableStateOvulationTestExpanded,
//    TableStatePregnancyTestExpanded,
//    TableStateSupplementsExpanded,
//    TableStateMedicineExpanded,
    
    switch (state) {
        case TableStateAllClosed:
        {
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            
            expandCervicalFluidCell = NO;
            self.cfCell.dryImageView.hidden = YES;
            self.cfCell.dryLabel.hidden = YES;
            
            self.cfCell.stickyImageView.hidden = YES;
            self.cfCell.stickyLabel.hidden = YES;
            
            self.cfCell.creamyImageView.hidden = YES;
            self.cfCell.creamyLabel.hidden = YES;
            
            self.cfCell.eggwhiteImageView.hidden = YES;
            self.cfCell.eggwhiteLabel.hidden = YES;
            
            // unhide selection components
            if (CervicalFluidCellHasData) {
                self.cfCell.placeholderLabel.hidden = YES;
                self.cfCell.cfCollapsedLabel.hidden = NO;
                self.cfCell.cfTypeImageView.hidden = NO;
                self.cfCell.cfTypeCollapsedLabel.hidden = NO;
            } else {
                self.cfCell.placeholderLabel.hidden = NO;
                self.cfCell.cfCollapsedLabel.hidden = YES;
                self.cfCell.cfTypeImageView.hidden = YES;
                self.cfCell.cfTypeCollapsedLabel.hidden = YES;
            }
            
            expandCervicalPositionCell = NO;
            // hide cervical position component
            expandPeriodCell = NO;
            // hide component
            expandIntercourseCell = NO;
            // hide component
            expandMoodCell = NO;
            // hide component
            expandSymptomsCell = NO;
            // hide component
            expandOvulationTestCell = NO;
            // hide component
            expandPregnancyTestCell = NO;
            // hide component
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStateAllClosed;
            break;
        }
            
        case TableStateTemperatureExpanded:
        {
            expandTemperatureCell = YES;
            self.tempCell.temperaturePicker.hidden = NO;
            expandCervicalFluidCell = NO;
            // hide cervical fluid component
            expandCervicalPositionCell = NO;
            // hide cervical position component
            expandPeriodCell = NO;
            // hide component
            expandIntercourseCell = NO;
            // hide component
            expandMoodCell = NO;
            // hide component
            expandSymptomsCell = NO;
            // hide component
            expandOvulationTestCell = NO;
            // hide component
            expandPregnancyTestCell = NO;
            // hide component
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStateTemperatureExpanded;
            break;
        }
            
        case TableStateCervicalFluidExpanded:
        {
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            expandCervicalFluidCell = YES;
            // unhide cervical fluid component
            expandCervicalPositionCell = NO;
            // hide cervical position component
            expandPeriodCell = NO;
            // hide component
            expandIntercourseCell = NO;
            // hide component
            expandMoodCell = NO;
            // hide component
            expandSymptomsCell = NO;
            // hide component
            expandOvulationTestCell = NO;
            // hide component
            expandPregnancyTestCell = NO;
            // hide component
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStateCervicalFluidExpanded;
            break;
        }
            
        case TableStateCervicalPositionExpanded:
        {
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            expandCervicalFluidCell = NO;
            // hide cervical fluid component
            expandCervicalPositionCell = YES;
            // unhide cervical position component
            expandPeriodCell = NO;
            // hide component
            expandIntercourseCell = NO;
            // hide component
            expandMoodCell = NO;
            // hide component
            expandSymptomsCell = NO;
            // hide component
            expandOvulationTestCell = NO;
            // hide component
            expandPregnancyTestCell = NO;
            // hide component
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStateCervicalPositionExpanded;
            break;
        }
            
        case TableStatePeriodExpanded:
        {
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            expandCervicalFluidCell = NO;
            // hide cervical fluid component
            expandCervicalPositionCell = NO;
            // hide cervical position component
            expandPeriodCell = YES;
            // unhide component
            expandIntercourseCell = NO;
            // hide component
            expandMoodCell = NO;
            // hide component
            expandSymptomsCell = NO;
            // hide component
            expandOvulationTestCell = NO;
            // hide component
            expandPregnancyTestCell = NO;
            // hide component
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStatePeriodExpanded;
            break;
        }
            
        case TableStateIntercourseExpanded:
        {
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            expandCervicalFluidCell = NO;
            // hide cervical fluid component
            expandCervicalPositionCell = NO;
            // hide cervical position component
            expandPeriodCell = NO;
            // hide component
            expandIntercourseCell = YES;
            // unhide component
            expandMoodCell = NO;
            // hide component
            expandSymptomsCell = NO;
            // hide component
            expandOvulationTestCell = NO;
            // hide component
            expandPregnancyTestCell = NO;
            // hide component
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStateIntercourseExpanded;
            break;
        }
            
        case TableStateMoodExpanded:
        {
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            expandCervicalFluidCell = NO;
            // hide cervical fluid component
            expandCervicalPositionCell = NO;
            // hide cervical position component
            expandPeriodCell = NO;
            // hide component
            expandIntercourseCell = NO;
            // hide component
            expandMoodCell = YES;
            // unhide component
            expandSymptomsCell = NO;
            // hide component
            expandOvulationTestCell = NO;
            // hide component
            expandPregnancyTestCell = NO;
            // hide component
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStateMoodExpanded;
            break;
        }
            
        case TableStateSymptomsExpanded:
        {
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            expandCervicalFluidCell = NO;
            // hide cervical fluid component
            expandCervicalPositionCell = NO;
            // hide cervical position component
            expandPeriodCell = NO;
            // hide component
            expandIntercourseCell = NO;
            // hide component
            expandMoodCell = NO;
            // hide component
            expandSymptomsCell = YES;
            // unhide component
            expandOvulationTestCell = NO;
            // hide component
            expandPregnancyTestCell = NO;
            // hide component
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStateSymptomsExpanded;
            break;
        }
            
        case TableStateOvulationTestExpanded:
        {
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            expandCervicalFluidCell = NO;
            // hide cervical fluid component
            expandCervicalPositionCell = NO;
            // hide cervical position component
            expandPeriodCell = NO;
            // hide component
            expandIntercourseCell = NO;
            // unhide component
            expandMoodCell = NO;
            // hide component
            expandSymptomsCell = NO;
            // hide component
            expandOvulationTestCell = YES;
            // unhide component
            expandPregnancyTestCell = NO;
            // hide component
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStateOvulationTestExpanded;
            break;
        }
            
        case TableStatePregnancyTestExpanded:
        {
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            expandCervicalFluidCell = NO;
            // hide cervical fluid component
            expandCervicalPositionCell = NO;
            // hide cervical position component
            expandPeriodCell = NO;
            // hide component
            expandIntercourseCell = NO;
            // hide component
            expandMoodCell = NO;
            // hide component
            expandSymptomsCell = NO;
            // hide component
            expandOvulationTestCell = NO;
            // hide component
            expandPregnancyTestCell = YES;
            // unhide component
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStatePregnancyTestExpanded;
            break;
        }
            
        case TableStateSupplementsExpanded:
        {
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            expandCervicalFluidCell = NO;
            // hide cervical fluid component
            expandCervicalPositionCell = NO;
            // hide cervical position component
            expandPeriodCell = NO;
            // hide component
            expandIntercourseCell = NO;
            // hide component
            expandMoodCell = NO;
            // hide component
            expandSymptomsCell = NO;
            // hide component
            expandOvulationTestCell = NO;
            // hide component
            expandPregnancyTestCell = NO;
            // hide component
            expandSupplementsCell = YES;
            // unhide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStateSupplementsExpanded;
            break;
        }
            
        case TableStateMedicineExpanded:
        {
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            expandCervicalFluidCell = NO;
            // hide cervical fluid component
            expandCervicalPositionCell = NO;
            // hide cervical position component
            expandPeriodCell = NO;
            // hide component
            expandIntercourseCell = NO;
            // hide component
            expandMoodCell = NO;
            // hide component
            expandSymptomsCell = NO;
            // hide component
            expandOvulationTestCell = NO;
            // hide component
            expandPregnancyTestCell = NO;
            // hide component
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = YES;
            // unhide component
            
            currentState = TableStateMedicineExpanded;
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [drawerDateData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
