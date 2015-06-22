//
//  ILCycleViewController.m
//  Ovatemp
//
//  Created by Daniel Lozano on 3/25/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILCycleViewController.h"

#import <TelerikUI/TelerikUI.h>
#import "Localytics.h"
#import "TAOverlay.h"

#import "Cycle.h"
#import "Calendar.h"
#import "UserProfile.h"
#import "CycleCollectionViewCell.h"
#import "TransparentSwipeView.h"
#import "UIColor+Traits.h"

@interface ILCycleViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,TKChartDelegate>

@property (nonatomic) TKChart *chartView;
@property (nonatomic) TKChartLineSeries *chartSeries;
@property (nonatomic) TKChartGridLineAnnotation *chartLineAnnotation;
@property (nonatomic) TKChartBandAnnotation *chartBandAnnotation;

@property (nonatomic) NSMutableArray *temperatureData;

@property (nonatomic) UISwipeGestureRecognizer *swipeLeft;
@property (nonatomic) UISwipeGestureRecognizer *swipeRight;

@property (nonatomic) NSDateFormatter *dateFormatter;

@property (nonatomic) NSArray *days;

@end

@implementation ILCycleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self customizeAppearance];
    [self setUpChart];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    [self addGestureRecognizers];
    [self loadAssets];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool: YES forKey: @"ShouldRotate"];
    [defaults synchronize];
    
    [Localytics tagScreen: @"Tracking/Chart"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return FALSE;
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    NSDictionary *viewsDictionary = @{@"chartView" : self.chartView,
                                      @"periodView" : self.periodCollectionView};
    
    NSArray *chartHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-0-[chartView]-0-|"
                                                                                  options: 0
                                                                                  metrics: nil
                                                                                    views: viewsDictionary];
    
    NSArray *chartVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-0-[chartView]-0-[periodView]"
                                                                                options: 0
                                                                                metrics: nil
                                                                                  views: viewsDictionary];
    
    
    
    [self.view addConstraints: chartHorizontalConstraints];
    [self.view addConstraints: chartVerticalConstraints];
}

#pragma mark - Gesture Recognizers

- (void)addGestureRecognizers
{
    self.swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(didSwipe:)];
    self.swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    self.swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(didSwipe:)];
    self.swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.transparentView addGestureRecognizer: self.swipeLeft];
    [self.transparentView addGestureRecognizer: self.swipeRight];
}

#pragma mark - IBAction's

- (void)didSwipe:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self didSelectNextCycle: self];
    }else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        [self didSelectPreviousCycle: self];
    }
}

