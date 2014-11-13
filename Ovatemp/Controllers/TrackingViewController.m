//
//  TrackingViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/29/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingViewController.h"

#import "ONDO.h"
#import "Alert.h"
#import "Calendar.h"

#import "TodayNavigationController.h"
#import "TodayViewController.h"
#import "CycleViewController.h"
#import "TrackingNotesViewController.h"
#import "DateCollectionViewCell.h"
#import "WebViewController.h"

#import "TrackingStatusTableViewCell.h"
#import "TrackingTemperatureTableViewCell.h"
#import "TrackingCervicalFluidTableViewCell.h"
#import "TrackingCervicalPositionTableViewCell.h"
#import "TrackingPeriodTableViewCell.h"
#import "TrackingIntercourseTableViewCell.h"
#import "TrackingMoodTableViewCell.h"
#import "TrackingSymptomsTableViewCell.h"
#import "TrackingOvulationTestTableViewCell.h"
#import "TrackingPregnancyTestTableViewCell.h"

@import HealthKit;

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

@interface TrackingViewController () <UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, TrackingCellDelegate, ONDODelegate, PresentInfoAlertDelegate>

@property UIImageView *arrowImageView;

@property CycleViewController *cycleViewController;

@property NSDate *selectedDate;

@property NSIndexPath *selectedIndexPath;

@property NSIndexPath *selectedTableRowIndex;

// cells
@property TrackingStatusTableViewCell *statusCell;
@property TrackingTemperatureTableViewCell *tempCell;
@property TrackingCervicalFluidTableViewCell *cfCell;
@property TrackingCervicalPositionTableViewCell *cpCell;
@property TrackingPeriodTableViewCell *periodCell;
@property TrackingIntercourseTableViewCell *intercourseCell;
@property TrackingMoodTableViewCell *moodCell;
@property TrackingSymptomsTableViewCell *symptomsCell;
@property TrackingOvulationTestTableViewCell *ovulationCell;
@property TrackingPregnancyTestTableViewCell *pregnancyCell;

// info
@property NSNumber *temperature;
@property NSString *cervicalFluid;
@property NSString *cervicalPosition;
@property NSString *period;
@property NSString *intercourse;
@property NSString *mood;
@property NSMutableArray *symptomIds;
@property NSString *ovulation; // opk
@property NSString *pregnancy; // ferning

@end

@implementation TrackingViewController

BOOL inLandscape;

NSArray *trackingTableDataArray;

BOOL lowerDrawer;

NSMutableArray *drawerDateData;

BOOL firstOpenView;

BOOL didLeaveToWebView; // for nav bar issues

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

UIView *loadingView;

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
    
    firstOpenView = YES;
    
    // fix bar buttons
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(-18, 0, 18, 0);
    self.navigationItem.rightBarButtonItem.imageInsets  = UIEdgeInsetsMake(-18, 0, 18, 0);
    
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
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingCervicalPositionTableViewCell" bundle:nil] forCellReuseIdentifier:@"cpCell"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingPeriodTableViewCell" bundle:nil] forCellReuseIdentifier:@"periodCell"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingIntercourseTableViewCell" bundle:nil] forCellReuseIdentifier:@"intercourseCell"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingMoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"moodCell"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingSymptomsTableViewCell" bundle:nil] forCellReuseIdentifier:@"symptomsCell"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingOvulationTestTableViewCell" bundle:nil] forCellReuseIdentifier:@"ovulationCell"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"TrackingPregnancyTestTableViewCell" bundle:nil] forCellReuseIdentifier:@"pregnancyCell"];
    
    // refresh info
    [self refreshTrackingView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self showLoadingSpinner];
    
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
    [self setTableStateForState:currentState];
    // todo: loading view while data reloads?
    [self.tableView reloadData];
    [self refreshTrackingView];
    
    // set date in cells
    [self.tempCell setSelectedDate:self.selectedDate];
    [self.cfCell setSelectedDate:self.selectedDate];
    [self.cpCell setSelectedDate:self.selectedDate];
    [self.periodCell setSelectedDate:self.selectedDate];
    [self.intercourseCell setSelectedDate:self.selectedDate];
    [self.moodCell setSelectedDate:self.selectedDate];
    [self.symptomsCell setSelectedDate:self.selectedDate];
    
    if ([ONDO sharedInstance].devices.count > 0) {
        [ONDO startWithDelegate:self];
    }
    
    didLeaveToWebView = NO;
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
    
    // fix nav bar when coming back from webview
  
    if (didLeaveToWebView) {
        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 320, 90)];
        didLeaveToWebView = NO;
    }
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
    
    self.arrowImageView.frame = CGRectMake(90, 35, 24, 8);
    
    [_headerTitleSubtitleView addSubview:self.arrowImageView];
    
    [_headerTitleSubtitleView addSubview:subtitleView];
    
    self.navigationItem.titleView = _headerTitleSubtitleView;
    
}

- (void)refreshTrackingView {
    // here the user has selected a new date
    // we will need to change all the labels and update the cells accordingly after hitting the backend
    
    // don't have the backend stuff set up currently
    // TODO: FIXME, hit backend for new data from date
    
    [ConnectionManager get:@"/cycles"
                    params:@{
                             @"date": [self.selectedDate dateId],
                             }
                   success:^(NSDictionary *response) {
                       [Cycle cycleFromResponse:response];
                       Day *day = [Day forDate:self.selectedDate];
                       if (!day) {
                           day = [Day withAttributes:@{@"date": self.selectedDate, @"idate": self.selectedDate.dateId}];
                       }
                       
                       //                       if (onSuccess) onSuccess(response);
                       
                       // set data
                       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                       
                       BOOL tempPrefFahrenheit = [defaults boolForKey:@"temperatureUnitPreferenceFahrenheit"];
                       
                       if (day.temperature) {
                           // change lable if we have info
                           if (tempPrefFahrenheit) {
                               self.temperature = day.temperature;
                               self.tempCell.temperatureValueLabel.text = [NSString stringWithFormat:@"%.2f", [self.temperature floatValue]];
                           } else {
                               float tempInCelsius = (([day.temperature floatValue]- 32) / 1.8000f);
                               self.temperature = [NSNumber numberWithFloat:tempInCelsius];
                                self.tempCell.temperatureValueLabel.text = [NSString stringWithFormat:@"%.2f", tempInCelsius];
                           }
                           
                           TemperatureCellHasData = YES;
                       } else {
                           self.tempCell.placeholderLabel.hidden = NO;
                           self.tempCell.temperatureValueLabel.hidden = YES;
                           self.tempCell.collapsedLabel.hidden = YES;
                           if (tempPrefFahrenheit) {
                               self.tempCell.temperatureValueLabel.text = @"98.60";
                           } else {
                               self.tempCell.temperatureValueLabel.text = @"37.00";
                           }
                           TemperatureCellHasData = NO;
                       }
                       
                       if (day.cervicalFluid) {
                           self.cervicalFluid = day.cervicalFluid;
                           self.cfCell.cfTypeCollapsedLabel.text = self.cervicalFluid;
                           self.cfCell.cfTypeCollapsedLabel.hidden = NO;
                           CervicalFluidCellHasData = YES;
                           [self setDataForCervicalFluidCell];
                           
                       } else { // hide components
                           self.cfCell.placeholderLabel.hidden = NO;
                           self.cfCell.cfCollapsedLabel.hidden = YES;
                           self.cfCell.cfTypeCollapsedLabel.hidden = YES;
                           self.cfCell.cfTypeImageView.hidden = YES;
                           self.cfCell.cfTypeCollapsedLabel.text = @"";
                           self.cervicalFluid = @"";
                           CervicalFluidCellHasData = NO;
                           [self.cfCell setSelectedCervicalFluidType:CervicalFluidSelectionNone];
                       }
                       
                       if ([day.cervicalPosition length] > 1) {
                           self.cervicalPosition = day.cervicalPosition;
                           self.cpCell.cpTypeCollapsedLabel.text = self.cervicalPosition;
                           self.cpCell.cpTypeCollapsedLabel.hidden = NO;
                           CervicalPositionCellHasData = YES;
                           [self setDataForCervicalPositionCell];
                       } else {
                           self.cpCell.placeholderLabel.hidden = NO;
                           self.cpCell.collapsedLabel.hidden = YES;
                           self.cpCell.cpTypeCollapsedLabel.hidden = YES;
                           self.cpCell.cpTypeImageView.hidden = YES;
                           self.cpCell.cpTypeCollapsedLabel.text = @"";
                           // todo: set self.cervicalPosition.text = @"";?
                           self.cervicalPosition = @"";
                           CervicalPositionCellHasData = NO;
                           [self.cpCell setSelectedCervicalPositionType:CervicalPositionSelectionNone];
                           
                           // deselect buttons
                           [self.cpCell.lowImageView setSelected:NO];
                           [self.cpCell.highImageView setSelected:NO];
                       }
                       
                       if (day.period) {
                           self.period = day.period;
                           self.periodCell.periodTypeCollapsedLabel.text = self.period;
                           self.periodCell.periodTypeCollapsedLabel.hidden = NO;
                           PeriodCellHasData = YES;
                           [self setDataForPeriodCell];
                           
                           if (expandPeriodCell) {
                               self.periodCell.periodTypeImageView.hidden = YES;
                               self.periodCell.periodTypeCollapsedLabel.hidden = YES;
                           }
                           
                       } else { // no data, hide componenets
                           self.periodCell.placeholderLabel.hidden = NO;
                           self.periodCell.periodCollapsedLabel.hidden = YES;
                           self.periodCell.periodTypeCollapsedLabel.hidden = YES;
                           self.periodCell.periodTypeImageView.hidden = YES;
                           self.periodCell.periodTypeCollapsedLabel.text = @"";
                           PeriodCellHasData = NO;
                           [self.periodCell setSelectedPeriodType:PeriodSelectionNoSelection];
                       }
                       
                       if (day.intercourse) {
                           self.intercourse = day.intercourse;
                           self.intercourseCell.intercourseTypeCollapsedLabel.text = self.intercourse;
                           self.intercourseCell.intercourseTypeCollapsedLabel.hidden = NO;
                           [self setDataForIntercourseCell];
                           IntercourseCellHasData = YES;
                       } else { // no data, hide components
                           self.intercourseCell.placeholderLabel.hidden = NO;
                           self.intercourseCell.intercourseCollapsedLabel.hidden = YES;
                           self.intercourseCell.intercourseTypeCollapsedLabel.hidden = YES;
                           self.intercourseCell.intercourseTypeCollapsedImageView.hidden = YES;
                           self.intercourseCell.intercourseTypeCollapsedLabel.text = @"";
                           self.intercourse = @"";
                           IntercourseCellHasData = NO;
                       }
                       
                       if (day.mood) {
                           // TODO
                           self.mood = day.mood;
                           [self setDataForMoodCell];
                           self.moodCell.moodPlaceholderLabel.hidden = YES;
                           self.moodCell.moodCollapsedLabel.hidden = NO;
                           self.moodCell.moodTypeLabel.hidden = NO;
                           MoodCellHasData = YES;
                       } else {
                           self.moodCell.moodPlaceholderLabel.hidden = NO;
                           self.moodCell.moodCollapsedLabel.hidden = YES;
                           self.moodCell.moodTypeLabel.hidden = YES;
                           MoodCellHasData = NO;
                       }
                       
                       if (day.symptomIds) {
                           self.symptomIds = day.symptomIds;
                           for (NSString *symptomID in day.symptomIds) {
                               NSInteger symptomIntVal = [symptomID integerValue];
                               
                               [self setSymptomWithValue:symptomIntVal];
                               SymptomsCellHasData = YES;
                           }
                       } else {
                           // TODO: No data
                       }
                       
                       if ([day.opk length] > 1) { // ovulation test
                           self.ovulation = day.opk;
                           self.ovulationCell.ovulationTypeCollapsedLabel.text = self.ovulation;
                           self.ovulationCell.ovulationTypeCollapsedLabel.hidden = NO;
                           self.ovulationCell.placeholderLabel.hidden = YES;
                           self.ovulationCell.ovulationTypeImageView.hidden = NO;
                           OvulationTestCellHasData = YES;
                           [self setDataForOvulationTestCell];
                           
                           if (expandOvulationTestCell) {
                               self.ovulationCell.ovulationTypeImageView.hidden = YES;
                               self.ovulationCell.ovulationTypeCollapsedLabel.hidden = YES;
                           }
                           
                       } else {
                           self.ovulationCell.placeholderLabel.hidden = NO;
                           self.ovulationCell.ovulationCollapsedLabel.hidden = YES;
                           self.ovulationCell.ovulationTypeCollapsedLabel.hidden = YES;
                           self.ovulationCell.ovulationTypeImageView.hidden = YES;
                           self.ovulationCell.ovulationTypeCollapsedLabel.text = @"";
                           
                           self.ovulation = @"";
                           OvulationTestCellHasData = NO;
                           [self.ovulationCell setSelectedOvulationTestType:OvulationTestSelectionNone];
                           
                           // deselect buttons
                           [self.ovulationCell.ovulationTypePositiveImageView setSelected:NO];
                           [self.ovulationCell.ovulationTypeNegativeImageView setSelected:NO];
                       }
                       
                       if (day.ferning) { // pregnancy test
                           self.pregnancy = day.ferning;
                           self.pregnancyCell.pregnancyTypeCollapsedLabel.text = self.pregnancy;
                           self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = NO;
                           self.pregnancyCell.placeholderLabel.hidden = YES;
                           self.pregnancyCell.pregnancyTypeImageView.hidden = NO;
                           PregnancyTestCellHasData = YES;
                           [self setDataForPregnancyTestCell];
                           
                           if (expandPregnancyTestCell) {
                               self.pregnancyCell.pregnancyTypeImageView.hidden = YES;
                               self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = YES;
                           }
                       } else {
                           self.pregnancyCell.placeholderLabel.hidden = NO;
                           self.pregnancyCell.pregnancyCollapsedLabel.hidden = YES;
                           self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = YES;
                           self.pregnancyCell.pregnancyTypeImageView.hidden = YES;
                           self.pregnancyCell.pregnancyTypeCollapsedLabel.text = @"";
                           
                           self.pregnancy = @"";
                           PregnancyTestCellHasData = NO;
                           [self.pregnancyCell setSelectedPregnancyTestType:PregnancyTestSelectionNone];
                           
                           // deselect buttons
                           [self.pregnancyCell.pregnancyTypePositiveImageView setSelected:NO];
                           [self.pregnancyCell.pregnancyTypeNegativeImageView setSelected:NO];
                       }
                       
                       //                       [self setTableStateForState:TableStateAllClosed];
                       [[self tableView] reloadData];
                       
                       [self performSelectorOnMainThread:@selector(hideLoadingSpinner) withObject:self waitUntilDone:YES];
                   }
                   failure:^(NSError *error) {
                       //                       if(onFailure) onFailure(error);
                       NSLog(@"error hitting backend");
                       // TODO: Alert user
                   }];
    
    // for now, just change labels
    [self setTitleView];
    // drawer stays down, arrow should be facing upward
    if (firstOpenView) {
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
        firstOpenView = NO;
    }
    
    
    // load new data into tableview data sources
    [self.tableView reloadData];
    
    //    [self.tempCell setSelectedDate:self.selectedDate];
    //    [self.cfCell setSelectedDate:self.selectedDate];
    //    [self.cpCell setSelectedDate:self.selectedDate];
    //    [self.periodCell setSelectedDate:self.selectedDate];
}

