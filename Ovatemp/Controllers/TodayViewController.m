//
//  TodayViewController.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TodayViewController.h"
#import "Calendar.h"
#import "Cycle.h"
#import "CycleViewController.h"
#import "Day.h"
#import "DayCell.h"

#import "DisturbanceCellEditView.h"
#import "TemperatureCellEditView.h"
#import "TemperatureCellStaticView.h"

@interface TodayViewController ()

@property NSArray *rows;

@property BOOL isShowingLandscapeView;
@property CycleViewController *cycleViewController;

@end

@implementation TodayViewController

#pragma mark - Setup

- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableView.isAccessibilityElement = TRUE;
  self.tableView.accessibilityIdentifier = @"Checklist";

  // Align separators left
  self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

  // Don't show separators after the last item
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

  [self setupLandscape];
  [self setupRows];
}

- (void)setupRows {
  DayAttribute *temperature = [DayAttribute withName:@"temperature" type:DayAttributeCustom];
  DayAttribute *disturbance = [DayAttribute withName:@"disturbance" type:DayAttributeCustom];

  CGRect editFrame = CGRectMake(0, 0, self.tableView.frame.size.width, 0);
  DayCellEditView *temperatureEditView = [[TemperatureCellEditView alloc] initWithFrame:editFrame];
  temperatureEditView.attribute = temperature;

  editFrame.origin.y = CGRectGetMaxY(temperatureEditView.frame) - SUPERVIEW_SPACING + SIBLING_SPACING;
  DayCellEditView *disturbanceEditView = [[DisturbanceCellEditView alloc] initWithFrame:editFrame];
  disturbanceEditView.hasLabel = NO;
  disturbanceEditView.attribute = disturbance;
  editFrame = disturbanceEditView.frame;
  editFrame.size.height -= SUPERVIEW_SPACING;
  disturbanceEditView.frame = editFrame;
  [temperatureEditView addSubview:disturbanceEditView];

  CGRect staticFrame = CGRectMake(SUPERVIEW_SPACING,
                                  SUPERVIEW_SPACING,
                                  self.tableView.frame.size.width - SUPERVIEW_SPACING * 3,
                                  temperatureEditView.frame.size.height - SUPERVIEW_SPACING * 2);
  DayCellStaticView *temperatureStaticView = [[TemperatureCellStaticView alloc] initWithFrame:staticFrame];
  temperatureStaticView.attribute = temperature;
  

  DayCell *temperatureCell = [DayCell withAttributes:@[temperature, disturbance]];
  temperatureCell.editViews = [@[temperatureEditView, disturbanceEditView] mutableCopy];
  temperatureCell.staticViews = [@[temperatureStaticView] mutableCopy];

  DayAttribute *period = [DayAttribute withName:@"period" type:DayAttributeToggle];
  period.choices = kPeriodTypes;
  DayCell *periodCell = [DayCell withAttribute:period];

  DayAttribute *cervicalFluid = [DayAttribute withName:@"cervicalFluid" type:DayAttributeToggle];
  cervicalFluid.choices = kCervicalFluidTypes;
  cervicalFluid.title = @"Cervical Fluid";
  DayAttribute *vaginalSensation = [DayAttribute withName:@"vaginalSensation" type:DayAttributeToggle];
  vaginalSensation.choices = kVaginalSensationTypes;
  vaginalSensation.title = @"Vaginal Sensation";
  DayCell *vaginalCell = [DayCell withAttributes:@[cervicalFluid, vaginalSensation]];

  DayAttribute *intercourse = [DayAttribute withName:@"intercourse" type:DayAttributeToggle];
  intercourse.choices = kIntercourseTypes;
  DayCell *intercourseCell = [DayCell withAttribute:intercourse];

  DayAttribute *symptoms = [DayAttribute withName:@"symptoms" type:DayAttributeList];
  symptoms.choiceClass = [Symptom class];
  DayAttribute *mood = [DayAttribute withName:@"mood" type:DayAttributeToggle];
  mood.choices = kMoodTypes;
  DayCell *statusCell = [DayCell withAttributes:@[symptoms, mood]];

  DayAttribute *supplements = [DayAttribute withName:@"supplements" type:DayAttributeList];
  supplements.choiceClass = [Supplement class];
  DayAttribute *medicines = [DayAttribute withName:@"medicines" type:DayAttributeList];
  medicines.choiceClass = [Medicine class];
  DayCell *drugCell = [DayCell withAttributes:@[supplements, medicines]];

  DayAttribute *opk = [DayAttribute withName:@"opk" type:DayAttributeToggle];
  opk.choices = kOpkTypes;
  opk.title = @"OPK";

  DayAttribute *ferning = [DayAttribute withName:@"ferning" type:DayAttributeToggle];
  ferning.choices = kFerningTypes;

  CGFloat width = self.tableView.frame.size.width - SUPERVIEW_SPACING * 2;
  width = width / 2;

  DayCellEditView *editOPK = [[DayCellEditView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
  editOPK.attribute = opk;
  CGRect opkFrame = editOPK.frame;
  opkFrame.size.width = self.tableView.frame.size.width;
  editOPK.frame = opkFrame;

  DayCellEditView *editFerning = [[DayCellEditView alloc] initWithFrame:CGRectMake(width + SUPERVIEW_SPACING, 0, width, 0)];
  editFerning.attribute = ferning;

  editOPK.hasLabel = NO;
  [editOPK addSubview:editFerning];
  editOPK.hasLabel = YES;

  DayCell *opkFerningCell = [DayCell withAttributes:@[opk, ferning]];
  opkFerningCell.editViews = [@[editOPK, editFerning] mutableCopy];
  
  self.rows = @[temperatureCell,
                periodCell,
                vaginalCell,
                intercourseCell,
                statusCell,
                drugCell,
                opkFerningCell];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [[Calendar sharedInstance] addObserver:self
                              forKeyPath:@"day"
                                 options:NSKeyValueObservingOptionNew
                                 context:NULL];


  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(applicationWillResign)
   name:UIApplicationWillResignActiveNotification
   object:NULL];

  self.day = nil;
  [self dateChanged];
  [self trackScreenView:@"Today"];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  [[NSNotificationCenter defaultCenter]
   removeObserver:self
   name:UIApplicationWillResignActiveNotification
   object:nil];

  [[Calendar sharedInstance] removeObserver:self forKeyPath:@"day"];

  // Make sure to save the day before we leave
  [self.day save];
  self.day = nil;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter]
   removeObserver:self
   name:UIDeviceOrientationDidChangeNotification
   object:nil];
}