- (void)didSelectDoneButton
{
    [[UIDevice currentDevice] setValue: [NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey: @"orientation"];
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction)didSelectPreviousCycle:(id)sender
{
    Cycle *currentCycle = self.selectedCycle;
    Cycle *previosCycle = currentCycle.previousCycle;
    
    if (previosCycle) {
        DDLogInfo(@"ILCycleViewController : Going to previous cycle.");
        self.selectedCycle = previosCycle;
        [self hideLabels];
        [self updateScreen];
    }
}

- (IBAction)didSelectNextCycle:(id)sender
{
    Cycle *currentCycle = self.selectedCycle;
    Cycle *nextCycle = currentCycle.nextCycle;
    
    if (nextCycle) {
        DDLogInfo(@"ILCycleViewController : Going to next cycle.");
        self.selectedCycle = nextCycle;
        [self hideLabels];
        [self updateScreen];
    }
}

#pragma mark - Network

- (void)loadAssets
{
    DDLogInfo(@"ILCycleViewController : Loading Cycle.");
    [TAOverlay showOverlayWithLabel: @"Loading Cycles..." Options: TAOverlayOptionOverlaySizeRoundedRect];
    
    [Cycle loadAllAnd:^(id response) {
        
        DDLogInfo(@"ILCycleViewConteroller : Loading Cycles : Success");
        [self loadCycle];
        [TAOverlay hideOverlay];
        
    } failure:^(NSError *error) {
        
        DDLogError(@"ILCycleViewConteroller : Loading Cycles : Error: %@", error);
        [TAOverlay hideOverlay];
        
    }];
}

#pragma mark - Appearance

- (void)loadCycle
{
    [Calendar resetDate];
    Day *day = [Calendar day];
    self.selectedCycle = day.cycle;
    
    if (self.selectedCycleId) {
        
        BOOL found = NO;
        while (self.selectedCycle.previousCycle) {
            Cycle *currentCycle = self.selectedCycle;
            if ([self.selectedCycleId integerValue] == [currentCycle.cycleId integerValue]) {
                found = YES;
                break;
            }else{
                [self didSelectPreviousCycle: nil];
            }
        }
        
        Cycle *lastCycle = self.selectedCycle;
        if ([self.selectedCycleId integerValue] == [lastCycle.cycleId integerValue]) {
            found = YES;
        }
        
        if (!found) {
            [self goToNewestCycle];
        }
    }
    
    [self updateScreen];
}

- (void)goToNewestCycle
{
    while (self.selectedCycle.nextCycle) {
        [self didSelectNextCycle: nil];
    }
}

- (void)updateScreen
{
    self.title = self.selectedCycle.rangeString;
    
    [UIView animateWithDuration: 1 animations:^{
        [self showLabels];
    }];
    
    if ([self.selectedCycle.days count] > 0) {
        [self reloadChart];
        [self reloadCollectionViews];
    }
    
}

- (void)customizeAppearance
{
    [self hideLabels];
    
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor darkGrayColor]}];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(didSelectDoneButton)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
}

- (void)hideLabels
{
    self.periodLabel.alpha = 0.0f;
    self.cpLabel.alpha = 0.0f;
    self.cfLabel.alpha = 0.0f;
    self.sexLabel.alpha = 0.0f;
}

- (void)showLabels
{
    self.periodLabel.alpha = 1.0f;
    self.cpLabel.alpha = 1.0f;
    self.cfLabel.alpha = 1.0f;
    self.sexLabel.alpha = 1.0f;
}

#pragma mark - Chart Construction

- (void)setUpChart
{
    self.chartView = [[TKChart alloc] init];
    self.chartView.delegate = self;
    self.chartView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.chartView.title.hidden = YES;
    self.chartView.legend.hidden = YES;
    self.chartView.allowAnimations = YES;
    
    self.chartView.selectionMode = TKChartSelectionModeSingle;
    
    [self.view addSubview: self.chartView];
}

- (void)reloadChart
{
    [self.chartView removeAllData];
    [self.chartView removeAllAnnotations];
    
    [self buildTemperatureDataArray];
    [self addSeriesToChart];
    [self customizeChartAxis];
    [self addCoverLineToChart];
    [self addFertilityWindowToChart];
}

- (void)buildTemperatureDataArray
{
    self.temperatureData = [[NSMutableArray alloc] init];
//    NSArray *oldDays = self.selectedCycle.days;
    self.days = [self addMissingDatesToArray: self.selectedCycle.days];
    
//    DDLogInfo(@"OLD DAYS : %@", oldDays);
//    DDLogError(@"OLD DAYS COUNT : %ld", (long)[oldDays count]);
//    
//    DDLogInfo(@"DAYS : %@", self.days);
//    DDLogError(@"DAYS COUNT : %ld", (long)[self.days count]);

    // ADD EXISTING DAYS TO TEMP. DATA
    for (int i = 0; i < [self.days count]; i++) {
        
        Day *day = self.days[i];
        CGFloat temperature;
        
        // If there is no temperature for day, get previous non zero temperature
        if (!day.temperature || [day.temperature floatValue] == 0) {
            CGFloat previousTemp = [self getPreviousNonZeroTemperatureInArray: self.days fromIndex: i];
            temperature = [self correctTempWithUnit: previousTemp];
        }else{
            temperature = [self correctTempWithUnit: [day.temperature floatValue]];
        }
        
        [self.temperatureData addObject: [[TKChartDataPoint alloc] initWithX: @(i+1) Y: @(temperature)]];
    }
    
    // FILL OUT REMAINDER OF CYCLE
    
    if ([self.days count] < self.cycleLength) {
        CGFloat previousTemp = [self getPreviousNonZeroTemperatureInArray: self.days fromIndex: [self.days count]];
        for (NSInteger i = [self.days count]; i < self.cycleLength; i++) {
            [self.temperatureData addObject:[[TKChartDataPoint alloc] initWithX: @(i+1) Y: @(previousTemp)]];
        }
    }
    
//    NSLog(@"DAYS: %@", self.selectedCycle.days);
//    NSLog(@"TEMPERATURE DATA: %@", self.temperatureData);
}