- (void)setDataForCervicalFluidCell {
    //    self.cervicalFluid = [self.cfCell.cfTypeCollapsedLabel.text lowercaseString];
    
    if ([self.cervicalFluid isEqual:@"dry"]) {
        self.cfCell.placeholderLabel.hidden = YES;
        self.cfCell.cfCollapsedLabel.hidden = NO;
        self.cfCell.cfTypeCollapsedLabel.text = @"Dry";
        self.cfCell.cfTypeCollapsedLabel.hidden = YES;
        self.cfCell.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_dry"];
        [self.cfCell setSelectedCervicalFluidType:CervicalFluidSelectionDry];
        [self.cfCell.dryImageView setSelected:YES];
        [self.cfCell.stickyImageView setSelected:NO];
        [self.cfCell.creamyImageView setSelected:NO];
        [self.cfCell.eggwhiteImageView setSelected:NO];
        
    } else if ([self.cervicalFluid isEqual:@"sticky"]) {
        self.cfCell.placeholderLabel.hidden = YES;
        self.cfCell.cfCollapsedLabel.hidden = NO;
        self.cfCell.cfTypeCollapsedLabel.text = @"Sticky";
        self.cfCell.cfTypeCollapsedLabel.hidden = YES;
        self.cfCell.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_sticky"];
        [self.cfCell setSelectedCervicalFluidType:CervicalFluidSelectionSticky];
        [self.cfCell.stickyImageView setSelected:YES];
        [self.cfCell.dryImageView setSelected:NO];
        [self.cfCell.creamyImageView setSelected:NO];
        [self.cfCell.eggwhiteImageView setSelected:NO];
        
    } else if ([self.cervicalFluid isEqual:@"creamy"]) {
        self.cfCell.placeholderLabel.hidden = YES;
        self.cfCell.cfCollapsedLabel.hidden = NO;
        self.cfCell.cfTypeCollapsedLabel.text = @"Creamy";
        self.cfCell.cfTypeCollapsedLabel.hidden = YES;
        self.cfCell.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_creamy"];
        [self.cfCell setSelectedCervicalFluidType:CervicalFluidSelectionCreamy];
        [self.cfCell.creamyImageView setSelected:YES];
        [self.cfCell.dryImageView setSelected:NO];
        [self.cfCell.stickyImageView setSelected:NO];
        [self.cfCell.eggwhiteImageView setSelected:NO];
        
    } else if ([self.cervicalFluid isEqual:@"eggwhite"]) {
        self.cfCell.placeholderLabel.hidden = YES;
        self.cfCell.cfCollapsedLabel.hidden = NO;
        self.cfCell.cfTypeCollapsedLabel.text = @"Eggwhite";
        self.cfCell.cfTypeCollapsedLabel.hidden = YES;
        self.cfCell.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_eggwhite"];
        [self.cfCell setSelectedCervicalFluidType:CervicalFluidSelectionEggwhite];
        [self.cfCell.eggwhiteImageView setSelected:YES];
        [self.cfCell.creamyImageView setSelected:NO];
        [self.cfCell.dryImageView setSelected:NO];
        [self.cfCell.stickyImageView setSelected:NO];
    } else { // no selection
        self.cfCell.placeholderLabel.hidden = NO;
        self.cfCell.cfCollapsedLabel.hidden = YES;
        self.cfCell.cfTypeCollapsedLabel.text = @"";
        self.cfCell.cfTypeCollapsedLabel.hidden = YES;
//        self.cfCell.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_eggwhite"];
        self.cfCell.cfTypeImageView.hidden = YES;
        [self.cfCell setSelectedCervicalFluidType:CervicalFluidSelectionNone];
        [self.cfCell.eggwhiteImageView setSelected:NO];
        [self.cfCell.creamyImageView setSelected:NO];
        [self.cfCell.dryImageView setSelected:NO];
        [self.cfCell.stickyImageView setSelected:NO];
    }
}

- (void)setDataForCervicalPositionCell {
    if ([self.cervicalPosition isEqual:@"low/closed/firm"]) {
        self.cpCell.placeholderLabel.hidden = YES;
        self.cpCell.collapsedLabel.hidden = NO;
        self.cpCell.cpTypeCollapsedLabel.text = @"Low/Closed/Firm";
        self.cpCell.cpTypeCollapsedLabel.hidden = YES;
        self.cpCell.cpTypeImageView.image = [UIImage imageNamed:@"icn_cp_lowclosedfirm"];
        [self.cpCell setSelectedCervicalPositionType:CervicalPositionSelectionLow];
        [self.cpCell.lowImageView setSelected:YES];
        [self.cpCell.highImageView setSelected:NO];
    } else if ([self.cervicalPosition isEqual:@"high/open/soft"]) { // high
        self.cpCell.placeholderLabel.hidden = YES;
        self.cpCell.collapsedLabel.hidden = NO;
        self.cpCell.cpTypeCollapsedLabel.text = @"High/Open/Soft";
        self.cpCell.cpTypeCollapsedLabel.hidden = YES;
        self.cpCell.cpTypeImageView.image = [UIImage imageNamed:@"icn_cp_highopensoft"];
        [self.cpCell setSelectedCervicalPositionType:CervicalPositionSelectionHigh];
        [self.cpCell.highImageView setSelected:YES];
        [self.cpCell.lowImageView setSelected:NO];
    } else {
        // no selection
        self.cpCell.placeholderLabel.hidden = NO;
        self.cpCell.collapsedLabel.hidden = YES;
        self.cpCell.cpTypeCollapsedLabel.text = @"";
        self.cpCell.cpTypeCollapsedLabel.hidden = NO;
        self.cpCell.cpTypeImageView.hidden = YES;
        [self.cpCell setSelectedCervicalPositionType:CervicalPositionSelectionNone];
        [self.cpCell.highImageView setSelected:NO];
        [self.cpCell.lowImageView setSelected:NO];
    }
}

- (void)setDataForPeriodCell {
    if ([self.period isEqual:@"none"]) {
        self.periodCell.placeholderLabel.hidden = YES;
        self.periodCell.periodCollapsedLabel.hidden = NO;
        self.periodCell.periodTypeCollapsedLabel.text = @"None";
        self.periodCell.periodTypeCollapsedLabel.hidden = YES;
        self.periodCell.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_none"];
        [self.periodCell setSelectedPeriodType:PeriodSelectionNone];
        [self.periodCell.noneImageView setSelected:YES];
        [self.periodCell.spottingImageView setSelected:NO];
        [self.periodCell.lightImageView setSelected:NO];
        [self.periodCell.mediumImageView setSelected:NO];
        [self.periodCell.heavyImageView setSelected:NO];
    } else if ([self.period isEqual:@"spotting"]) {
        self.periodCell.placeholderLabel.hidden = YES;
        self.periodCell.periodCollapsedLabel.hidden = NO;
        self.periodCell.periodTypeCollapsedLabel.text = @"Spotting";
        self.periodCell.periodTypeCollapsedLabel.hidden = YES;
        self.periodCell.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_spotting"];
        [self.periodCell setSelectedPeriodType:PeriodSelectionSpotting];
        [self.periodCell.spottingImageView setSelected:YES];
    } else if ([self.period isEqual:@"light"]) {
        self.periodCell.placeholderLabel.hidden = YES;
        self.periodCell.periodCollapsedLabel.hidden = NO;
        self.periodCell.periodTypeCollapsedLabel.text = @"Light";
        self.periodCell.periodTypeCollapsedLabel.hidden = YES;
        self.periodCell.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_light"];
        [self.periodCell setSelectedPeriodType:PeriodSelectionLight];
        [self.periodCell.lightImageView setSelected:YES];
        [self.periodCell.noneImageView setSelected:NO];
        [self.periodCell.spottingImageView setSelected:NO];
        [self.periodCell.mediumImageView setSelected:NO];
        [self.periodCell.heavyImageView setSelected:NO];
    } else if ([self.period isEqual:@"medium"]) {
        self.periodCell.placeholderLabel.hidden = YES;
        self.periodCell.periodCollapsedLabel.hidden = NO;
        self.periodCell.periodTypeCollapsedLabel.text = @"Medium";
        self.periodCell.periodTypeCollapsedLabel.hidden = YES;
        self.periodCell.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_medium"];
        [self.periodCell setSelectedPeriodType:PeriodSelectionMedium];
        [self.periodCell.mediumImageView setSelected:YES];
        [self.periodCell.noneImageView setSelected:NO];
        [self.periodCell.spottingImageView setSelected:NO];
        [self.periodCell.lightImageView setSelected:NO];
        [self.periodCell.heavyImageView setSelected:NO];
    } else { // heavy
        if ([self.period isEqual:@"heavy"]) {
            self.periodCell.placeholderLabel.hidden = YES;
            self.periodCell.periodCollapsedLabel.hidden = NO;
            self.periodCell.periodTypeCollapsedLabel.text = @"Heavy";
            self.periodCell.periodTypeCollapsedLabel.hidden = YES;
            self.periodCell.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_heavy"];
            [self.periodCell setSelectedPeriodType:PeriodSelectionHeavy];
            [self.periodCell.heavyImageView setSelected:YES];
            [self.periodCell.noneImageView setSelected:NO];
            [self.periodCell.spottingImageView setSelected:NO];
            [self.periodCell.lightImageView setSelected:NO];
            [self.periodCell.mediumImageView setSelected:NO];
        }
    }
}

- (void)setDataForIntercourseCell {
    if ([self.intercourse isEqual:@"protected"]) {
        self.intercourseCell.placeholderLabel.hidden = YES;
        self.intercourseCell.intercourseCollapsedLabel.hidden = NO;
        self.intercourseCell.intercourseTypeCollapsedLabel.text = @"Protected";
        self.intercourseCell.intercourseTypeCollapsedLabel.hidden = YES;
        self.intercourseCell.intercourseTypeCollapsedImageView.image = [UIImage imageNamed:@"icn_i_protected"];
        [self.intercourseCell.protectedImageView setSelected:YES];
        [self.intercourseCell.unprotectedImageView setSelected:NO];
    } else if ([self.intercourse isEqual:@"unprotected"]) { // unprotected
        self.intercourseCell.placeholderLabel.hidden = YES;
        self.intercourseCell.intercourseCollapsedLabel.hidden = NO;
        self.intercourseCell.intercourseTypeCollapsedLabel.text = @"Unprotected";
        self.intercourseCell.intercourseTypeCollapsedLabel.hidden = YES;
        self.intercourseCell.intercourseTypeCollapsedImageView.image = [UIImage imageNamed:@"icn_i_unprotected"];
        [self.intercourseCell.protectedImageView setSelected:NO];
        [self.intercourseCell.unprotectedImageView setSelected:YES];
    } else { // none
        self.intercourseCell.placeholderLabel.hidden = NO;
        self.intercourseCell.intercourseCollapsedLabel.hidden = YES;
        self.intercourseCell.intercourseTypeCollapsedLabel.text = @"";
        self.intercourseCell.intercourseTypeCollapsedLabel.hidden = YES;
        self.intercourseCell.intercourseTypeCollapsedImageView.hidden = YES;
        [self.intercourseCell.protectedImageView setSelected:NO];
        [self.intercourseCell.unprotectedImageView setSelected:NO];
    }
}

- (void)setDataForMoodCell {
    if ([self.mood isEqual:@"angry"]) {
        [self.moodCell setAngryMoodSelected:YES];
        [self.moodCell.moodTypeLabel setText:@"Angry"];
    } else if ([self.mood isEqual:@"anxious"]) {
        [self.moodCell setAnxiousMoodSelected:YES];
        [self.moodCell.moodTypeLabel setText:@"Anxious"];
    } else if ([self.mood isEqual:@"calm"]) {
        [self.moodCell setCalmMoodSelected:YES];
        [self.moodCell.moodTypeLabel setText:@"Calm"];
    } else if ([self.mood isEqual:@"depressed"]) {
        [self.moodCell setDepressedMoodSelected:YES];
        [self.moodCell.moodTypeLabel setText:@"Depressed"];
    } else if ([self.mood isEqual:@"moody"] || [self.mood isEqual:@"emotional"]) { // emotional
        [self.moodCell setEmotionalModdSelected:YES];
        [self.moodCell.moodTypeLabel setText:@"Emotional"];
    } else if ([self.mood isEqual:@"amazing"] || [self.mood isEqual:@"excited"]) { // excited
        [self.moodCell setExcitedMoodSelected:YES];
        [self.moodCell.moodTypeLabel setText:@"Excited"];
    } else if ([self.mood isEqual:@"frisky"]) {
        [self.moodCell setFriskyMoodSelected:YES];
        [self.moodCell.moodTypeLabel setText:@"Frisky"];
    } else if ([self.mood isEqual:@"frustrated"]) {
        [self.moodCell setFrustratedMoodSelected:YES];
        [self.moodCell.moodTypeLabel setText:@"Frustrated"];
    } else if ([self.mood isEqual:@"good"] || [self.mood isEqual:@"happy"]) { // happy
        [self.moodCell setHappyMoodSelected:YES];
        [self.moodCell.moodTypeLabel setText:@"Happy"];
    } else if ([self.mood isEqual:@"in love"]) {
        [self.moodCell setInLoveMoodSelected:YES];
        [self.moodCell.moodTypeLabel setText:@"In Love"];
    } else if ([self.mood isEqual:@"motivated"]) {
        [self.moodCell setMotivatedMoodSelected:YES];
        [self.moodCell.moodTypeLabel setText:@"Motivated"];
    } else if ([self.mood isEqual:@"neutral"]) {
        [self.moodCell setNeutralMoodSelected:YES];
        [self.moodCell.moodTypeLabel setText:@"Neutral"];
    } else if ([self.mood isEqual:@"sad"]) {
        [self.moodCell setSadMoodSelected:YES];
        [self.moodCell.moodTypeLabel setText:@"Sad"];
    } else { // worried
        [self.moodCell setWorriedMoodSelected:YES];
        [self.moodCell.moodTypeLabel setText:@"Worried"];
    }
    //    angryMoodSelected = NO;
    //    anxiousMoodSelected = NO;
    //    calmMoodSelected = NO;
    //    depressedMoodSelected = NO;
    //    emotionalModdSelected = NO;
    //    excitedMoodSelected = NO;
    //    friskyMoodSelected = NO;
    //    frustratedMoodSelected = NO;
    //    happyMoodSelected = NO;
    //    inLoveMoodSelected = NO;
    //    motivatedMoodSelected = NO;
    //    neutralMoodSelected = NO;
    //    neutralMoodSelected = NO;
    //    sadMoodSelected = NO;
    //    worriedMoodSelected = NO;
}

- (void)setSymptomWithValue:(NSInteger)value {
    // set i-1th cell check mark
    // add element to array
    
    value--;
//    [self.symptomsCell.selectedSymptoms addObject:[NSNumber numberWithInteger:value]];
    // set checkmark
    
    if (value == 0) {
        [self.symptomsCell setBreastTendernessSelected:YES];
    } else if (value == 1) {
        [self.symptomsCell setHeadachesSelected:YES];
    } else if (value == 2) {
        [self.symptomsCell setNauseaSeleted:YES];
    } else if (value == 3) {
        [self.symptomsCell setIrritabilityMoodSwingsSelected:YES];
    } else if (value == 4) {
        [self.symptomsCell setBloatingSelected:YES];
    } else if (value == 5) {
        [self.symptomsCell setPmsSelected:YES];
    } else if (value == 6) {
        [self.symptomsCell setStressSelected:YES];
    } else if (value == 7) {
        [self.symptomsCell setTravelSelected:YES];
    } else { // fever
        [self.symptomsCell setFeverSelected:YES];
    }
    
//        symptomsDataSource = [NSArray arrayWithObjects:@"Breast tenderness", @"Headaches", @"Nausea", @"Irritability/Mood swings", @"Bloating", @"PMS", @"Stress", @"Travel", @"Fever", nil];
}

