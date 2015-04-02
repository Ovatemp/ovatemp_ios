//
//  ILCycleViewController.m
//  Ovatemp
//
//  Created by Daniel Lozano on 3/25/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILCycleViewController.h"

#import <TelerikUI/TelerikUI.h>
#import "TAOverlay.h"

#import "Cycle.h"
#import "Calendar.h"
#import "CycleCollectionViewCell.h"

@interface ILCycleViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,TKChartDelegate>

@property (nonatomic) TKChart *chartView;
@property (nonatomic) TKChartLineSeries *chartSeries;
@property (nonatomic) TKChartGridLineAnnotation *chartLineAnnotation;
@property (nonatomic) TKChartBandAnnotation *chartBandAnnotation;

@property (nonatomic) NSMutableArray *temperatureData;

@end

@implementation ILCycleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self customizeAppearance];
    [self setUpChart];
    
    [self loadAssets];
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

#pragma mark - Network

- (void)loadAssets
{
    if ([Cycle fullyLoaded]) {
        [self loadCycle];
        
    } else {
        [TAOverlay showOverlayWithLabel: @"Loading Cycles..." Options: TAOverlayOptionOverlaySizeRoundedRect];
        
        [Cycle loadAllAnd:^(id response) {
            
            [self loadCycle];
            [TAOverlay hideOverlay];
            
        } failure:^(NSError *error) {
            
            [TAOverlay hideOverlay];
            
        }];
    }
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
    
    [self reloadChart];
    [self reloadCollectionViews];
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

- (void)setUpChart
{
    self.chartView = [[TKChart alloc] init];
    self.chartView.delegate = self;
    self.chartView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.chartView.title.hidden = YES;
    self.chartView.legend.hidden = YES;
    self.chartView.allowAnimations = YES;
    
    [self.view addSubview: self.chartView];
}

- (void)setUpCollectionViewsData
{
    
}

- (void)reloadChart
{
    [self.chartView removeAllData];
    [self.chartView removeAllAnnotations];
    
    self.temperatureData = [[NSMutableArray alloc] init];
    
    NSArray *days = self.selectedCycle.days;
    
    // ADD EXISTING DAYS TO TEMP. DATA
    for (int i = 0; i < [days count]; i++) {
        
        Day *day = days[i];
        CGFloat temperature;
        
        if (!day.temperature || [day.temperature floatValue] == 0) {
            temperature = 0;
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey: @"temperatureUnitPreferenceFahrenheit"]) {
            temperature = [day.temperature floatValue];
            
        } else {
            temperature = (([day.temperature floatValue] - 32) / 1.8000f);
        }
        
        [self.temperatureData addObject: [[TKChartDataPoint alloc] initWithX: @(i+1) Y: @(temperature)]];
        
    }
    
    // FILL OUT REMAINDER OF CYCLE
//    if ([days count] < 30) {
//        for (NSInteger i = [days count]; i < 30; i++) {
//            [self.temperatureData addObject:[[TKChartDataPoint alloc] initWithX: @(i+1) Y: @(0)]];
//        }
//    }
    
    self.chartView.selectionMode = TKChartSelectionModeSingle;
    
    // TEMPERATURE(LINE) SERIES
    
    self.chartSeries = [[TKChartLineSeries alloc] initWithItems: self.temperatureData];
    self.chartSeries.style.palette = [[TKChartPalette alloc] init];
    TKChartPaletteItem *palleteItem = [[TKChartPaletteItem alloc] init];
    palleteItem.stroke = [TKStroke strokeWithColor: [UIColor darkGrayColor] width: 1];
    [self.chartSeries.style.palette addPaletteItem: palleteItem];
    
    self.chartSeries.style.pointShape = [TKPredefinedShape shapeWithType: TKShapeTypeCircle andSize: CGSizeMake(8, 8)];
    TKChartPaletteItem *paletteItem = [[TKChartPaletteItem alloc] init];
    paletteItem.fill = [TKSolidFill solidFillWithColor: [UIColor purpleColor]];
    TKChartPalette *palette = [[TKChartPalette alloc] init];
    [palette addPaletteItem:paletteItem];
    self.chartSeries.style.shapePalette = palette;
    
    self.chartSeries.selectionMode = TKChartSeriesSelectionModeDataPoint;
    
    [self.chartView addSeries: self.chartSeries];
    
    // AXIS CUSTOMIZATION
    
    TKChartNumericAxis *yAxis = [[TKChartNumericAxis alloc] init];
    yAxis.style.labelStyle.textOffset = UIOffsetMake(2, 0);
    yAxis.style.labelStyle.textColor = [UIColor darkGrayColor];
    yAxis.minorTickInterval = @10;
    yAxis.style.minorTickStyle.ticksHidden = NO;
    yAxis.title = @"Temp.";
    self.chartView.yAxis = yAxis;
    
//    TKChartNumericAxis *xAxis = [[TKChartNumericAxis alloc] init];
//    xAxis.style.labelStyle.textColor = [UIColor darkGrayColor];
//    xAxis.style.labelStyle.font = [UIFont boldSystemFontOfSize: 8];
//    xAxis.majorTickInterval = @1;
//    xAxis.style.majorTickStyle.ticksHidden = NO;
//    self.chartView.xAxis = xAxis;
    
    // COVER LINE ANNOTATION
    
    if (self.selectedCycle.coverline) {
        TKStroke *stroke = [TKStroke strokeWithColor:[UIColor purpleColor] width: 2];
        self.chartLineAnnotation = [[TKChartGridLineAnnotation alloc] initWithValue: self.selectedCycle.coverline forAxis: self.chartView.yAxis withStroke: stroke];
        [self.chartView addAnnotation: self.chartLineAnnotation];
    }
    
    // FERTILITY WINDOW PLOT BAND
    
    NSInteger min = 0;
    NSInteger max = 0;
    
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
    NSLog(@"SELECTED POINT: %@", point);
}

#pragma mark - IBAction's

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
        self.selectedCycle = nextCycle;
        [self hideLabels];
        [self updateScreen];
    }
}

#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.selectedCycle.days count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CycleCollectionViewCell *cell = [self.periodCollectionView  dequeueReusableCellWithReuseIdentifier: @"cycleCollectionViewCell" forIndexPath: indexPath];
    
//    NSInteger numDay = [self.selectedCycle.days count];

//    if (indexPath.row < numDay) {
    
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
        
//    }else{
//        
//        cell.iconImageView.image = nil;
//        
//    }
    
//    cell.layer.borderWidth = 1.0f;
//    cell.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    cell.backgroundColor = [UIColor yellowColor];
    
    return cell;
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

#pragma mark - UICollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = collectionView.frame.size.width / [self.selectedCycle.days count] + 1;
    CGFloat height = collectionView.frame.size.height;
    CGSize size = CGSizeMake(width, height);
    
    return size;
}

#pragma mark - Set/Get

- (void)setSelectedCycle:(Cycle *)selectedCycle
{
    _selectedCycle = selectedCycle;
}

@end