- (void)applicationWillResign {
  [self.day save];
  self.day = nil;
}

# pragma mark - Reactions to date changes

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context
{
  if([keyPath isEqualToString:@"day"] && [[Calendar sharedInstance] class] == [object class]) {
    [self dateChanged];
  }
}

- (void)dateChanged {
  // Make sure to save the day before we leave
  self.day = [Calendar day];

  [self dayChanged];
}

- (void)dayChanged {
  [self.tableView setContentOffset:CGPointZero animated:NO];
  [self.tableView reloadData];
  [self.cycleViewController setCycle:self.day.cycle];
}


#pragma mark - Rotation

// We are using a custom rotation technique, presenting a modal view controller of the
// chart when appropriate.
- (void)setupLandscape {
  self.cycleViewController = [[CycleViewController alloc] init];
  self.cycleViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  self.isShowingLandscapeView = NO;

  [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(orientationChanged:)
                                               name:UIDeviceOrientationDidChangeNotification
                                             object:nil];
}

- (BOOL)shouldAutorotate {
  return FALSE;
}

- (void)orientationChanged:(NSNotification *)notification
{
  // We can still present a modal even if we aren't the active tab,
  // prevent that
  if(self.tabBarController.selectedIndex != 0) {
    return;
  }

  if([self isCorrectOrientation]) {
    return;
  }

  UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
  if(UIDeviceOrientationIsLandscape(deviceOrientation)) {
    [self.cycleViewController setCycle:self.day.cycle];
    self.isShowingLandscapeView = YES;
    [self presentViewController:self.cycleViewController animated:NO completion:nil];
  } else {
    [self.cycleViewController dismissViewControllerAnimated:NO completion:nil];
    self.isShowingLandscapeView = NO;
  }
}

- (BOOL)isCorrectOrientation {
  UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;

  return (UIDeviceOrientationIsLandscape(deviceOrientation) && self.isShowingLandscapeView) ||
  (UIDeviceOrientationIsPortrait(deviceOrientation) && !self.isShowingLandscapeView);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  DayCell *cell = self.rows[indexPath.row];
  cell.day = self.day;
  cell.width = tableView.frame.size.width;
  [cell build];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  // Get the height directly from the xib, so we only have to change it in one place
  // The overhead is one extra copy of the view per row.
  UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
  return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.rows.count;
}

@end