- (void)addSeriesToChart
{
    self.chartSeries = [[TKChartLineSeries alloc] initWithItems: self.temperatureData];
    
    self.chartSeries.style.shapeMode = TKChartSeriesStyleShapeModeAlwaysShow;
    
    // POINT SHAPE
    self.chartSeries.style.pointShape = [TKPredefinedShape shapeWithType: TKShapeTypeCircle andSize: CGSizeMake(10, 10)];
    
    // STROKE
    TKChartPaletteItem *palleteItemStroke = [[TKChartPaletteItem alloc] init];
    palleteItemStroke.stroke = [TKStroke strokeWithColor: [UIColor darkGrayColor] width: 2];
    
    self.chartSeries.style.palette = [[TKChartPalette alloc] init];
    [self.chartSeries.style.palette addPaletteItem: palleteItemStroke];
    
    // POINT FILL(COLOR)
    TKChartPaletteItem *paletteItemFill = [[TKChartPaletteItem alloc] init];
    paletteItemFill.fill = [TKSolidFill solidFillWithColor: [UIColor purpleColor]];
    
    TKChartPalette *palette = [[TKChartPalette alloc] init];
    [palette addPaletteItem: paletteItemFill];
    self.chartSeries.style.shapePalette = palette;
    
    self.chartSeries.selectionMode = TKChartSeriesSelectionModeDataPoint;
    
    [self.chartView addSeries: self.chartSeries];
}

- (void)customizeChartAxis
{
    // CALCULATE MIN AND MAX TEMPERATURES FOR Y AXIS
    
    CGFloat minTemp;
    CGFloat maxTemp;
    
    for (int i = 0; i < [self.temperatureData count]; i++) {
        TKChartDataPoint *point = self.temperatureData[i];
        CGFloat dayTemp = [point.dataYValue floatValue];

        if (dayTemp != 0) {
            minTemp = dayTemp;
            maxTemp = dayTemp;
            break;
        }
    }
    
    for (int i = 0; i < [self.temperatureData count]; i++) {
        TKChartDataPoint *point = self.temperatureData[i];
        CGFloat dayTemp = [point.dataYValue floatValue];
        
        if (dayTemp == 0) {
            continue;
        }
        
        if (dayTemp < minTemp) {
            minTemp = dayTemp;
        }else if (dayTemp > maxTemp) {
            maxTemp = dayTemp;
        }
    }
    
    if (minTemp == 0 || maxTemp == 0) {
        minTemp = 0;
        maxTemp = 0;
    }
    
    NSString *minTempString = [NSString stringWithFormat: @"%.1f", minTemp];
    NSString *maxTempString = [NSString stringWithFormat: @"%.1f", maxTemp];
    NSNumber *minTempRounded = [NSNumber numberWithFloat: [minTempString floatValue]];
    NSNumber *maxTempRounded = [NSNumber numberWithFloat: [maxTempString floatValue]];
    
    // This is to fix bug where points appear offscreen
    CGFloat minTempRoundedMinusOne = [minTempRounded integerValue];
    CGFloat maxTempRoundedMinusOne = [maxTempRounded integerValue] + 1;
    
    TKChartNumericAxis *yAxis = [[TKChartNumericAxis alloc] initWithMinimum: @(minTempRoundedMinusOne) andMaximum: @(maxTempRoundedMinusOne)];
    //yAxis.style.labelStyle.textOffset = UIOffsetMake(2, 0);
    //yAxis.style.labelStyle.firstLabelTextOffset = UIOffsetMake(2, 0);
    yAxis.style.labelStyle.firstLabelTextAlignment = TKChartAxisLabelAlignmentLeft;
    yAxis.style.labelStyle.textColor = [UIColor darkGrayColor];
    //    yAxis.minorTickInterval = @10;
    //    yAxis.style.minorTickStyle.ticksHidden = NO;
    //    yAxis.majorTickInterval = @1;
    yAxis.title = @"Temp.";
    yAxis.style.titleStyle.textColor = [UIColor darkGrayColor];
    self.chartView.yAxis = yAxis;
    
    NSInteger fontSize = ([self cycleLength] > 30) ? 6 : 10;
    
    TKChartNumericAxis *xAxis = [[TKChartNumericAxis alloc] initWithMinimum: @0 andMaximum: @([self cycleLength])];
    xAxis.style.labelStyle.textColor = [UIColor darkGrayColor];
    xAxis.style.labelStyle.font = [UIFont boldSystemFontOfSize: fontSize];
    xAxis.majorTickInterval = @1;
    self.chartView.xAxis = xAxis;
}

