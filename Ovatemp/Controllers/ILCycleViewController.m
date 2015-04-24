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

@interface ILCycleViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,TKChartDelegate>

@property (nonatomic) TKChart *chartView;
@property (nonatomic) TKChartLineSeries *chartSeries;
@property (nonatomic) TKChartGridLineAnnotation *chartLineAnnotation;
@property (nonatomic) TKChartBandAnnotation *chartBandAnnotation;

@property (nonatomic) NSMutableArray *temperatureData;
@property (nonatomic) NSInteger cycleLength;

@property (nonatomic) UISwipeGestureRecognizer *swipeLeft;
@property (nonatomic) UISwipeGestureRecognizer *swipeRight;

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
    
    [self updateScreen];
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
    NSArray *days = self.selectedCycle.days;
    
    // ADD EXISTING DAYS TO TEMP. DATA
    for (int i = 0; i < [days count]; i++) {
        
        Day *day = days[i];
        CGFloat temperature;
        
        if (!day.temperature) {
            temperature = 0;
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey: @"temperatureUnitPreferenceFahrenheit"]) {
            temperature = [day.temperature floatValue];
            
        } else {
            if ([day.temperature floatValue] != 0) {
                temperature = (([day.temperature floatValue] - 32) / 1.8000f);
            }
        }
        
        [self.temperatureData addObject: [[TKChartDataPoint alloc] initWithX: @(i+1) Y: @(temperature)]];
        
    }
    
    // FILL OUT REMAINDER OF CYCLE
    if ([days count] < self.cycleLength) {
        for (NSInteger i = [days count]; i < self.cycleLength; i++) {
            [self.temperatureData addObject:[[TKChartDataPoint alloc] initWithX: @(i+1) Y: @(0)]];
        }
    }
    
    //NSLog(@"DAYS: %@", self.selectedCycle.days);
    //NSLog(@"TEMPERATURE DATA: %@", self.temperatureData);
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
    NSInteger minTempRoundedMinusOne = [minTempRounded integerValue] - 1;
    NSInteger maxTempRoundedMinusOne = [maxTempRounded integerValue] + 1;
    
    TKChartNumericAxis *yAxis = [[TKChartNumericAxis alloc] initWithMinimum: @(minTempRoundedMinusOne) andMaximum: @(maxTempRoundedMinusOne)];
    yAxis.style.labelStyle.textOffset = UIOffsetMake(2, 0);
    yAxis.style.labelStyle.textColor = [UIColor darkGrayColor];
    //    yAxis.minorTickInterval = @10;
    //    yAxis.style.minorTickStyle.ticksHidden = NO;
    //    yAxis.majorTickInterval = @1;
    yAxis.title = @"Temp.";
    yAxis.style.titleStyle.textColor = [UIColor darkGrayColor];
    self.chartView.yAxis = yAxis;
    
    TKChartNumericAxis *xAxis = [[TKChartNumericAxis alloc] initWithMinimum: @0 andMaximum: @(self.cycleLength)];
    xAxis.style.labelStyle.textColor = [UIColor darkGrayColor];
    xAxis.style.labelStyle.font = [UIFont boldSystemFontOfSize: 10];
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
    
    NSArray *days = self.selectedCycle.days;
    
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
    
    if (index < [self.selectedCycle.days count]) {
        Day *day = self.selectedCycle.days[index];
        colorForDay = [self colorForCyclePhase: day.cyclePhase];
        
    }else{
        colorForDay = [UIColor purpleColor];
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
    
    if (indexPath.row < [self.selectedCycle.days count]) {
        
        Day *selectedDay = self.selectedCycle.days[indexPath.row];
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

#pragma mark - Helper's

- (UIColor *)colorForCyclePhase:(NSString *)cyclePhase
{
    UIColor *periodColor = PERIOD_COLOR;
    UIColor *notFertileColor = [UIColor purpleColor];
    UIColor *fertileColor = [UIColor ovatempAquaColor];
    
    if ([cyclePhase isEqualToString: @"period"]) {
        return periodColor;
        
    }else if([cyclePhase isEqualToString: @"ovulation"]){
        return fertileColor;
        
    }else if([cyclePhase isEqualToString: @"preovulation"]){
        return notFertileColor;
        
    }else if([cyclePhase isEqualToString: @"postovulation"]){
        return notFertileColor;
        
    }else{
        return notFertileColor;
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

- (NSInteger)cycleLength
{
    if (!_cycleLength) {
        NSInteger profileCycleLength = [[UserProfile current].cycleLength integerValue];
        _cycleLength = profileCycleLength != 0 ? profileCycleLength : 30;
    }
    
    return _cycleLength;
}

@end