- (void)setDataForOvulationTestCell {
    if ([self.ovulation isEqual:@"positive"]) {
        [self.ovulationCell setSelectedOvulationTestType:OvulationTestSelectionPositive];
        [self.ovulationCell.ovulationTypeCollapsedLabel setText:@"Positive"];
        [self.ovulationCell.ovulationTypeNegativeImageView setSelected:NO];
        [self.ovulationCell.ovulationTypePositiveImageView setSelected:YES];
        self.ovulationCell.ovulationTypeImageView.image = [UIImage imageNamed:@"icn_positive"];
    } else if([self.ovulation isEqual:@"negative"]) { // negative
        [self.ovulationCell setSelectedOvulationTestType:OvulationTestSelectionNegative];
        [self.ovulationCell.ovulationTypeCollapsedLabel setText:@"Negative"];
        [self.ovulationCell.ovulationTypeNegativeImageView setSelected:YES];
        [self.ovulationCell.ovulationTypePositiveImageView setSelected:NO];
        self.ovulationCell.ovulationTypeImageView.image = [UIImage imageNamed:@"icn_negative"];
    } else { // no selection
        [self.ovulationCell setSelectedOvulationTestType:OvulationTestSelectionNone];
        [self.ovulationCell.ovulationTypeCollapsedLabel setText:@""];
        [self.ovulationCell.ovulationTypeNegativeImageView setSelected:NO];
        [self.ovulationCell.ovulationTypePositiveImageView setSelected:NO];
        self.ovulationCell.imageView.hidden = YES;
    }
}