- (void)addCoverLineToChart
{
    if (self.selectedCycle.coverline) {
        TKStroke *stroke = [TKStroke strokeWithColor:[UIColor purpleColor] width: 2];
        self.chartLineAnnotation = [[TKChartGridLineAnnotation alloc] initWithValue: self.selectedCycle.coverline forAxis: self.chartView.yAxis withStroke: stroke];
        [self.chartView addAnnotation: self.chartLineAnnotation];
    }
}

- (void)addFertilityWindowToChart
{
    NSInteger min = 0;
    NSInteger max = 0;
    
    NSArray *days = self.days;
    
    for (int i = 0; i < [days count]; i++) {
        Day *day = days[i];
        
        if (min == 0 && day.inFertilityWindow) {
            min = i;
            
        }else if (max == 0 && min != 0 && !day.inFertilityWindow) {
            max = i;
        }
    }
    
    if (min != 0 && max == 0) {
        max = [days count];
    }
    
    if (min != 0 && max != 0) {
        
        TKRange *range = [[TKRange alloc] initWithMinimum: [NSNumber numberWithInteger: min] andMaximum: [NSNumber numberWithInteger: max]];
        UIColor *color = [UIColor colorWithRed:(32.0f/255.0) green:(108.0f/255.0) blue:(114.0f/255.0) alpha:0.1];
        TKFill *fill = [TKSolidFill solidFillWithColor: color];
        [self.chartView addAnnotation: [[TKChartBandAnnotation alloc] initWithRange: range forAxis: self.chartView.xAxis withFill: fill withStroke: nil]];
        
    }
}

- (void)reloadCollectionViews
{
    [self.periodCollectionView reloadData];
    [self.cfCollectionView reloadData];
    [self.cpCollectionView reloadData];
    [self.sexCollectionView reloadData];
}

#pragma mark - TKChart Delegate

- (void)chart:(TKChart *)chart didSelectPoint:(id<TKChartData>)point inSeries:(TKChartSeries *)series atIndex:(NSInteger)index
{
    TKChartDataPoint *chartPoint = (TKChartDataPoint *)point;
    
    NSString *message = [NSString stringWithFormat: @"Temperature: %.2f", [chartPoint.dataYValue floatValue]];
    [TAOverlay showOverlayWithLabel: message Options: TAOverlayOptionOverlaySizeRoundedRect | TAOverlayOptionOverlayDismissTap | TAOverlayOptionOverlayTypeInfo];
}

- (TKChartPaletteItem *)chart:(TKChart *)chart paletteItemForPoint:(NSUInteger)index inSeries:(TKChartSeries *)series
{
    UIColor *colorForDay;
    
    if (index < [self.days count]) {
        Day *day = self.days[index];
        
        if ([day.temperature floatValue] == 0) {
            colorForDay = [UIColor clearColor];
        }else if(day.disturbance){
            colorForDay = [UIColor grayColor];
        }else{
            colorForDay = [self colorForCyclePhase: day.cyclePhase];
        }
        
    }else{
        colorForDay = [UIColor clearColor];
    }
    
    TKChartPaletteItem *item = [[TKChartPaletteItem alloc] initWithFill: [TKSolidFill solidFillWithColor: colorForDay]];
    
    return item;
}

#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cycleLength;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CycleCollectionViewCell *cell = [self.periodCollectionView  dequeueReusableCellWithReuseIdentifier: @"cycleCollectionViewCell" forIndexPath: indexPath];
    
    if (indexPath.row < [self.days count]) {
        
        Day *selectedDay = self.days[indexPath.row];
        UIImage *selectedImage;
        
        if (collectionView == self.periodCollectionView) {
            selectedImage = [self periodImageForDay: selectedDay];
            
        }else if(collectionView == self.cfCollectionView){
            selectedImage = [self cfImageForDay: selectedDay];
            
        }else if(collectionView == self.cpCollectionView){
            selectedImage = [self cpImageForDay: selectedDay];
            
        }else if(collectionView == self.sexCollectionView){
            selectedImage = [self sexImageForDay: selectedDay];
            
        }
        
        cell.iconImageView.image = selectedImage;
        
    }else{
        
        cell.iconImageView.image = nil;
        
    }
    
//    cell.layer.borderWidth = 1.0f;
//    cell.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    cell.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger numDays = self.cycleLength;
    NSInteger numParts = numDays - 1;
    
    if (numDays == 1) {
        return CGSizeMake(self.periodCollectionView.frame.size.width, self.periodCollectionView.frame.size.height);
    }
    
    CGFloat width = self.periodCollectionView.frame.size.width / numParts;
    CGFloat height = self.periodCollectionView.frame.size.height;
    
//    if (indexPath.row == numDays - 2 || indexPath.row == numDays - 1) {
//        // Last 2 cells
//        width = width / 2;
//    }
    
    CGSize size = CGSizeMake(width, height);
    return size;
}

#pragma mark - Missing/Duplicate Days Helper's

- (NSArray *)addMissingDatesToArray:(NSArray *)days
{
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    
    Day *firstDay = days[0];
    [newArray addObject: firstDay];
    
    for (int i = 1; i < [days count]; i++) {
        
        Day *previousDay = days[i - 1];
        Day *currentDay = days[i];
        
        NSInteger daysBetween = [self daysBetweenDate: previousDay.date andDate: currentDay.date];
        
        if (daysBetween == 0) {
            // Duplicate Day, Ignore
            continue;
            
        }else if(daysBetween == 1){
            // Next day is has next day's date. GOOD. Add to new array.
            [newArray addObject: currentDay];
            
        }else {
            // There is a SPACE between dates. Fill with empty days with the correct dates.
            Day *firstDay = previousDay;
            for (int j = 0; j < daysBetween - 1; j++) {
                NSDate *tomorrowDate = [self nextDayFromDate: firstDay.date];
                Day *newDay = [self emptyDayWithDate: tomorrowDate];
                [newArray addObject: newDay];
                firstDay = newDay;
            }
            
            [newArray addObject: currentDay];
        }
    }
    
    return [NSArray arrayWithArray: newArray];
}

- (Day *)emptyDayWithDate:(NSDate *)date
{
    Day *day = [[Day alloc] init];
    day.date = date;
    day.idate = [self.dateFormatter stringFromDate: date];
    return day;
}

- (NSDate *)nextDayFromDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingUnit: NSCalendarUnitDay
                                value: 1
                               toDate: date
                              options: kNilOptions];
}

- (NSInteger)daysBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate: &fromDate interval: NULL forDate: fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate: &toDate interval: NULL forDate: toDateTime];
    
    NSDateComponents *difference = [calendar components: NSCalendarUnitDay fromDate: fromDate toDate: toDate options: 0];
    
    return [difference day];
}

#pragma mark - Helper's