- (void)setDataForPregnancyTestCell {
    if ([self.pregnancy isEqual:@"positive"]) {
        [self.pregnancyCell setSelectedPregnancyTestType:PregnancyTestSelectionPositive];
        [self.pregnancyCell.pregnancyTypeCollapsedLabel setText:@"Positive"];
        [self.pregnancyCell.pregnancyTypeNegativeImageView setSelected:NO];
        [self.pregnancyCell.pregnancyTypePositiveImageView setSelected:YES];
        self.pregnancyCell.pregnancyTypeImageView.image = [UIImage imageNamed:@"icn_positive"];
    } else if([self.pregnancy isEqual:@"negative"]) { // negative
        [self.pregnancyCell setSelectedPregnancyTestType:PregnancyTestSelectionNegative];
        [self.pregnancyCell.pregnancyTypeCollapsedLabel setText:@"Negative"];
        [self.pregnancyCell.pregnancyTypeNegativeImageView setSelected:YES];
        [self.pregnancyCell.pregnancyTypePositiveImageView setSelected:NO];
        self.pregnancyCell.pregnancyTypeImageView.image = [UIImage imageNamed:@"icn_negative"];
    } else { // no selection
        [self.pregnancyCell setSelectedPregnancyTestType:PregnancyTestSelectionNone];
        [self.pregnancyCell.pregnancyTypeCollapsedLabel setText:@""];
        [self.pregnancyCell.pregnancyTypeNegativeImageView setSelected:NO];
        [self.pregnancyCell.pregnancyTypePositiveImageView setSelected:NO];
        self.pregnancyCell.imageView.hidden = YES;
    }
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
            } else { // not expanding
                if (TemperatureCellHasData) {
                    self.tempCell.temperatureValueLabel.hidden = NO;
                    self.tempCell.placeholderLabel.hidden = YES;
                    self.tempCell.collapsedLabel.hidden = NO;
                }
            }
            
            self.tempCell.layoutMargins = UIEdgeInsetsZero;
            
            [self.tempCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [self.tempCell setSelectedDate:self.selectedDate];
            
            self.tempCell.delegate = self;
            
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
                self.cfCell.cfTypeCollapsedLabel.hidden = YES;
                self.cfCell.cfTypeImageView.hidden = YES;
            } else { // not expanding
                if (CervicalFluidCellHasData) {
                    self.cfCell.cfTypeImageView.hidden = NO;
                    self.cfCell.cfTypeCollapsedLabel.hidden = NO;
                }
            }
            
            self.cfCell.layoutMargins = UIEdgeInsetsZero;
            [self.cfCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [self.cfCell setSelectedDate:self.selectedDate];
            
            self.cfCell.delegate = self;
            
            return self.cfCell;
            
            break;
        }
            
        case 3:
        {
            
            self.cpCell = [self.tableView dequeueReusableCellWithIdentifier:@"cpCell" forIndexPath:indexPath];
            
            // TODO: Finish custom cell implementation
            if (expandCervicalPositionCell) {
                self.cpCell.placeholderLabel.hidden = YES;
                
                self.cpCell.collapsedLabel.hidden = NO;
                self.cpCell.cpTypeCollapsedLabel.hidden = YES;
                self.cpCell.cpTypeImageView.hidden = YES;
                
                self.cpCell.highImageView.hidden = NO;
                self.cpCell.highLabel.hidden = NO;
                
                self.cpCell.lowImageView.hidden = NO;
                self.cpCell.lowLabel.hidden = NO;
            } else { // not expanding
                if (CervicalPositionCellHasData) {
                    self.cpCell.cpTypeImageView.hidden = NO;
                    self.cpCell.cpTypeCollapsedLabel.hidden = NO;
                }
            }
            
            [self.cpCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            self.cpCell.layoutMargins = UIEdgeInsetsZero;
            
            [self.cpCell setSelectedDate:self.selectedDate];
            
            self.cpCell.delegate = self;
            
            return self.cpCell;
            break;
        }
            
        case 4:
        {
            self.periodCell = [self.tableView dequeueReusableCellWithIdentifier:@"periodCell" forIndexPath:indexPath];
            
            if (expandPeriodCell) {
                self.periodCell.placeholderLabel.hidden = YES;
                
                self.periodCell.periodCollapsedLabel.hidden = NO;
                self.periodCell.periodTypeCollapsedLabel.hidden = YES;
                self.periodCell.periodTypeImageView.hidden = YES;
                
                // TODO: unhide buttons?
            } else { // unhide
                if (PeriodCellHasData) {
                    self.periodCell.periodTypeImageView.hidden = NO;
                    self.periodCell.periodTypeCollapsedLabel.hidden = NO;
                }
            }
            
            [self.periodCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            self.periodCell.layoutMargins = UIEdgeInsetsZero;
            
            [self.periodCell setSelectedDate:self.selectedDate];
            
            self.periodCell.delegate = self;
            
            return self.periodCell;
            break;
        }
            
        case 5: // intercourse
        {
            
            self.intercourseCell = [self.tableView dequeueReusableCellWithIdentifier:@"intercourseCell" forIndexPath:indexPath];
            
            
//             TODO: Finish custom cell implementation
            if (expandIntercourseCell) {
                // unhide component
                self.intercourseCell.placeholderLabel.hidden = YES;
                
                self.intercourseCell.intercourseCollapsedLabel.hidden = NO;
                self.intercourseCell.intercourseTypeCollapsedLabel.hidden = YES;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = YES;
                
//                self.intercourseCell.protectedImageView.hidden = NO;
//                self.intercourseCell.protectedLabel.hidden = NO;
//                
//                self.intercourseCell.unprotectedImageView.hidden = NO;
//                self.intercourseCell.unprotectedLabel.hidden = NO;
            } else {
                if (IntercourseCellHasData) {
                    self.intercourseCell.placeholderLabel.hidden = YES;
                    self.intercourseCell.intercourseCollapsedLabel.hidden = NO;
                    self.intercourseCell.intercourseTypeCollapsedImageView.hidden = NO;
                    self.intercourseCell.intercourseTypeCollapsedLabel.hidden = NO;
                }
                  else {
//                    self.intercourseCell.placeholderLabel.hidden = NO;
//                    self.intercourseCell.intercourseCollapsedLabel.hidden = YES;
//                    self.intercourseCell.intercourseTypeCollapsedImageView.hidden = YES;
//                    self.intercourseCell.intercourseTypeCollapsedLabel.hidden = YES;
                }
                
//                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = YES;
                
//                self.intercourseCell.protectedImageView.hidden = YES;
//                self.intercourseCell.protectedLabel.hidden = YES;
//                
//                self.intercourseCell.unprotectedImageView.hidden = YES;
//                self.intercourseCell.unprotectedLabel.hidden = YES;
            }
            
            [self.intercourseCell setSelectedDate:self.selectedDate];
            
            [self.intercourseCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            self.intercourseCell.layoutMargins = UIEdgeInsetsZero;
            
            self.intercourseCell.delegate = self;
            
            return self.intercourseCell;
            break;
        }
            
        case 6:
        {
            self.moodCell = [self.tableView dequeueReusableCellWithIdentifier:@"moodCell" forIndexPath:indexPath];
            
            // TODO: Finish custom cell implementation
            if (expandMoodCell) {
                // unhide component
                self.moodCell.moodPlaceholderLabel.hidden = YES;
                self.moodCell.moodCollapsedLabel.hidden = NO;
                self.moodCell.moodTypeLabel.hidden = YES;
                self.moodCell.moodTableView.hidden = NO;
            } else {
//                self.moodCell.moodPlaceholderLabel.hidden = NO;
//                self.moodCell.moodCollapsedLabel.hidden = YES;
//                self.moodCell.moodTableView.hidden = YES;
                
                if (MoodCellHasData) {
                    self.moodCell.moodTypeLabel.hidden = NO;
                    self.moodCell.moodPlaceholderLabel.hidden = YES;
                }
//                else {
//                    self.moodCell.moodTypeLabel.hidden = YES;
//                }
            }

            [self.moodCell setSelectedDate:self.selectedDate];
            
            [self.moodCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            self.moodCell.layoutMargins = UIEdgeInsetsZero;
            
            self.moodCell.delegate = self;
            
            return self.moodCell;
            break;
        }
            
        case 7:
        {
            self.symptomsCell = [self.tableView dequeueReusableCellWithIdentifier:@"symptomsCell" forIndexPath:indexPath];
            
            // TODO: Finish custom cell implementation
            if (expandSymptomsCell) {
            // unhide component
                self.symptomsCell.placeholderLabel.hidden = YES;
                self.symptomsCell.symptomsCollapsedLabel.hidden = NO;
                self.symptomsCell.symptomsTableView.hidden = NO;
                
                for (NSString *symptom in self.symptomIds) {
                    [self setSymptomWithValue:[symptom integerValue]];
                }
            } else {
                self.symptomsCell.placeholderLabel.hidden = NO;
                self.symptomsCell.symptomsCollapsedLabel.hidden = YES;
                self.symptomsCell.symptomsTableView.hidden = YES;
            }
            
            [self.symptomsCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [self.symptomsCell setSelectedDate:self.selectedDate];
            
            self.symptomsCell.delegate = self;
            
            return self.symptomsCell;
            break;
        }
            
        case 8:
        {
            
            self.ovulationCell = [self.tableView dequeueReusableCellWithIdentifier:@"ovulationCell" forIndexPath:indexPath];
            
            // TODO: Finish custom cell implementation
            if (expandOvulationTestCell) {
            // unhide component
                self.ovulationCell.placeholderLabel.hidden = YES;
                self.ovulationCell.ovulationCollapsedLabel.hidden = NO;
                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = YES;
                
                self.ovulationCell.ovulationTypePositiveImageView.hidden = NO;
                self.ovulationCell.ovulationTypePositiveLabel.hidden = NO;
                
                self.ovulationCell.ovulationTypeNegativeImageView.hidden = NO;
                self.ovulationCell.ovulationTypeNegativeLabel.hidden = NO;
            } else {
                self.ovulationCell.placeholderLabel.hidden = YES;
//                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = YES;
//                self.ovulationCell.ovulationCollapsedLabel.hidden = YES;
                
                self.ovulationCell.ovulationTypePositiveImageView.hidden = YES;
                self.ovulationCell.ovulationTypePositiveLabel.hidden = YES;
                
                self.ovulationCell.ovulationTypeNegativeImageView.hidden = YES;
                self.ovulationCell.ovulationTypeNegativeLabel.hidden = YES;
                
                if (OvulationTestCellHasData) {
                    self.ovulationCell.ovulationTypeImageView.hidden = NO;
                    self.ovulationCell.ovulationTypeCollapsedLabel.hidden = NO;
                    self.ovulationCell.ovulationCollapsedLabel.hidden = NO;
                }
            }
            
            [self.ovulationCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            self.ovulationCell.layoutMargins = UIEdgeInsetsZero;
            
            self.ovulationCell.delegate = self;
            
            [self.ovulationCell setSelectedDate:self.selectedDate];
            
            return self.ovulationCell;
            break;
        }
            
        case 9: // pregnancy test
        {
            self.pregnancyCell = [self.tableView dequeueReusableCellWithIdentifier:@"pregnancyCell" forIndexPath:indexPath];
            
            // TODO: Finish custom cell implementation
            if (expandPregnancyTestCell) {
                // unhide component
                self.pregnancyCell.placeholderLabel.hidden = YES;
                self.pregnancyCell.pregnancyCollapsedLabel.hidden = NO;
                
                self.pregnancyCell.pregnancyTypeNegativeImageView.hidden = NO;
                self.pregnancyCell.pregnancyTypeNegtaiveLabel.hidden = NO;
                
                self.pregnancyCell.pregnancyTypePositiveImageView.hidden = NO;
                self.pregnancyCell.pregnancyTypePositiveLabel.hidden = NO;
            } else {
//                self.pregnancyCell.placeholderLabel.hidden = NO;
//                self.pregnancyCell.pregnancyCollapsedLabel.hidden = YES;
                self.pregnancyCell.placeholderLabel.hidden = YES;
                
                self.pregnancyCell.pregnancyTypeNegativeImageView.hidden = YES;
                self.pregnancyCell.pregnancyTypeNegtaiveLabel.hidden = YES;
                
                self.pregnancyCell.pregnancyTypePositiveImageView.hidden = YES;
                self.pregnancyCell.pregnancyTypePositiveLabel.hidden = YES;
                
                if (PregnancyTestCellHasData) {
                    self.pregnancyCell.pregnancyTypeImageView.hidden = NO;
                    self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = NO;
                    self.pregnancyCell.pregnancyCollapsedLabel.hidden = NO;
                }
            }
            
            [self.pregnancyCell setSelectedDate:self.selectedDate];
            
            self.pregnancyCell.layoutMargins = UIEdgeInsetsZero;
            
            self.pregnancyCell.delegate = self;
            
            return self.pregnancyCell;
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
            
            if (indexPath.row == 1) {
                return 200.0f;
            } else if (indexPath.row == 6) {
                return 200.0f;
            } else {
                return 150.0f;
            }
        }
    }
    
    return 64.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedTableRowIndex = indexPath;
    
    switch (indexPath.row) {
        case 0:
        {
            // status cell, do nothing
            return;
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
                self.temperature = [NSNumber numberWithFloat:[self.tempCell.temperatureValueLabel.text floatValue]];
                firstOpenTemperatureCell = NO;
                TemperatureCellHasData = YES;
                
                // hit backend first time only from view controller
                [self postAndSaveTempWithTempValue:[self.temperature floatValue]];
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
                firstOpenCervicalFluidCell = NO;
            }
            break;
        }
            
        case 3:
        {
            if (currentState == TableStateCervicalPositionExpanded) {
                [self setTableStateForState:TableStateAllClosed];
            } else {
                [self setTableStateForState:TableStateCervicalPositionExpanded];
            }
            
            if (firstOpenCervicalPositionCell) {
                // no initial data until the user makes a selection
                firstOpenCervicalPositionCell = NO;
            }
            break;
        }
            
        case 4:
        {
            if (currentState == TableStatePeriodExpanded) {
                [self setTableStateForState:TableStateAllClosed];
            } else {
                [self setTableStateForState:TableStatePeriodExpanded];
            }
            
            if (firstOpenPeriodCell) {
                // no initial data until the user makes a selection
                firstOpenPeriodCell = NO;
            }
            
            break;
        }
            
        case 5:
        {
            if (currentState == TableStateIntercourseExpanded) {
                [self setTableStateForState:TableStateAllClosed];
            } else {
                [self setTableStateForState:TableStateIntercourseExpanded];
            }
            
            if (firstOpenIntercourseCell) {
                // no initial data until the user makes a selection
                firstOpenIntercourseCell = NO;
            }
            break;
        }
            
        case 6:
        {
            if (currentState == TableStateMoodExpanded) {
                [self setTableStateForState:TableStateAllClosed];
            } else {
                [self setTableStateForState:TableStateMoodExpanded];
            }
            
            if (firstOpenMoodCell) {
                // no initial data until the user makes a selection
                firstOpenMoodCell = NO;
            }
            break;
        }
            
        case 7:
        {
            if (currentState == TableStateSymptomsExpanded) {
                [self setTableStateForState:TableStateAllClosed];
            } else {
                [self setTableStateForState:TableStateSymptomsExpanded];
            }
            
            if (firstOpenSymptomsCell) {
                // no initial data until the user makes a selection
                firstOpenSymptomsCell = NO;
            }
            break;
        }
            
        case 8:
        {
            // TODO: ovulation test states, continue here
            if (currentState == TableStateOvulationTestExpanded) {
                [self setTableStateForState:TableStateAllClosed];
            } else {
                [self setTableStateForState:TableStateOvulationTestExpanded];
            }
            
            if (firstOpenOvulationTestCell) {
                // no initial data until the user makes a selection
                firstOpenOvulationTestCell = NO;
            }
            break;
        }
            
        case 9:
        {
            if (currentState == TableStatePregnancyTestExpanded) {
                [self setTableStateForState:TableStateAllClosed];
            } else {
                [self setTableStateForState:TableStatePregnancyTestExpanded];
            }
            
            if (firstOpenPregnancyTestCell) {
                // no initial data until the user makes a selection
                firstOpenPregnancyTestCell = NO;
            }
            break;
        }
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
    
    // record values outside of the swtich
    // that way, if the user closes the currently open cell by opening another one, the data is saved
    
    // record temp if we're opening another cell and closing the temp cell
    if (!expandTemperatureCell) {
        self.temperature = [NSNumber numberWithFloat:[self.tempCell.temperatureValueLabel.text floatValue]];
    }
    
    // record cf
    if (!expandCervicalFluidCell) {
        self.cervicalFluid = [self.cfCell.cfTypeCollapsedLabel.text lowercaseString];
    }
    
    if (!expandCervicalPositionCell) {
        self.cervicalPosition = [self.cpCell.cpTypeCollapsedLabel.text lowercaseString];
    }
    
    if (!expandPeriodCell) {
        self.period = [self.periodCell.periodTypeCollapsedLabel.text lowercaseString];
    }
    
    if (!expandIntercourseCell) {
        self.intercourse = [self.intercourseCell.intercourseTypeCollapsedLabel.text lowercaseString];
    }
    
    if (!expandOvulationTestCell) {
        self.ovulation = [self.ovulationCell.ovulationTypeCollapsedLabel.text lowercaseString];
    }
    
    if (!expandPregnancyTestCell) {
        self.pregnancy = [self.pregnancyCell.pregnancyTypeCollapsedLabel.text lowercaseString];
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
            self.tempCell.temperatureValueLabel.text = [NSString stringWithFormat:@"%.2f", [self.temperature floatValue]];
            break;
        }
            
            // TODO: Finish implementation for custom cells
        case 2:
        {
            if ([self.cfCell.cfTypeCollapsedLabel.text length] > 0) { // we have data
                CervicalFluidCellHasData = YES;
            } else {
                CervicalFluidCellHasData = NO;
            }
            if (CervicalFluidCellHasData) {
                self.cfCell.cfTypeCollapsedLabel.text = self.cervicalFluid;
            }
            break;
        }
            
        case 3:
        {
//            if (CervicalPositionCellHasData) {
//                self.cpCell.cpTypeCollapsedLabel.text = self.cervicalPosition;
//            }
            
            if ([self.cpCell.cpTypeCollapsedLabel.text length] > 0) { // we have data
                CervicalPositionCellHasData = YES;
            } else {
                CervicalPositionCellHasData = NO;
            }
            if (CervicalPositionCellHasData) {
                self.cpCell.cpTypeCollapsedLabel.text = self.cervicalPosition;
            }
            break;
        }
            
        case 4:
        {
            if (PeriodCellHasData) {
                self.periodCell.periodTypeCollapsedLabel.text = self.period;
//                self.periodCell.periodTypeImageView.hidden = NO;
            }
            break;
        }
            
        case 5:
        {
            if ([self.intercourseCell.intercourseTypeCollapsedLabel.text length] > 1) {
                IntercourseCellHasData = YES;
            } else {
                IntercourseCellHasData = NO;
            }
            if (IntercourseCellHasData) {
                self.intercourseCell.intercourseTypeCollapsedLabel.text = self.intercourse;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = NO;
            }
            break;
        }
            
        case 6:
        {
            if (MoodCellHasData) {
                // no collapsed labels to show
                self.moodCell.moodPlaceholderLabel.hidden = YES;
                self.moodCell.moodTypeLabel.hidden = NO;
                self.moodCell.moodCollapsedLabel.hidden = NO;
            }
            break;
        }
            
        case 7:
        {
            if (SymptomsCellHasData) {
                // no collapsed labels to show
                self.symptomsCell.placeholderLabel.hidden = NO;
            }
            break;
        }
            
        case 8:
        {
            if ([self.ovulationCell.ovulationTypeCollapsedLabel.text length] > 1) {
                OvulationTestCellHasData = YES;
            } else {
                OvulationTestCellHasData = NO;
            }
            
            if (OvulationTestCellHasData) {
                // no collapsed labels to show
//                self.ovulationCell.placeholderLabel.hidden = NO;
                self.ovulationCell.ovulationTypeCollapsedLabel.text = self.ovulation;
            }
            break;
        }
            
        case 9:
        {
            if ([self.pregnancyCell.pregnancyTypeCollapsedLabel.text length] > 1) {
                PregnancyTestCellHasData = YES;
            } else {
                PregnancyTestCellHasData = NO;
            }
            
            if (PregnancyTestCellHasData) {
                // no collapsed labels to show
                //                self.ovulationCell.placeholderLabel.hidden = NO;
                self.pregnancyCell.pregnancyTypeCollapsedLabel.text = self.pregnancy;
            }
            break;
        }
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
        self.tempCell.temperatureValueLabel.text = [NSString stringWithFormat:@"%.2f", [self.temperature floatValue]];
        
        // split string by .
        NSArray *tempChunks = [self.tempCell.temperatureValueLabel.text componentsSeparatedByString: @"."];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        int componentZeroSelection;
        int componenetOneSelection;
        
        if ([defaults boolForKey:@"temperatureUnitPreferenceFahrenheit"]) {
            componentZeroSelection = [tempChunks[0] intValue];
            componentZeroSelection -= 90;
            
            componenetOneSelection = [tempChunks[1] intValue];
            [self.tempCell.temperaturePicker selectRow:componentZeroSelection inComponent:0 animated:NO];
            [self.tempCell.temperaturePicker selectRow:componenetOneSelection inComponent:1 animated:NO];
        } else {
            componentZeroSelection = [tempChunks[0] intValue];
            componentZeroSelection -= 32;
            
            componenetOneSelection = [tempChunks[1] intValue];
            [self.tempCell.temperaturePicker selectRow:componentZeroSelection inComponent:0 animated:NO];
            [self.tempCell.temperaturePicker selectRow:componenetOneSelection inComponent:1 animated:NO];
        }

    }
    
    // TODO: Finish implementation for custom cells
    if (CervicalFluidCellHasData) {
        // TODO
//        self.cervicalFluid = [self.cfCell.cfTypeCollapsedLabel.text lowercaseString];
        [self setDataForCervicalFluidCell];
    }
    if (CervicalPositionCellHasData) {
        // TODO
//        self.cpCell.cpTypeCollapsedLabel.text = self.cervicalPosition;
        [self setDataForCervicalPositionCell];
    }
    
    if (PeriodCellHasData) {
        // TODO
//        self.period = [self.periodCell.periodTypeCollapsedLabel.text lowercaseString];
        [self setDataForPeriodCell];
    }
    
    if (IntercourseCellHasData) {
        // TODO
//        self.intercourse = [self.intercourseCell.intercourseTypeCollapsedLabel.text lowercaseString];
        [self setDataForIntercourseCell];
    }
    
    if (MoodCellHasData) {
        // TODO
    }
    if (SymptomsCellHasData) {
        // TODO
    }
    
    if (OvulationTestCellHasData) {
        // TODO
        [self setDataForOvulationTestCell];
    }
    
    if (PregnancyTestCellHasData) {
        // TODO
        [self setDataForPregnancyTestCell];
    }
    //    if (SupplementsCellHasData) {
    //        // TODO
    //    }
    //    if (MedicineCellHasData) {
    //        // TODO
    //    }
    
    [self setTableStateForState:currentState]; // make sure current state is set
    
    if (currentState == TableStateAllClosed) {
        [self refreshTrackingView]; // new info
    }
    
//    if (currentState == TableStateTemperatureExpanded) {
//        // fix picker
//        // split string by .
//        NSArray *tempChunks = [self.tempCell.temperatureValueLabel.text componentsSeparatedByString: @"."];
//        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        
//        if ([defaults boolForKey:@"temperatureUnitPreferenceFahrenheit"]) {
//            [self.tempCell.temperaturePicker selectRow:([tempChunks[0] intValue] - 90) inComponent:0 animated:NO];
//            [self.tempCell.temperaturePicker selectRow:[tempChunks[1] intValue] inComponent:0 animated:NO];
//        } else {
//            NSLog(@"%d, %d", [tempChunks[0] intValue], [tempChunks[1] intValue]);
//            
//            NSLog(@"%ld", (long)[self.tempCell.temperaturePicker selectedRowInComponent:0]);
//            NSLog(@"%ld", (long)[self.tempCell.temperaturePicker selectedRowInComponent:1]);
//            
//            [self.tempCell.temperaturePicker selectRow:([tempChunks[0] intValue] - 32) inComponent:0 animated:NO];
//            [self.tempCell.temperaturePicker selectRow:[tempChunks[1] intValue] inComponent:0 animated:NO];
//        }
//    }
//    
//    NSLog(@"%ld", (long)[self.tempCell.temperaturePicker selectedRowInComponent:0]);
//    NSLog(@"%ld", (long)[self.tempCell.temperaturePicker selectedRowInComponent:1]);
    
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
#pragma mark - TableStateAllClosed
        case TableStateAllClosed:
        {
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            
            if (TemperatureCellHasData) {
                self.tempCell.placeholderLabel.hidden = YES;
                self.tempCell.collapsedLabel.hidden = NO;
                self.tempCell.temperatureValueLabel.hidden = NO;
            } else {
                self.tempCell.placeholderLabel.hidden = NO;
                self.tempCell.collapsedLabel.hidden = YES;
                self.tempCell.temperatureValueLabel.hidden = YES;
            }
            
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
            self.cpCell.highImageView.hidden = YES;
            self.cpCell.highLabel.hidden = YES;
            
            self.cpCell.lowImageView.hidden = YES;
            self.cpCell.lowLabel.hidden = YES;
            
            if (CervicalPositionCellHasData) {
                self.cpCell.placeholderLabel.hidden = YES;
                self.cpCell.collapsedLabel.hidden = NO;
                self.cpCell.cpTypeImageView.hidden = NO;
                self.cpCell.cpTypeCollapsedLabel.hidden = NO;
            } else {
                self.cpCell.placeholderLabel.hidden = NO;
                self.cpCell.collapsedLabel.hidden = YES;
                self.cpCell.cpTypeImageView.hidden = YES;
                self.cpCell.cpTypeCollapsedLabel.hidden = YES;
            }
            
            expandPeriodCell = NO;
            // hide component
            self.periodCell.noneImageView.hidden = YES;
            self.periodCell.noneLabel.hidden = YES;
            
            self.periodCell.spottingImageView.hidden = YES;
            self.periodCell.spottingLabel.hidden = YES;
            
            self.periodCell.lightImageView.hidden = YES;
            self.periodCell.lightLabel.hidden = YES;
            
            self.periodCell.mediumImageView.hidden = YES;
            self.periodCell.mediumLabel.hidden = YES;
            
            self.periodCell.heavyImageView.hidden = YES;
            self.periodCell.heavyLabel.hidden = YES;
            
            if (PeriodCellHasData) {
                self.periodCell.placeholderLabel.hidden = YES;
                self.periodCell.periodCollapsedLabel.hidden = NO;
                self.periodCell.periodTypeCollapsedLabel.hidden = NO;
                self.periodCell.periodTypeImageView.hidden = NO;
            } else {
                self.periodCell.placeholderLabel.hidden = NO;
                self.periodCell.periodCollapsedLabel.hidden = YES;
                self.periodCell.periodTypeCollapsedLabel.hidden = YES;
                self.periodCell.periodTypeImageView.hidden = YES;
            }
            
            expandIntercourseCell = NO;
            // hide component
            self.intercourseCell.protectedImageView.hidden = YES;
            self.intercourseCell.protectedLabel.hidden = YES;
            
            self.intercourseCell.unprotectedImageView.hidden = YES;
            self.intercourseCell.unprotectedLabel.hidden = YES;

            if (IntercourseCellHasData) {
                self.intercourseCell.placeholderLabel.hidden = YES;
                self.intercourseCell.intercourseCollapsedLabel.hidden = NO;
                self.intercourseCell.intercourseTypeCollapsedLabel.hidden = NO;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = NO;
            } else {
                self.intercourseCell.placeholderLabel.hidden = NO;
                self.intercourseCell.intercourseCollapsedLabel.hidden = YES;
                self.intercourseCell.intercourseTypeCollapsedLabel.hidden = YES;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = YES;
            }
            
            expandMoodCell = NO;
            // hide component
            self.moodCell.moodTableView.hidden = YES;
            
            if (MoodCellHasData) {
                self.moodCell.moodPlaceholderLabel.hidden = YES;
                self.moodCell.moodCollapsedLabel.hidden = NO;
                self.moodCell.moodTypeLabel.hidden = NO;
            } else {
                self.moodCell.moodPlaceholderLabel.hidden = NO;
                self.moodCell.moodCollapsedLabel.hidden = YES;
                self.moodCell.moodTypeLabel.hidden = YES;
            }
            
            expandSymptomsCell = NO;
            // hide component
            self.symptomsCell.symptomsTableView.hidden = YES;
            
            expandOvulationTestCell = NO;
            // hide component
            self.ovulationCell.ovulationTypeNegativeImageView.hidden = YES;
            self.ovulationCell.ovulationTypeNegativeLabel.hidden = YES;
            
            self.ovulationCell.ovulationTypePositiveImageView.hidden = YES;
            self.ovulationCell.ovulationTypePositiveLabel.hidden = YES;
            
            if (OvulationTestCellHasData) {
                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = NO;
                self.ovulationCell.ovulationCollapsedLabel.hidden = NO;
                self.ovulationCell.ovulationTypeImageView.hidden = NO;
                self.ovulationCell.placeholderLabel.hidden = YES;
            } else {
                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = YES;
                self.ovulationCell.ovulationCollapsedLabel.hidden = YES;
                self.ovulationCell.ovulationTypeImageView.hidden = YES;
                self.ovulationCell.placeholderLabel.hidden = NO;
            }
            
            expandPregnancyTestCell = NO;
            // hide component
            self.pregnancyCell.pregnancyTypeNegativeImageView.hidden = YES;
            self.pregnancyCell.pregnancyTypeNegtaiveLabel.hidden = YES;
            
            self.pregnancyCell.pregnancyTypePositiveImageView.hidden = YES;
            self.pregnancyCell.pregnancyTypePositiveLabel.hidden = YES;
            
            if (PregnancyTestCellHasData) {
                self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = NO;
                self.pregnancyCell.pregnancyCollapsedLabel.hidden = NO;
                self.pregnancyCell.pregnancyTypeImageView.hidden = NO;
                self.pregnancyCell.placeholderLabel.hidden = YES;
            } else {
                self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = YES;
                self.pregnancyCell.pregnancyCollapsedLabel.hidden = YES;
                self.pregnancyCell.pregnancyTypeImageView.hidden = YES;
                self.pregnancyCell.placeholderLabel.hidden = NO;
            }
            
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStateAllClosed;
            break;
        }
            
#pragma mark - TableStateTemperatureExpanded
        case TableStateTemperatureExpanded:
        {
            expandTemperatureCell = YES;
            self.tempCell.temperaturePicker.hidden = NO;
            self.tempCell.temperatureValueLabel.hidden = NO;
            self.tempCell.placeholderLabel.hidden = YES;
            self.tempCell.collapsedLabel.hidden = NO;
            
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
            self.cpCell.highImageView.hidden = YES;
            self.cpCell.highLabel.hidden = YES;
            
            self.cpCell.lowImageView.hidden = YES;
            self.cpCell.lowLabel.hidden = YES;
            
            if (CervicalPositionCellHasData) {
                self.cpCell.placeholderLabel.hidden = YES;
                self.cpCell.collapsedLabel.hidden = NO;
                self.cpCell.cpTypeImageView.hidden = NO;
                self.cpCell.cpTypeCollapsedLabel.hidden = NO;
            } else {
                self.cpCell.placeholderLabel.hidden = NO;
                self.cpCell.collapsedLabel.hidden = YES;
                self.cpCell.cpTypeImageView.hidden = YES;
                self.cpCell.cpTypeCollapsedLabel.hidden = YES;
            }
            
            expandPeriodCell = NO;
            // hide component
            self.periodCell.noneImageView.hidden = YES;
            self.periodCell.noneLabel.hidden = YES;
            
            self.periodCell.spottingImageView.hidden = YES;
            self.periodCell.spottingLabel.hidden = YES;
            
            self.periodCell.lightImageView.hidden = YES;
            self.periodCell.lightLabel.hidden = YES;
            
            self.periodCell.mediumImageView.hidden = YES;
            self.periodCell.mediumLabel.hidden = YES;
            
            self.periodCell.heavyImageView.hidden = YES;
            self.periodCell.heavyLabel.hidden = YES;
            
            if (PeriodCellHasData) {
                self.periodCell.placeholderLabel.hidden = YES;
                self.periodCell.periodCollapsedLabel.hidden = NO;
                self.periodCell.periodTypeCollapsedLabel.hidden = NO;
                self.periodCell.periodTypeImageView.hidden = NO;
            } else {
                self.periodCell.placeholderLabel.hidden = NO;
                self.periodCell.periodCollapsedLabel.hidden = YES;
                self.periodCell.periodTypeCollapsedLabel.hidden = YES;
                self.periodCell.periodTypeImageView.hidden = YES;
            }
            
            expandIntercourseCell = NO;
            // hide component
            self.intercourseCell.protectedImageView.hidden = YES;
            self.intercourseCell.protectedLabel.hidden = YES;
            
            self.intercourseCell.unprotectedImageView.hidden = YES;
            self.intercourseCell.unprotectedLabel.hidden = YES;
            
            if (IntercourseCellHasData) {
                self.intercourseCell.placeholderLabel.hidden = YES;
                self.intercourseCell.intercourseCollapsedLabel.hidden = NO;
                self.intercourseCell.intercourseTypeCollapsedLabel.hidden = NO;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = NO;
            } else {
                self.intercourseCell.placeholderLabel.hidden = NO;
                self.intercourseCell.intercourseCollapsedLabel.hidden = YES;
                self.intercourseCell.intercourseTypeCollapsedLabel.hidden = YES;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = YES;
            }
            
            expandMoodCell = NO;
            // hide component
            self.moodCell.moodTableView.hidden = YES;
            
            if (MoodCellHasData) {
                self.moodCell.moodPlaceholderLabel.hidden = YES;
                self.moodCell.moodCollapsedLabel.hidden = NO;
                self.moodCell.moodTypeLabel.hidden = NO;
            } else {
                self.moodCell.moodPlaceholderLabel.hidden = NO;
                self.moodCell.moodCollapsedLabel.hidden = YES;
                self.moodCell.moodTypeLabel.hidden = YES;
            }
            
            expandSymptomsCell = NO;
            // hide component
            self.symptomsCell.symptomsTableView.hidden = YES;
            
            expandSymptomsCell = NO;
            // hide component
            self.symptomsCell.symptomsTableView.hidden = YES;
            
            expandOvulationTestCell = NO;
            // hide component
            self.ovulationCell.ovulationTypeNegativeImageView.hidden = YES;
            self.ovulationCell.ovulationTypeNegativeLabel.hidden = YES;
            
            self.ovulationCell.ovulationTypePositiveImageView.hidden = YES;
            self.ovulationCell.ovulationTypePositiveLabel.hidden = YES;
            
            if (OvulationTestCellHasData) {
                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = NO;
                self.ovulationCell.ovulationCollapsedLabel.hidden = NO;
                self.ovulationCell.ovulationTypeImageView.hidden = NO;
                self.ovulationCell.placeholderLabel.hidden = YES;
            } else {
                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = YES;
                self.ovulationCell.ovulationCollapsedLabel.hidden = YES;
                self.ovulationCell.ovulationTypeImageView.hidden = YES;
                self.ovulationCell.placeholderLabel.hidden = NO;
            }
            
            expandPregnancyTestCell = NO;
            // hide component
            self.pregnancyCell.pregnancyTypeNegativeImageView.hidden = YES;
            self.pregnancyCell.pregnancyTypeNegtaiveLabel.hidden = YES;
            
            self.pregnancyCell.pregnancyTypePositiveImageView.hidden = YES;
            self.pregnancyCell.pregnancyTypePositiveLabel.hidden = YES;
            
            if (PregnancyTestCellHasData) {
                self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = NO;
                self.pregnancyCell.pregnancyCollapsedLabel.hidden = NO;
                self.pregnancyCell.pregnancyTypeImageView.hidden = NO;
                self.pregnancyCell.placeholderLabel.hidden = YES;
            } else {
                self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = YES;
                self.pregnancyCell.pregnancyCollapsedLabel.hidden = YES;
                self.pregnancyCell.pregnancyTypeImageView.hidden = YES;
                self.pregnancyCell.placeholderLabel.hidden = NO;
            }
            
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStateTemperatureExpanded;
            break;
        }
            
#pragma mark - Cervical Fluid
        case TableStateCervicalFluidExpanded:
        {
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            
            if (TemperatureCellHasData) {
                self.tempCell.placeholderLabel.hidden = YES;
                self.tempCell.collapsedLabel.hidden = NO;
                self.tempCell.temperatureValueLabel.hidden = NO;
            } else {
                self.tempCell.placeholderLabel.hidden = NO;
                self.tempCell.collapsedLabel.hidden = YES;
                self.tempCell.temperatureValueLabel.hidden = YES;
            }
            
            expandCervicalFluidCell = YES;
            // unhide cervical fluid component
            
            expandCervicalPositionCell = NO;
            // hide cervical position component
            self.cpCell.highImageView.hidden = YES;
            self.cpCell.highLabel.hidden = YES;
            
            self.cpCell.lowImageView.hidden = YES;
            self.cpCell.lowLabel.hidden = YES;
            
            if (CervicalPositionCellHasData) {
                self.cpCell.placeholderLabel.hidden = YES;
                self.cpCell.collapsedLabel.hidden = NO;
                self.cpCell.cpTypeImageView.hidden = NO;
                self.cpCell.cpTypeCollapsedLabel.hidden = NO;
            } else {
                self.cpCell.placeholderLabel.hidden = NO;
                self.cpCell.collapsedLabel.hidden = YES;
                self.cpCell.cpTypeImageView.hidden = YES;
                self.cpCell.cpTypeCollapsedLabel.hidden = YES;
            }
            
            expandPeriodCell = NO;
            // hide component
            self.periodCell.noneImageView.hidden = YES;
            self.periodCell.noneLabel.hidden = YES;
            
            self.periodCell.spottingImageView.hidden = YES;
            self.periodCell.spottingLabel.hidden = YES;
            
            self.periodCell.lightImageView.hidden = YES;
            self.periodCell.lightLabel.hidden = YES;
            
            self.periodCell.mediumImageView.hidden = YES;
            self.periodCell.mediumLabel.hidden = YES;
            
            self.periodCell.heavyImageView.hidden = YES;
            self.periodCell.heavyLabel.hidden = YES;
            
            if (PeriodCellHasData) {
                self.periodCell.placeholderLabel.hidden = YES;
                self.periodCell.periodCollapsedLabel.hidden = NO;
                self.periodCell.periodTypeCollapsedLabel.hidden = NO;
                self.periodCell.periodTypeImageView.hidden = NO;
            } else {
                self.periodCell.placeholderLabel.hidden = NO;
                self.periodCell.periodCollapsedLabel.hidden = YES;
                self.periodCell.periodTypeCollapsedLabel.hidden = YES;
                self.periodCell.periodTypeImageView.hidden = YES;
            }
            
            expandIntercourseCell = NO;
            // hide component
            self.intercourseCell.protectedImageView.hidden = YES;
            self.intercourseCell.protectedLabel.hidden = YES;
            
            self.intercourseCell.unprotectedImageView.hidden = YES;
            self.intercourseCell.unprotectedLabel.hidden = YES;
            
            if (IntercourseCellHasData) {
                self.intercourseCell.placeholderLabel.hidden = YES;
                self.intercourseCell.intercourseCollapsedLabel.hidden = NO;
                self.intercourseCell.intercourseTypeCollapsedLabel.hidden = NO;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = NO;
            } else {
                self.intercourseCell.placeholderLabel.hidden = NO;
                self.intercourseCell.intercourseCollapsedLabel.hidden = YES;
                self.intercourseCell.intercourseTypeCollapsedLabel.hidden = YES;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = YES;
            }
            
            expandMoodCell = NO;
            // hide component
            self.moodCell.moodTableView.hidden = YES;
            
            if (MoodCellHasData) {
                self.moodCell.moodPlaceholderLabel.hidden = YES;
                self.moodCell.moodCollapsedLabel.hidden = NO;
                self.moodCell.moodTypeLabel.hidden = NO;
            } else {
                self.moodCell.moodPlaceholderLabel.hidden = NO;
                self.moodCell.moodCollapsedLabel.hidden = YES;
                self.moodCell.moodTypeLabel.hidden = YES;
            }
            
            expandSymptomsCell = NO;
            // hide component
            self.symptomsCell.symptomsTableView.hidden = YES;
            
            expandSymptomsCell = NO;
            // hide component
            self.symptomsCell.symptomsTableView.hidden = YES;
            
            expandOvulationTestCell = NO;
            // hide component
            self.ovulationCell.ovulationTypeNegativeImageView.hidden = YES;
            self.ovulationCell.ovulationTypeNegativeLabel.hidden = YES;
            
            self.ovulationCell.ovulationTypePositiveImageView.hidden = YES;
            self.ovulationCell.ovulationTypePositiveLabel.hidden = YES;
            
            if (OvulationTestCellHasData) {
                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = NO;
                self.ovulationCell.ovulationCollapsedLabel.hidden = NO;
                self.ovulationCell.ovulationTypeImageView.hidden = NO;
                self.ovulationCell.placeholderLabel.hidden = YES;
            } else {
                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = YES;
                self.ovulationCell.ovulationCollapsedLabel.hidden = YES;
                self.ovulationCell.ovulationTypeImageView.hidden = YES;
                self.ovulationCell.placeholderLabel.hidden = NO;
            }
            
            expandPregnancyTestCell = NO;
            // hide component
            self.pregnancyCell.pregnancyTypeNegativeImageView.hidden = YES;
            self.pregnancyCell.pregnancyTypeNegtaiveLabel.hidden = YES;
            
            self.pregnancyCell.pregnancyTypePositiveImageView.hidden = YES;
            self.pregnancyCell.pregnancyTypePositiveLabel.hidden = YES;
            
            if (PregnancyTestCellHasData) {
                self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = NO;
                self.pregnancyCell.pregnancyCollapsedLabel.hidden = NO;
                self.pregnancyCell.pregnancyTypeImageView.hidden = NO;
                self.pregnancyCell.placeholderLabel.hidden = YES;
            } else {
                self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = YES;
                self.pregnancyCell.pregnancyCollapsedLabel.hidden = YES;
                self.pregnancyCell.pregnancyTypeImageView.hidden = YES;
                self.pregnancyCell.placeholderLabel.hidden = NO;
            }
            
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStateCervicalFluidExpanded;
            break;
        }
            
#pragma mark - Cervical Position
        case TableStateCervicalPositionExpanded:
        {
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            
            if (TemperatureCellHasData) {
                self.tempCell.placeholderLabel.hidden = YES;
                self.tempCell.collapsedLabel.hidden = NO;
                self.tempCell.temperatureValueLabel.hidden = NO;
            } else {
                self.tempCell.placeholderLabel.hidden = NO;
                self.tempCell.collapsedLabel.hidden = YES;
                self.tempCell.temperatureValueLabel.hidden = YES;
            }
            
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
            
            expandCervicalPositionCell = YES;
            self.cpCell.placeholderLabel.hidden = YES;
            
            self.cpCell.collapsedLabel.hidden = NO;
            self.cpCell.cpTypeCollapsedLabel.hidden = YES;
            self.cpCell.cpTypeImageView.hidden = YES;
            
            self.cpCell.highImageView.hidden = NO;
            self.cpCell.highLabel.hidden = NO;
            
            self.cpCell.lowImageView.hidden = NO;
            self.cpCell.lowLabel.hidden = NO;
            
            expandPeriodCell = NO;
            // hide component
            self.periodCell.noneImageView.hidden = YES;
            self.periodCell.noneLabel.hidden = YES;
            
            self.periodCell.spottingImageView.hidden = YES;
            self.periodCell.spottingLabel.hidden = YES;
            
            self.periodCell.lightImageView.hidden = YES;
            self.periodCell.lightLabel.hidden = YES;
            
            self.periodCell.mediumImageView.hidden = YES;
            self.periodCell.mediumLabel.hidden = YES;
            
            self.periodCell.heavyImageView.hidden = YES;
            self.periodCell.heavyLabel.hidden = YES;
            
            if (PeriodCellHasData) {
                self.periodCell.placeholderLabel.hidden = YES;
                self.periodCell.periodCollapsedLabel.hidden = NO;
                self.periodCell.periodTypeCollapsedLabel.hidden = NO;
                self.periodCell.periodTypeImageView.hidden = NO;
            } else {
                self.periodCell.placeholderLabel.hidden = NO;
                self.periodCell.periodCollapsedLabel.hidden = YES;
                self.periodCell.periodTypeCollapsedLabel.hidden = YES;
                self.periodCell.periodTypeImageView.hidden = YES;
            }
            
            expandIntercourseCell = NO;
            // hide component
            self.intercourseCell.protectedImageView.hidden = YES;
            self.intercourseCell.protectedLabel.hidden = YES;
            
            self.intercourseCell.unprotectedImageView.hidden = YES;
            self.intercourseCell.unprotectedLabel.hidden = YES;
            
            if (IntercourseCellHasData) {
                self.intercourseCell.placeholderLabel.hidden = YES;
                self.intercourseCell.intercourseCollapsedLabel.hidden = NO;
                self.intercourseCell.intercourseTypeCollapsedLabel.hidden = NO;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = NO;
            } else {
                self.intercourseCell.placeholderLabel.hidden = NO;
                self.intercourseCell.intercourseCollapsedLabel.hidden = YES;
                self.intercourseCell.intercourseTypeCollapsedLabel.hidden = YES;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = YES;
            }
            
            expandMoodCell = NO;
            // hide component
            self.moodCell.moodTableView.hidden = YES;
            
            if (MoodCellHasData) {
                self.moodCell.moodPlaceholderLabel.hidden = YES;
                self.moodCell.moodCollapsedLabel.hidden = NO;
                self.moodCell.moodTypeLabel.hidden = NO;
            } else {
                self.moodCell.moodPlaceholderLabel.hidden = NO;
                self.moodCell.moodCollapsedLabel.hidden = YES;
                self.moodCell.moodTypeLabel.hidden = YES;
            }
            
            expandSymptomsCell = NO;
            // hide component
            self.symptomsCell.symptomsTableView.hidden = YES;
            
            expandSymptomsCell = NO;
            // hide component
            self.symptomsCell.symptomsTableView.hidden = YES;
            
            expandOvulationTestCell = NO;
            // hide component
            self.ovulationCell.ovulationTypeNegativeImageView.hidden = YES;
            self.ovulationCell.ovulationTypeNegativeLabel.hidden = YES;
            
            self.ovulationCell.ovulationTypePositiveImageView.hidden = YES;
            self.ovulationCell.ovulationTypePositiveLabel.hidden = YES;
            
            if (OvulationTestCellHasData) {
                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = NO;
                self.ovulationCell.ovulationCollapsedLabel.hidden = NO;
                self.ovulationCell.ovulationTypeImageView.hidden = NO;
                self.ovulationCell.placeholderLabel.hidden = YES;
            } else {
                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = YES;
                self.ovulationCell.ovulationCollapsedLabel.hidden = YES;
                self.ovulationCell.ovulationTypeImageView.hidden = YES;
                self.ovulationCell.placeholderLabel.hidden = NO;
            }
            
            expandPregnancyTestCell = NO;
            // hide component
            self.pregnancyCell.pregnancyTypeNegativeImageView.hidden = YES;
            self.pregnancyCell.pregnancyTypeNegtaiveLabel.hidden = YES;
            
            self.pregnancyCell.pregnancyTypePositiveImageView.hidden = YES;
            self.pregnancyCell.pregnancyTypePositiveLabel.hidden = YES;
            
            if (PregnancyTestCellHasData) {
                self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = NO;
                self.pregnancyCell.pregnancyCollapsedLabel.hidden = NO;
                self.pregnancyCell.pregnancyTypeImageView.hidden = NO;
                self.pregnancyCell.placeholderLabel.hidden = YES;
            } else {
                self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = YES;
                self.pregnancyCell.pregnancyCollapsedLabel.hidden = YES;
                self.pregnancyCell.pregnancyTypeImageView.hidden = YES;
                self.pregnancyCell.placeholderLabel.hidden = NO;
            }
            
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStateCervicalPositionExpanded;
            break;
        }
            
#pragma mark - Period
        case TableStatePeriodExpanded:
        {
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            
            if (TemperatureCellHasData) {
                self.tempCell.placeholderLabel.hidden = YES;
                self.tempCell.collapsedLabel.hidden = NO;
                self.tempCell.temperatureValueLabel.hidden = NO;
            } else {
                self.tempCell.placeholderLabel.hidden = NO;
                self.tempCell.collapsedLabel.hidden = YES;
                self.tempCell.temperatureValueLabel.hidden = YES;
            }
            
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
            self.cpCell.highImageView.hidden = YES;
            self.cpCell.highLabel.hidden = YES;
            
            self.cpCell.lowImageView.hidden = YES;
            self.cpCell.lowLabel.hidden = YES;
            
            if (CervicalPositionCellHasData) {
                self.cpCell.placeholderLabel.hidden = YES;
                self.cpCell.collapsedLabel.hidden = NO;
                self.cpCell.cpTypeImageView.hidden = NO;
                self.cpCell.cpTypeCollapsedLabel.hidden = NO;
            } else {
                self.cpCell.placeholderLabel.hidden = NO;
                self.cpCell.collapsedLabel.hidden = YES;
                self.cpCell.cpTypeImageView.hidden = YES;
                self.cpCell.cpTypeCollapsedLabel.hidden = YES;
            }
            
            expandPeriodCell = YES;
            // unhide component
            self.periodCell.placeholderLabel.hidden = YES;
            self.periodCell.periodCollapsedLabel.hidden = NO;
            self.periodCell.periodTypeCollapsedLabel.hidden = YES;
            self.periodCell.periodTypeImageView.hidden = YES;
            
            // unhide buttons
            self.periodCell.noneImageView.hidden = NO;
            self.periodCell.noneLabel.hidden = NO;
            
            self.periodCell.spottingImageView.hidden = NO;
            self.periodCell.spottingLabel.hidden = NO;
            
            self.periodCell.lightImageView.hidden = NO;
            self.periodCell.lightLabel.hidden = NO;
            
            self.periodCell.mediumImageView.hidden = NO;
            self.periodCell.mediumLabel.hidden = NO;
            
            self.periodCell.heavyImageView.hidden = NO;
            self.periodCell.heavyLabel.hidden = NO;
            
            expandIntercourseCell = NO;
            // hide component
            self.intercourseCell.protectedImageView.hidden = YES;
            self.intercourseCell.protectedLabel.hidden = YES;
            
            self.intercourseCell.unprotectedImageView.hidden = YES;
            self.intercourseCell.unprotectedLabel.hidden = YES;
            
            if (IntercourseCellHasData) {
                self.intercourseCell.placeholderLabel.hidden = YES;
                self.intercourseCell.intercourseCollapsedLabel.hidden = NO;
                self.intercourseCell.intercourseTypeCollapsedLabel.hidden = NO;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = NO;
            } else {
                self.intercourseCell.placeholderLabel.hidden = NO;
                self.intercourseCell.intercourseCollapsedLabel.hidden = YES;
                self.intercourseCell.intercourseTypeCollapsedLabel.hidden = YES;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = YES;
            }
            
            expandMoodCell = NO;
            // hide component
            self.moodCell.moodTableView.hidden = YES;
            
            if (MoodCellHasData) {
                self.moodCell.moodPlaceholderLabel.hidden = YES;
                self.moodCell.moodCollapsedLabel.hidden = NO;
                self.moodCell.moodTypeLabel.hidden = NO;
            } else {
                self.moodCell.moodPlaceholderLabel.hidden = NO;
                self.moodCell.moodCollapsedLabel.hidden = YES;
                self.moodCell.moodTypeLabel.hidden = YES;
            }
            
            expandSymptomsCell = NO;
            // hide component
            self.symptomsCell.symptomsTableView.hidden = YES;
            
            expandSymptomsCell = NO;
            // hide component
            self.symptomsCell.symptomsTableView.hidden = YES;
            
            expandOvulationTestCell = NO;
            // hide component
            self.ovulationCell.ovulationTypeNegativeImageView.hidden = YES;
            self.ovulationCell.ovulationTypeNegativeLabel.hidden = YES;
            
            self.ovulationCell.ovulationTypePositiveImageView.hidden = YES;
            self.ovulationCell.ovulationTypePositiveLabel.hidden = YES;
            
            if (OvulationTestCellHasData) {
                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = NO;
                self.ovulationCell.ovulationCollapsedLabel.hidden = NO;
                self.ovulationCell.ovulationTypeImageView.hidden = NO;
                self.ovulationCell.placeholderLabel.hidden = YES;
            } else {
                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = YES;
                self.ovulationCell.ovulationCollapsedLabel.hidden = YES;
                self.ovulationCell.ovulationTypeImageView.hidden = YES;
                self.ovulationCell.placeholderLabel.hidden = NO;
            }
            
            expandPregnancyTestCell = NO;
            // hide component
            self.pregnancyCell.pregnancyTypeNegativeImageView.hidden = YES;
            self.pregnancyCell.pregnancyTypeNegtaiveLabel.hidden = YES;
            
            self.pregnancyCell.pregnancyTypePositiveImageView.hidden = YES;
            self.pregnancyCell.pregnancyTypePositiveLabel.hidden = YES;
            
            if (PregnancyTestCellHasData) {
                self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = NO;
                self.pregnancyCell.pregnancyCollapsedLabel.hidden = NO;
                self.pregnancyCell.pregnancyTypeImageView.hidden = NO;
                self.pregnancyCell.placeholderLabel.hidden = YES;
            } else {
                self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = YES;
                self.pregnancyCell.pregnancyCollapsedLabel.hidden = YES;
                self.pregnancyCell.pregnancyTypeImageView.hidden = YES;
                self.pregnancyCell.placeholderLabel.hidden = NO;
            }
            
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStatePeriodExpanded;
            break;
        }
            
#pragma mark - Intercourse
        case TableStateIntercourseExpanded:
        {
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            
            if (TemperatureCellHasData) {
                self.tempCell.placeholderLabel.hidden = YES;
                self.tempCell.collapsedLabel.hidden = NO;
                self.tempCell.temperatureValueLabel.hidden = NO;
            } else {
                self.tempCell.placeholderLabel.hidden = NO;
                self.tempCell.collapsedLabel.hidden = YES;
                self.tempCell.temperatureValueLabel.hidden = YES;
            }
            
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
            self.cpCell.highImageView.hidden = YES;
            self.cpCell.highLabel.hidden = YES;
            
            self.cpCell.lowImageView.hidden = YES;
            self.cpCell.lowLabel.hidden = YES;
            
            if (CervicalPositionCellHasData) {
                self.cpCell.placeholderLabel.hidden = YES;
                self.cpCell.collapsedLabel.hidden = NO;
                self.cpCell.cpTypeImageView.hidden = NO;
                self.cpCell.cpTypeCollapsedLabel.hidden = NO;
            } else {
                self.cpCell.placeholderLabel.hidden = NO;
                self.cpCell.collapsedLabel.hidden = YES;
                self.cpCell.cpTypeImageView.hidden = YES;
                self.cpCell.cpTypeCollapsedLabel.hidden = YES;
            }
            
            expandPeriodCell = NO;
            // hide component
            self.periodCell.noneImageView.hidden = YES;
            self.periodCell.noneLabel.hidden = YES;
            
            self.periodCell.spottingImageView.hidden = YES;
            self.periodCell.spottingLabel.hidden = YES;
            
            self.periodCell.lightImageView.hidden = YES;
            self.periodCell.lightLabel.hidden = YES;
            
            self.periodCell.mediumImageView.hidden = YES;
            self.periodCell.mediumLabel.hidden = YES;
            
            self.periodCell.heavyImageView.hidden = YES;
            self.periodCell.heavyLabel.hidden = YES;
            
            if (PeriodCellHasData) {
                self.periodCell.placeholderLabel.hidden = YES;
                self.periodCell.periodCollapsedLabel.hidden = NO;
                self.periodCell.periodTypeCollapsedLabel.hidden = NO;
                self.periodCell.periodTypeImageView.hidden = NO;
            } else {
                self.periodCell.placeholderLabel.hidden = NO;
                self.periodCell.periodCollapsedLabel.hidden = YES;
                self.periodCell.periodTypeCollapsedLabel.hidden = YES;
                self.periodCell.periodTypeImageView.hidden = YES;
            }
            
            expandIntercourseCell = YES;
            // unhide component
            self.intercourseCell.placeholderLabel.hidden = YES;
            
            self.intercourseCell.intercourseCollapsedLabel.hidden = NO;
            self.intercourseCell.intercourseTypeCollapsedLabel.hidden = YES;
            self.intercourseCell.intercourseTypeCollapsedImageView.hidden = YES;
            
            self.intercourseCell.unprotectedImageView.hidden = NO;
            self.intercourseCell.unprotectedLabel.hidden = NO;
            
            self.intercourseCell.protectedImageView.hidden = NO;
            self.intercourseCell.protectedLabel.hidden = NO;
            
            expandMoodCell = NO;
            // hide component
            self.moodCell.moodTableView.hidden = YES;
            
            if (MoodCellHasData) {
                self.moodCell.moodPlaceholderLabel.hidden = YES;
                self.moodCell.moodCollapsedLabel.hidden = NO;
                self.moodCell.moodTypeLabel.hidden = NO;
            } else {
                self.moodCell.moodPlaceholderLabel.hidden = NO;
                self.moodCell.moodCollapsedLabel.hidden = YES;
                self.moodCell.moodTypeLabel.hidden = YES;
            }
            
            expandSymptomsCell = NO;
            // hide component
            self.symptomsCell.symptomsTableView.hidden = YES;
            
            expandSymptomsCell = NO;
            // hide component
            self.symptomsCell.symptomsTableView.hidden = YES;
            
            expandOvulationTestCell = NO;
            // hide component
            self.ovulationCell.ovulationTypeNegativeImageView.hidden = YES;
            self.ovulationCell.ovulationTypeNegativeLabel.hidden = YES;
            
            self.ovulationCell.ovulationTypePositiveImageView.hidden = YES;
            self.ovulationCell.ovulationTypePositiveLabel.hidden = YES;
            
            if (OvulationTestCellHasData) {
                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = NO;
                self.ovulationCell.ovulationCollapsedLabel.hidden = NO;
                self.ovulationCell.ovulationTypeImageView.hidden = NO;
                self.ovulationCell.placeholderLabel.hidden = YES;
            } else {
                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = YES;
                self.ovulationCell.ovulationCollapsedLabel.hidden = YES;
                self.ovulationCell.ovulationTypeImageView.hidden = YES;
                self.ovulationCell.placeholderLabel.hidden = NO;
            }
            
            expandPregnancyTestCell = NO;
            // hide component
            self.pregnancyCell.pregnancyTypeNegativeImageView.hidden = YES;
            self.pregnancyCell.pregnancyTypeNegtaiveLabel.hidden = YES;
            
            self.pregnancyCell.pregnancyTypePositiveImageView.hidden = YES;
            self.pregnancyCell.pregnancyTypePositiveLabel.hidden = YES;
            
            if (PregnancyTestCellHasData) {
                self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = NO;
                self.pregnancyCell.pregnancyCollapsedLabel.hidden = NO;
                self.pregnancyCell.pregnancyTypeImageView.hidden = NO;
                self.pregnancyCell.placeholderLabel.hidden = YES;
            } else {
                self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = YES;
                self.pregnancyCell.pregnancyCollapsedLabel.hidden = YES;
                self.pregnancyCell.pregnancyTypeImageView.hidden = YES;
                self.pregnancyCell.placeholderLabel.hidden = NO;
            }
            
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStateIntercourseExpanded;
            break;
        }
            
#pragma mark - Mood
        case TableStateMoodExpanded:
        {
            
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            
            if (TemperatureCellHasData) {
                self.tempCell.placeholderLabel.hidden = YES;
                self.tempCell.collapsedLabel.hidden = NO;
                self.tempCell.temperatureValueLabel.hidden = NO;
            } else {
                self.tempCell.placeholderLabel.hidden = NO;
                self.tempCell.collapsedLabel.hidden = YES;
                self.tempCell.temperatureValueLabel.hidden = YES;
            }
            
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
            self.cpCell.highImageView.hidden = YES;
            self.cpCell.highLabel.hidden = YES;
            
            self.cpCell.lowImageView.hidden = YES;
            self.cpCell.lowLabel.hidden = YES;
            
            if (CervicalPositionCellHasData) {
                self.cpCell.placeholderLabel.hidden = YES;
                self.cpCell.collapsedLabel.hidden = NO;
                self.cpCell.cpTypeImageView.hidden = NO;
                self.cpCell.cpTypeCollapsedLabel.hidden = NO;
            } else {
                self.cpCell.placeholderLabel.hidden = NO;
                self.cpCell.collapsedLabel.hidden = YES;
                self.cpCell.cpTypeImageView.hidden = YES;
                self.cpCell.cpTypeCollapsedLabel.hidden = YES;
            }
            
            expandPeriodCell = NO;
            // hide component
            self.periodCell.noneImageView.hidden = YES;
            self.periodCell.noneLabel.hidden = YES;
            
            self.periodCell.spottingImageView.hidden = YES;
            self.periodCell.spottingLabel.hidden = YES;
            
            self.periodCell.lightImageView.hidden = YES;
            self.periodCell.lightLabel.hidden = YES;
            
            self.periodCell.mediumImageView.hidden = YES;
            self.periodCell.mediumLabel.hidden = YES;
            
            self.periodCell.heavyImageView.hidden = YES;
            self.periodCell.heavyLabel.hidden = YES;
            
            if (PeriodCellHasData) {
                self.periodCell.placeholderLabel.hidden = YES;
                self.periodCell.periodCollapsedLabel.hidden = NO;
                self.periodCell.periodTypeCollapsedLabel.hidden = NO;
                self.periodCell.periodTypeImageView.hidden = NO;
            } else {
                self.periodCell.placeholderLabel.hidden = NO;
                self.periodCell.periodCollapsedLabel.hidden = YES;
                self.periodCell.periodTypeCollapsedLabel.hidden = YES;
                self.periodCell.periodTypeImageView.hidden = YES;
            }
            
            expandIntercourseCell = NO;
            // hide component
            self.intercourseCell.protectedImageView.hidden = YES;
            self.intercourseCell.protectedLabel.hidden = YES;
            
            self.intercourseCell.unprotectedImageView.hidden = YES;
            self.intercourseCell.unprotectedLabel.hidden = YES;
            
            if (IntercourseCellHasData) {
                self.intercourseCell.placeholderLabel.hidden = YES;
                self.intercourseCell.intercourseCollapsedLabel.hidden = NO;
                self.intercourseCell.intercourseTypeCollapsedLabel.hidden = NO;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = NO;
            } else {
                self.intercourseCell.placeholderLabel.hidden = NO;
                self.intercourseCell.intercourseCollapsedLabel.hidden = YES;
                self.intercourseCell.intercourseTypeCollapsedLabel.hidden = YES;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = YES;
            }
            
            expandMoodCell = YES;
            self.moodCell.moodTableView.hidden = NO;
            self.moodCell.moodPlaceholderLabel.hidden = YES;
            self.moodCell.moodTypeLabel.hidden = YES;
            
            expandSymptomsCell = NO;
            // hide component
            self.symptomsCell.symptomsTableView.hidden = YES;
            
            expandSymptomsCell = NO;
            // hide component
            self.symptomsCell.symptomsTableView.hidden = YES;
            
            expandOvulationTestCell = NO;
            // hide component
            self.ovulationCell.ovulationTypeNegativeImageView.hidden = YES;
            self.ovulationCell.ovulationTypeNegativeLabel.hidden = YES;
            
            self.ovulationCell.ovulationTypePositiveImageView.hidden = YES;
            self.ovulationCell.ovulationTypePositiveLabel.hidden = YES;
            
            if (OvulationTestCellHasData) {
                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = NO;
                self.ovulationCell.ovulationCollapsedLabel.hidden = NO;
                self.ovulationCell.ovulationTypeImageView.hidden = NO;
                self.ovulationCell.placeholderLabel.hidden = YES;
            } else {
                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = YES;
                self.ovulationCell.ovulationCollapsedLabel.hidden = YES;
                self.ovulationCell.ovulationTypeImageView.hidden = YES;
                self.ovulationCell.placeholderLabel.hidden = NO;
            }
            
            expandPregnancyTestCell = NO;
            // hide component
            self.pregnancyCell.pregnancyTypeNegativeImageView.hidden = YES;
            self.pregnancyCell.pregnancyTypeNegtaiveLabel.hidden = YES;
            
            self.pregnancyCell.pregnancyTypePositiveImageView.hidden = YES;
            self.pregnancyCell.pregnancyTypePositiveLabel.hidden = YES;
            
            if (PregnancyTestCellHasData) {
                self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = NO;
                self.pregnancyCell.pregnancyCollapsedLabel.hidden = NO;
                self.pregnancyCell.pregnancyTypeImageView.hidden = NO;
                self.pregnancyCell.placeholderLabel.hidden = YES;
            } else {
                self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = YES;
                self.pregnancyCell.pregnancyCollapsedLabel.hidden = YES;
                self.pregnancyCell.pregnancyTypeImageView.hidden = YES;
                self.pregnancyCell.placeholderLabel.hidden = NO;
            }
            
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStateMoodExpanded;
            break;
        }
            
#pragma mark - Symptoms
        case TableStateSymptomsExpanded:
        {
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            
            if (TemperatureCellHasData) {
                self.tempCell.placeholderLabel.hidden = YES;
                self.tempCell.collapsedLabel.hidden = NO;
                self.tempCell.temperatureValueLabel.hidden = NO;
            } else {
                self.tempCell.placeholderLabel.hidden = NO;
                self.tempCell.collapsedLabel.hidden = YES;
                self.tempCell.temperatureValueLabel.hidden = YES;
            }
            
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
            self.cpCell.highImageView.hidden = YES;
            self.cpCell.highLabel.hidden = YES;
            
            self.cpCell.lowImageView.hidden = YES;
            self.cpCell.lowLabel.hidden = YES;
            
            if (CervicalPositionCellHasData) {
                self.cpCell.placeholderLabel.hidden = YES;
                self.cpCell.collapsedLabel.hidden = NO;
                self.cpCell.cpTypeImageView.hidden = NO;
                self.cpCell.cpTypeCollapsedLabel.hidden = NO;
            } else {
                self.cpCell.placeholderLabel.hidden = NO;
                self.cpCell.collapsedLabel.hidden = YES;
                self.cpCell.cpTypeImageView.hidden = YES;
                self.cpCell.cpTypeCollapsedLabel.hidden = YES;
            }
            
            expandPeriodCell = NO;
            // hide component
            self.periodCell.noneImageView.hidden = YES;
            self.periodCell.noneLabel.hidden = YES;
            
            self.periodCell.spottingImageView.hidden = YES;
            self.periodCell.spottingLabel.hidden = YES;
            
            self.periodCell.lightImageView.hidden = YES;
            self.periodCell.lightLabel.hidden = YES;
            
            self.periodCell.mediumImageView.hidden = YES;
            self.periodCell.mediumLabel.hidden = YES;
            
            self.periodCell.heavyImageView.hidden = YES;
            self.periodCell.heavyLabel.hidden = YES;
            
            if (PeriodCellHasData) {
                self.periodCell.placeholderLabel.hidden = YES;
                self.periodCell.periodCollapsedLabel.hidden = NO;
                self.periodCell.periodTypeCollapsedLabel.hidden = NO;
                self.periodCell.periodTypeImageView.hidden = NO;
            } else {
                self.periodCell.placeholderLabel.hidden = NO;
                self.periodCell.periodCollapsedLabel.hidden = YES;
                self.periodCell.periodTypeCollapsedLabel.hidden = YES;
                self.periodCell.periodTypeImageView.hidden = YES;
            }
            
            expandIntercourseCell = NO;
            // hide component
            self.intercourseCell.protectedImageView.hidden = YES;
            self.intercourseCell.protectedLabel.hidden = YES;
            
            self.intercourseCell.unprotectedImageView.hidden = YES;
            self.intercourseCell.unprotectedLabel.hidden = YES;
            
            if (IntercourseCellHasData) {
                self.intercourseCell.placeholderLabel.hidden = YES;
                self.intercourseCell.intercourseCollapsedLabel.hidden = NO;
                self.intercourseCell.intercourseTypeCollapsedLabel.hidden = NO;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = NO;
            } else {
                self.intercourseCell.placeholderLabel.hidden = NO;
                self.intercourseCell.intercourseCollapsedLabel.hidden = YES;
                self.intercourseCell.intercourseTypeCollapsedLabel.hidden = YES;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = YES;
            }
            
            expandMoodCell = NO;
            self.moodCell.moodTableView.hidden = YES;
            
            if (MoodCellHasData) {
                self.moodCell.moodPlaceholderLabel.hidden = YES;
                self.moodCell.moodCollapsedLabel.hidden = NO;
                self.moodCell.moodTypeLabel.hidden = NO;
            } else {
                self.moodCell.moodPlaceholderLabel.hidden = NO;
                self.moodCell.moodCollapsedLabel.hidden = YES;
                self.moodCell.moodTypeLabel.hidden = YES;
            }
            
            expandSymptomsCell = YES;
            // hide component
            self.symptomsCell.symptomsTableView.hidden = NO;
            self.symptomsCell.symptomsCollapsedLabel.hidden = NO;
            self.symptomsCell.placeholderLabel.hidden = YES;
            
            expandOvulationTestCell = NO;
            // hide component
            self.ovulationCell.ovulationTypeNegativeImageView.hidden = YES;
            self.ovulationCell.ovulationTypeNegativeLabel.hidden = YES;
            
            self.ovulationCell.ovulationTypePositiveImageView.hidden = YES;
            self.ovulationCell.ovulationTypePositiveLabel.hidden = YES;
            
            if (OvulationTestCellHasData) {
                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = NO;
                self.ovulationCell.ovulationCollapsedLabel.hidden = NO;
                self.ovulationCell.ovulationTypeImageView.hidden = NO;
                self.ovulationCell.placeholderLabel.hidden = YES;
            } else {
                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = YES;
                self.ovulationCell.ovulationCollapsedLabel.hidden = YES;
                self.ovulationCell.ovulationTypeImageView.hidden = YES;
                self.ovulationCell.placeholderLabel.hidden = NO;
            }
            
            expandPregnancyTestCell = NO;
            // hide component
            self.pregnancyCell.pregnancyTypeNegativeImageView.hidden = YES;
            self.pregnancyCell.pregnancyTypeNegtaiveLabel.hidden = YES;
            
            self.pregnancyCell.pregnancyTypePositiveImageView.hidden = YES;
            self.pregnancyCell.pregnancyTypePositiveLabel.hidden = YES;
            
            if (PregnancyTestCellHasData) {
                self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = NO;
                self.pregnancyCell.pregnancyCollapsedLabel.hidden = NO;
                self.pregnancyCell.pregnancyTypeImageView.hidden = NO;
                self.pregnancyCell.placeholderLabel.hidden = YES;
            } else {
                self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = YES;
                self.pregnancyCell.pregnancyCollapsedLabel.hidden = YES;
                self.pregnancyCell.pregnancyTypeImageView.hidden = YES;
                self.pregnancyCell.placeholderLabel.hidden = NO;
            }
            
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStateSymptomsExpanded;
            break;
        }
            
#pragma mark - Ovulation
        case TableStateOvulationTestExpanded:
        {
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            
            if (TemperatureCellHasData) {
                self.tempCell.placeholderLabel.hidden = YES;
                self.tempCell.collapsedLabel.hidden = NO;
                self.tempCell.temperatureValueLabel.hidden = NO;
            } else {
                self.tempCell.placeholderLabel.hidden = NO;
                self.tempCell.collapsedLabel.hidden = YES;
                self.tempCell.temperatureValueLabel.hidden = YES;
            }
            
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
            self.cpCell.highImageView.hidden = YES;
            self.cpCell.highLabel.hidden = YES;
            
            self.cpCell.lowImageView.hidden = YES;
            self.cpCell.lowLabel.hidden = YES;
            
            if (CervicalPositionCellHasData) {
                self.cpCell.placeholderLabel.hidden = YES;
                self.cpCell.collapsedLabel.hidden = NO;
                self.cpCell.cpTypeImageView.hidden = NO;
                self.cpCell.cpTypeCollapsedLabel.hidden = NO;
            } else {
                self.cpCell.placeholderLabel.hidden = NO;
                self.cpCell.collapsedLabel.hidden = YES;
                self.cpCell.cpTypeImageView.hidden = YES;
                self.cpCell.cpTypeCollapsedLabel.hidden = YES;
            }
            
            expandPeriodCell = NO;
            // hide component
            self.periodCell.noneImageView.hidden = YES;
            self.periodCell.noneLabel.hidden = YES;
            
            self.periodCell.spottingImageView.hidden = YES;
            self.periodCell.spottingLabel.hidden = YES;
            
            self.periodCell.lightImageView.hidden = YES;
            self.periodCell.lightLabel.hidden = YES;
            
            self.periodCell.mediumImageView.hidden = YES;
            self.periodCell.mediumLabel.hidden = YES;
            
            self.periodCell.heavyImageView.hidden = YES;
            self.periodCell.heavyLabel.hidden = YES;
            
            if (PeriodCellHasData) {
                self.periodCell.placeholderLabel.hidden = YES;
                self.periodCell.periodCollapsedLabel.hidden = NO;
                self.periodCell.periodTypeCollapsedLabel.hidden = NO;
                self.periodCell.periodTypeImageView.hidden = NO;
            } else {
                self.periodCell.placeholderLabel.hidden = NO;
                self.periodCell.periodCollapsedLabel.hidden = YES;
                self.periodCell.periodTypeCollapsedLabel.hidden = YES;
                self.periodCell.periodTypeImageView.hidden = YES;
            }
            
            expandIntercourseCell = NO;
            // hide component
            self.intercourseCell.protectedImageView.hidden = YES;
            self.intercourseCell.protectedLabel.hidden = YES;
            
            self.intercourseCell.unprotectedImageView.hidden = YES;
            self.intercourseCell.unprotectedLabel.hidden = YES;
            
            if (IntercourseCellHasData) {
                self.intercourseCell.placeholderLabel.hidden = YES;
                self.intercourseCell.intercourseCollapsedLabel.hidden = NO;
                self.intercourseCell.intercourseTypeCollapsedLabel.hidden = NO;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = NO;
            } else {
                self.intercourseCell.placeholderLabel.hidden = NO;
                self.intercourseCell.intercourseCollapsedLabel.hidden = YES;
                self.intercourseCell.intercourseTypeCollapsedLabel.hidden = YES;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = YES;
            }
            
            expandMoodCell = NO;
            // hide component
            self.moodCell.moodTableView.hidden = YES;
            
            if (MoodCellHasData) {
                self.moodCell.moodPlaceholderLabel.hidden = YES;
                self.moodCell.moodCollapsedLabel.hidden = NO;
                self.moodCell.moodTypeLabel.hidden = NO;
            } else {
                self.moodCell.moodPlaceholderLabel.hidden = NO;
                self.moodCell.moodCollapsedLabel.hidden = YES;
                self.moodCell.moodTypeLabel.hidden = YES;
            }
            
            expandSymptomsCell = NO;
            // hide component
            self.symptomsCell.symptomsTableView.hidden = YES;
            
            expandOvulationTestCell = YES;
            // hide component
            self.ovulationCell.placeholderLabel.hidden = YES;
            self.ovulationCell.ovulationTypeImageView.hidden = YES;
            self.ovulationCell.ovulationTypeCollapsedLabel.hidden = YES;
            
            self.ovulationCell.ovulationTypeNegativeImageView.hidden = NO;
            self.ovulationCell.ovulationTypeNegativeLabel.hidden = NO;
            
            self.ovulationCell.ovulationTypePositiveImageView.hidden = NO;
            self.ovulationCell.ovulationTypePositiveLabel.hidden = NO;
            
            expandPregnancyTestCell = NO;
            // hide component
            self.pregnancyCell.pregnancyTypeNegativeImageView.hidden = YES;
            self.pregnancyCell.pregnancyTypeNegtaiveLabel.hidden = YES;
            
            self.pregnancyCell.pregnancyTypePositiveImageView.hidden = YES;
            self.pregnancyCell.pregnancyTypePositiveLabel.hidden = YES;
            
            if (PregnancyTestCellHasData) {
                self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = NO;
                self.pregnancyCell.pregnancyCollapsedLabel.hidden = NO;
                self.pregnancyCell.pregnancyTypeImageView.hidden = NO;
                self.pregnancyCell.placeholderLabel.hidden = YES;
            } else {
                self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = YES;
                self.pregnancyCell.pregnancyCollapsedLabel.hidden = YES;
                self.pregnancyCell.pregnancyTypeImageView.hidden = YES;
                self.pregnancyCell.placeholderLabel.hidden = NO;
            }
            
            expandSupplementsCell = NO;
            // hide component
            expandMedicineCell = NO;
            // hide component
            
            currentState = TableStateOvulationTestExpanded;
            break;
        }
            
#pragma mark - Pregnancy
        case TableStatePregnancyTestExpanded:
        {
            expandTemperatureCell = NO;
            self.tempCell.temperaturePicker.hidden = YES;
            
            if (TemperatureCellHasData) {
                self.tempCell.placeholderLabel.hidden = YES;
                self.tempCell.collapsedLabel.hidden = NO;
                self.tempCell.temperatureValueLabel.hidden = NO;
            } else {
                self.tempCell.placeholderLabel.hidden = NO;
                self.tempCell.collapsedLabel.hidden = YES;
                self.tempCell.temperatureValueLabel.hidden = YES;
            }
            
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
            self.cpCell.highImageView.hidden = YES;
            self.cpCell.highLabel.hidden = YES;
            
            self.cpCell.lowImageView.hidden = YES;
            self.cpCell.lowLabel.hidden = YES;
            
            if (CervicalPositionCellHasData) {
                self.cpCell.placeholderLabel.hidden = YES;
                self.cpCell.collapsedLabel.hidden = NO;
                self.cpCell.cpTypeImageView.hidden = NO;
                self.cpCell.cpTypeCollapsedLabel.hidden = NO;
            } else {
                self.cpCell.placeholderLabel.hidden = NO;
                self.cpCell.collapsedLabel.hidden = YES;
                self.cpCell.cpTypeImageView.hidden = YES;
                self.cpCell.cpTypeCollapsedLabel.hidden = YES;
            }
            
            expandPeriodCell = NO;
            // hide component
            self.periodCell.noneImageView.hidden = YES;
            self.periodCell.noneLabel.hidden = YES;
            
            self.periodCell.spottingImageView.hidden = YES;
            self.periodCell.spottingLabel.hidden = YES;
            
            self.periodCell.lightImageView.hidden = YES;
            self.periodCell.lightLabel.hidden = YES;
            
            self.periodCell.mediumImageView.hidden = YES;
            self.periodCell.mediumLabel.hidden = YES;
            
            self.periodCell.heavyImageView.hidden = YES;
            self.periodCell.heavyLabel.hidden = YES;
            
            if (PeriodCellHasData) {
                self.periodCell.placeholderLabel.hidden = YES;
                self.periodCell.periodCollapsedLabel.hidden = NO;
                self.periodCell.periodTypeCollapsedLabel.hidden = NO;
                self.periodCell.periodTypeImageView.hidden = NO;
            } else {
                self.periodCell.placeholderLabel.hidden = NO;
                self.periodCell.periodCollapsedLabel.hidden = YES;
                self.periodCell.periodTypeCollapsedLabel.hidden = YES;
                self.periodCell.periodTypeImageView.hidden = YES;
            }
            
            expandIntercourseCell = NO;
            // hide component
            self.intercourseCell.protectedImageView.hidden = YES;
            self.intercourseCell.protectedLabel.hidden = YES;
            
            self.intercourseCell.unprotectedImageView.hidden = YES;
            self.intercourseCell.unprotectedLabel.hidden = YES;
            
            if (IntercourseCellHasData) {
                self.intercourseCell.placeholderLabel.hidden = YES;
                self.intercourseCell.intercourseCollapsedLabel.hidden = NO;
                self.intercourseCell.intercourseTypeCollapsedLabel.hidden = NO;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = NO;
            } else {
                self.intercourseCell.placeholderLabel.hidden = NO;
                self.intercourseCell.intercourseCollapsedLabel.hidden = YES;
                self.intercourseCell.intercourseTypeCollapsedLabel.hidden = YES;
                self.intercourseCell.intercourseTypeCollapsedImageView.hidden = YES;
            }
            
            expandMoodCell = NO;
            // hide component
            self.moodCell.moodTableView.hidden = YES;
            
            expandSymptomsCell = NO;
            // hide component
            self.symptomsCell.symptomsTableView.hidden = YES;
            
            expandSymptomsCell = NO;
            // hide component
            self.symptomsCell.symptomsTableView.hidden = YES;
            
            expandOvulationTestCell = NO;
            // hide component
            self.ovulationCell.ovulationTypeNegativeImageView.hidden = YES;
            self.ovulationCell.ovulationTypeNegativeLabel.hidden = YES;
            
            self.ovulationCell.ovulationTypePositiveImageView.hidden = YES;
            self.ovulationCell.ovulationTypePositiveLabel.hidden = YES;
            
            if (OvulationTestCellHasData) {
                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = NO;
                self.ovulationCell.ovulationCollapsedLabel.hidden = NO;
                self.ovulationCell.ovulationTypeImageView.hidden = NO;
                self.ovulationCell.placeholderLabel.hidden = YES;
            } else {
                self.ovulationCell.ovulationTypeCollapsedLabel.hidden = YES;
                self.ovulationCell.ovulationCollapsedLabel.hidden = YES;
                self.ovulationCell.ovulationTypeImageView.hidden = YES;
                self.ovulationCell.placeholderLabel.hidden = NO;
            }
            
            expandPregnancyTestCell = YES;
            // hide component
            self.pregnancyCell.pregnancyTypeNegativeImageView.hidden = NO;
            self.pregnancyCell.pregnancyTypeNegtaiveLabel.hidden = NO;
            
            self.pregnancyCell.pregnancyTypePositiveImageView.hidden = NO;
            self.pregnancyCell.pregnancyTypePositiveLabel.hidden = NO;
            
            self.pregnancyCell.pregnancyTypeImageView.hidden = YES;
            self.pregnancyCell.pregnancyTypeCollapsedLabel.hidden = YES;
            
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
            
            if (TemperatureCellHasData) {
                self.tempCell.placeholderLabel.hidden = YES;
                self.tempCell.collapsedLabel.hidden = NO;
                self.tempCell.temperatureValueLabel.hidden = NO;
            } else {
                self.tempCell.placeholderLabel.hidden = NO;
                self.tempCell.collapsedLabel.hidden = YES;
                self.tempCell.temperatureValueLabel.hidden = YES;
            }
            
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
            self.cpCell.highImageView.hidden = YES;
            self.cpCell.highLabel.hidden = YES;
            
            self.cpCell.lowImageView.hidden = NO;
            self.cpCell.lowLabel.hidden = NO;
            
            if (CervicalPositionCellHasData) {
                self.cpCell.placeholderLabel.hidden = YES;
                self.cpCell.collapsedLabel.hidden = NO;
                self.cpCell.cpTypeImageView.hidden = NO;
                self.cpCell.cpTypeCollapsedLabel.hidden = NO;
            } else {
                self.cpCell.placeholderLabel.hidden = NO;
                self.cpCell.collapsedLabel.hidden = YES;
                self.cpCell.cpTypeImageView.hidden = YES;
                self.cpCell.cpTypeCollapsedLabel.hidden = YES;
            }
            
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
            
            if (TemperatureCellHasData) {
                self.tempCell.placeholderLabel.hidden = YES;
                self.tempCell.collapsedLabel.hidden = NO;
                self.tempCell.temperatureValueLabel.hidden = NO;
            } else {
                self.tempCell.placeholderLabel.hidden = NO;
                self.tempCell.collapsedLabel.hidden = YES;
                self.tempCell.temperatureValueLabel.hidden = YES;
            }
            
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
            self.cpCell.highImageView.hidden = YES;
            self.cpCell.highLabel.hidden = YES;
            
            self.cpCell.lowImageView.hidden = NO;
            self.cpCell.lowLabel.hidden = NO;
            
            if (CervicalPositionCellHasData) {
                self.cpCell.placeholderLabel.hidden = YES;
                self.cpCell.collapsedLabel.hidden = NO;
                self.cpCell.cpTypeImageView.hidden = NO;
                self.cpCell.cpTypeCollapsedLabel.hidden = NO;
            } else {
                self.cpCell.placeholderLabel.hidden = NO;
                self.cpCell.collapsedLabel.hidden = YES;
                self.cpCell.cpTypeImageView.hidden = YES;
                self.cpCell.cpTypeCollapsedLabel.hidden = YES;
            }
            
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
    
    //    if (indexPath.row == 86) {
    //        NSLog(@"index 86");
    //    }
    
    DateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dateCvCell" forIndexPath:indexPath];
    
    // two labels, month and day
    // get date object for array, set labels, return
    NSDate *cellDate = [drawerDateData objectAtIndex:indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    //    [formatter setDateFormat:@"yyyy"];
    //    NSString *year = [formatter stringFromDate:cellDate];
    [formatter setDateFormat:@"EEE"];
    NSString *dayOfWeek = [[formatter stringFromDate:cellDate] uppercaseString];
    [formatter setDateFormat:@"d"];
    NSString *day = [formatter stringFromDate:cellDate];
    
    cell.monthLabel.text = dayOfWeek;
    cell.dayLabel.text = day;
    
    // if cell date is today, make it larger
    
    //    if (indexPath.row == 86) {
    //        NSLog(@"indexPath:%@ indexPath.row:%ld", indexPath, (long)indexPath.row);
    //        NSLog(@"self.selectedIndexPath:%@ self.selectedIndexPath.row:%ld", self.selectedIndexPath, (long)self.selectedIndexPath.row);
    //    }
    
    if (indexPath.row == self.selectedIndexPath.row) {
        CGRect cellFrame = cell.frame;
        cellFrame.size.height = 54.0f;
        cellFrame.size.width = 44.0f;
        cell.frame = cellFrame;
    } else {
        CGRect cellFrame = cell.frame;
        cellFrame.size.height = 44.0f;
        cellFrame.size.width = 44.0f;
        cell.frame = cellFrame;
    }
    
    //    NSLog(@"index:%ld h:%f w:%f", (long)indexPath.row, cell.frame.size.height, cell.frame.size.width);
    
    // use outline for future dates
    if ([cellDate compare:[NSDate date]] == NSOrderedDescending) {
        // celldate is earlier than today
        cell.statusImageView.image = [UIImage imageNamed:@"icn_pulldown_notfertile_empty"];
        // change colors
        cell.monthLabel.textColor = [UIColor ovatempGreyColorForDateCollectionViewCells];
        cell.dayLabel.textColor = [UIColor ovatempGreyColorForDateCollectionViewCells];
    } else {
        cell.statusImageView.image = [UIImage imageNamed:@"icn_pulldown_fertile_small"];
        cell.monthLabel.textColor = [UIColor whiteColor];
        cell.dayLabel.textColor = [UIColor whiteColor];
    }
    
    //    if (indexPath == self.selectedIndexPath) {
    //        CGSize cellSize = cell.frame.size;
    //
    //        CGSizeMake(44, 54);
    //    }
    
    // selected a new day, reset properties
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
    
    [self refreshTrackingView];
    
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
    [self.tempCell setSelectedDate:self.selectedDate];
    [self.cfCell setSelectedDate:self.selectedDate];
    [self.cpCell setSelectedDate:self.selectedDate];
    [self.periodCell setSelectedDate:self.selectedDate];
    
    self.selectedIndexPath = indexPath;
    
    // reset ondo icon
    self.tempCell.ondoIcon.hidden = YES;
    
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
    
    //    [self collectionView:self.drawerCollectionView layout:[[UICollectionViewFlowLayout alloc] init] sizeForItemAtIndexPath:indexPath];
    
    //    [self.drawerCollectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    //    NSLog(@"---%@", [self.drawerCollectionView cellForItemAtIndexPath:indexPath]);
    
    [self.drawerCollectionView reloadData];
    [self.drawerCollectionView.collectionViewLayout invalidateLayout];
    
    [[self.drawerCollectionView cellForItemAtIndexPath:indexPath] setNeedsDisplay];
    
    //    NSLog(@"---%@", [self.drawerCollectionView cellForItemAtIndexPath:indexPath]);
    
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

# pragma mark - ONDO delegate methods

- (void)ONDOsaysBluetoothIsDisabled:(ONDO *)ondo {
    [Alert showAlertWithTitle:@"Bluetooth is Off"
                      message:@"Bluetooth is off, so we can't detect a thing"];
}

- (void)ONDOsaysLEBluetoothIsUnavailable:(ONDO *)ondo {
    [Alert showAlertWithTitle:@"LE Bluetooth Unavailable"
                      message:@"Your device does not support low-energy Bluetooth, so it can't connect to your ONDO"];
}

- (void)ONDO:(ONDO *)ondo didEncounterError:(NSError *)error {
    [Alert presentError:error];
}

- (void)ONDO:(ONDO *)ondo didReceiveTemperature:(CGFloat)temperature {
    
    float tempInCelsius = temperature;
    temperature = temperature * 9.0f / 5.0f + 32.0f;
    
    // Save the temperature
//    Day *day = [Day today];
    //    [day updateProperty:@"temperature" withValue:@(temperature)];
    
    TemperatureCellHasData = YES;
    
    // unhide ondo icon
    self.tempCell.ondoIcon.hidden = NO;
    
    // always send F to backend
    [self postAndSaveTempWithTempValue:temperature];
    
    // update table view cell
    
    // Tell the user what's up
    
    // Display C or F
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *temperatureString;
    
    BOOL tempPrefFahrenheit = [defaults boolForKey:@"temperatureUnitPreferenceFahrenheit"];
    
    if (tempPrefFahrenheit) {
        temperatureString = [NSString stringWithFormat:@"Recorded a temperature of %.2fºF for today", temperature];
        self.temperature = [NSNumber numberWithFloat:temperature];
    } else {
        temperatureString = [NSString stringWithFormat:@"Recorded a temperature of %.2fºC for today", tempInCelsius];
        self.temperature = [NSNumber numberWithFloat:tempInCelsius];
    }
    [Alert showAlertWithTitle:@"Temperature Recorded" message:temperatureString];
}

- (void)postAndSaveTempWithTempValue:(float)temp {

    // we're getting the temp in fahrenheit, no need to convert
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    BOOL tempPrefFahrenheit = [defaults boolForKey:@"temperatureUnitPreferenceFahrenheit"];
//    if (!tempPrefFahrenheit) {
//        temp = ((temp * 1.8000) + 32);
//    }
    
    // first save to HealthKit
    [self updateHealthKitWithTemp:temp];
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:self.selectedDate forKey:@"date"];
    [attributes setObject:[NSString stringWithFormat:@"%f", temp] forKey:@"temperature"];
    
    [ConnectionManager put:@"/days/"
                    params:@{
                             @"day": attributes,
                             }
                   success:^(NSDictionary *response) {
                       [Cycle cycleFromResponse:response];
                       [Calendar setDate:self.selectedDate];
                       //                       if (onSuccess) onSuccess(response);
                       [self refreshTrackingView];
                       // refresh after successful POST
                   }
                   failure:^(NSError *error) {
                       [Alert presentError:error];
                   }];
}

# pragma mark - HealthKit

- (void)updateHealthKitWithTemp:(float)temp {
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

#pragma mark - Push Info Alert Delegate

- (void)pushInfoAlertWithTitle:(NSString *)title AndMessage:(NSString *)message AndURL:(NSString *)url {
    UIAlertController *infoAlert = [UIAlertController
                                    alertControllerWithTitle:title
                                    message:message
                                    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *gotIt = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault
                                                  handler:nil];
    
    UIAlertAction *learnMore = [UIAlertAction actionWithTitle:@"Learn more" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        WebViewController *webViewController = [WebViewController withURL:url];
        webViewController.title = title;
        
//        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewControllerAnimated:completion:)];
//        webViewController.navigationItem.leftBarButtonItem = backButton;
        
        [webViewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(popWebView)]];
        
        // fix nav bar
        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 320, 64)];
        
//        [self presentViewController:webViewController animated:YES completion:nil];
        [self pushViewController:webViewController];
//        UINavigationController *tempNavigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
//
//        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewControllerAnimated:completion:)];
//
//        [tempNavigationController.navigationItem setLeftBarButtonItem:backButton];
//        
//        //now present this navigation controller modally
//        [self presentViewController:tempNavigationController
//                           animated:YES
//                         completion:nil];
    }];
    
    [infoAlert addAction:gotIt];
    [infoAlert addAction:learnMore];
    
    infoAlert.view.tintColor = [UIColor ovatempAquaColor];
    
    didLeaveToWebView = YES;
    
    [self presentViewController:infoAlert animated:YES completion:nil];
}

- (void)popWebView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showLoadingSpinner {
    loadingView = [[UIView alloc] init];
    loadingView.frame = CGRectMake(0, 0, 100, 100);
    loadingView.center = [self.view convertPoint:self.view.center fromView:self.view.superview];
    loadingView.backgroundColor = [UIColor colorWithRed:(68.0f/255.0) green:(68.0f/255.0) blue:(68.0f/255.0) alpha:0.8];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [spinner sizeToFit];
//    spinner.center = loadingView.center;
    spinner.frame = CGRectMake(32, 32, 36, 36);
//    spinner.center = [loadingView convertPoint:loadingView.center fromView:loadingView.superview];
    spinner.color = [UIColor whiteColor];
    [loadingView addSubview:spinner];
    [spinner startAnimating];
    
    loadingView.layer.cornerRadius = 5;
    loadingView.layer.masksToBounds = YES;
    
    [self.view addSubview:loadingView];
}

- (void)hideLoadingSpinner {
    [loadingView removeFromSuperview];
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