- (CGFloat)getPreviousNonZeroTemperatureInArray:(NSArray *)array fromIndex:(NSInteger)index
{
    for (NSInteger i = index - 1; i >=0 ; i--) {
        Day *day = array[i];
        CGFloat temperature = [day.temperature floatValue];
        if (temperature != 0) {
            return temperature;
        }
    }
    return 0;
}

- (CGFloat)correctTempWithUnit:(CGFloat)fahrenheitTemperature
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey: @"temperatureUnitPreferenceFahrenheit"]) {
        return fahrenheitTemperature;
        
    } else {
        if (fahrenheitTemperature != 0) {
            return ((fahrenheitTemperature - 32) / 1.8000f);
        }
    }
    return 0;
}

- (UIColor *)colorForCyclePhase:(NSString *)cyclePhase
{
    UserProfile *currentUserProfile = [UserProfile current];
    
    if ([cyclePhase isEqualToString: @"period"]) {
        return [UIColor il_darkRedColor];
        
    }else if([cyclePhase isEqualToString: @"ovulation"]){
        // Fertile
        return (currentUserProfile.tryingToConceive)? [UIColor il_greenColor] : [UIColor il_lightRedColor];
        
    }else if([cyclePhase isEqualToString: @"preovulation"]){
        // Not Fertile ... Warning
        return (currentUserProfile.tryingToConceive)? [UIColor il_purple] : [UIColor il_yellowColor];
        
    }else if([cyclePhase isEqualToString: @"postovulation"]){
        // Not Fertile
        return (currentUserProfile.tryingToConceive)? [UIColor il_purple] : [UIColor il_greenColor];
        
    }else{
        return [UIColor darkGrayColor];
    }
}

- (UIImage *)periodImageForDay:(Day *)day
{
    if ([day.period isEqualToString: @"none"]) {
        return nil;
        
    }else if ([day.period isEqualToString: @"spotting"]) {
        return [UIImage imageNamed: @"icn_p_spotting"];
        
    }else if ([day.period isEqualToString: @"light"]) {
        return [UIImage imageNamed: @"icn_p_light"];
        
    }else if ([day.period isEqualToString: @"medium"]) {
        return [UIImage imageNamed: @"icn_p_medium"];
        
    }else if ([day.period isEqualToString: @"heavy"]) {
        return [UIImage imageNamed: @"icn_p_heavy"];
        
    }else{
        return nil;
    }
}

- (UIImage *)cfImageForDay:(Day *)day
{
    if ([day.cervicalFluid isEqualToString: @"dry"]) {
        return [UIImage imageNamed: @"icn_cf_dry"];
        
    }else if ([day.cervicalFluid isEqualToString: @"sticky"]) {
        return [UIImage imageNamed: @"icn_cf_sticky"];
        
    }else if ([day.cervicalFluid isEqualToString: @"creamy"]) {
        return [UIImage imageNamed: @"icn_cf_creamy"];
        
    }else if ([day.cervicalFluid isEqualToString: @"eggwhite"]) {
        return [UIImage imageNamed: @"icn_cf_eggwhite"];
        
    }else{
        return nil;
    }
}

- (UIImage *)cpImageForDay:(Day *)day
{
    if ([day.cervicalPosition isEqualToString: @"low/closed/firm"]) {
        return [UIImage imageNamed: @"icn_cp_lowclosedfirm"];
        
    }else if ([day.cervicalPosition isEqualToString: @"high/open/soft"]) {
        return [UIImage imageNamed: @"icn_cp_highopensoft"];
        
    }else{
        return nil;
    }
}

- (UIImage *)sexImageForDay:(Day *)day
{
    if ([day.intercourse isEqualToString: @"protected"]) {
        return [UIImage imageNamed: @"icn_i_protected"];
        
    }else if ([day.intercourse isEqualToString: @"unprotected"]) {
        return [UIImage imageNamed: @"icn_i_unprotected"];
        
    }else{
        return nil;
    }
}

#pragma mark - Set/Get

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

- (NSInteger)cycleLength
{
    NSInteger selectedCycleLength = [self.days count];
    NSInteger cycleLength = (selectedCycleLength >= 30) ? selectedCycleLength : 30;
    
    return cycleLength;
}

@end
