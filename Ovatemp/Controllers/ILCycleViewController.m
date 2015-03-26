//
//  ILCycleViewController.m
//  Ovatemp
//
//  Created by Daniel Lozano on 3/25/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILCycleViewController.h"

#import <TelerikUI/TelerikUI.h>

#import "Cycle.h"
#import "Calendar.h"
#import "CycleCollectionViewCell.h"

@interface ILCycleViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) TKChart *chartView;
@property (nonatomic) NSMutableArray *temperatureData;

@end

@implementation ILCycleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self customizeAppearance];
    
    [self setUpChartData];
    [self setUpChart];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self reloadCollectionViews];
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

#pragma mark - Set/Get

- (void)setSelectedCycle:(Cycle *)selectedCycle
{
    _selectedCycle = selectedCycle;
}

#pragma mark - IBAction's

- (void)didSelectDoneButton
{
    [[UIDevice currentDevice] setValue: [NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey: @"orientation"];
    [self dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Appearance

- (void)customizeAppearance
{
    self.title = self.selectedCycle.rangeString;
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor darkGrayColor]}];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(didSelectDoneButton)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)setUpChartData
{
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
    if ([days count] < 30) {
        for (NSInteger i = [days count]; i < 30; i++) {
            [self.temperatureData addObject:[[TKChartDataPoint alloc] initWithX: @(i+1) Y: @(0)]];
        }
    }
    
}

- (void)setUpCollectionViewsData
{
    
}

- (void)setUpChart
{
    self.chartView = [[TKChart alloc] init];
    self.chartView.translatesAutoresizingMaskIntoConstraints = NO;

    TKChartLineSeries *series = [[TKChartLineSeries alloc] initWithItems: self.temperatureData];
    series.style.palette = [[TKChartPalette alloc] init];
    TKChartPaletteItem *palleteItem = [[TKChartPaletteItem alloc] init];
    palleteItem.stroke = [TKStroke strokeWithColor: [UIColor darkGrayColor] width: 1];
    [series.style.palette addPaletteItem: palleteItem];
    
    series.style.pointShape = [TKPredefinedShape shapeWithType: TKShapeTypeCircle andSize: CGSizeMake(8, 8)];
    TKChartPaletteItem *paletteItem = [[TKChartPaletteItem alloc] init];
    paletteItem.fill = [TKSolidFill solidFillWithColor: [UIColor purpleColor]];
    TKChartPalette *palette = [[TKChartPalette alloc] init];
    [palette addPaletteItem:paletteItem];
    series.style.shapePalette = palette;

    [self.chartView addSeries: series];
    
    if (self.selectedCycle.coverline) {
        TKStroke *stroke = [TKStroke strokeWithColor:[UIColor purpleColor] width: 2];
        [self.chartView addAnnotation: [[TKChartGridLineAnnotation alloc] initWithValue: self.selectedCycle.coverline forAxis: self.chartView.yAxis withStroke: stroke]];
    }
    
    self.chartView.title.hidden = YES;
    self.chartView.legend.hidden = YES;
    self.chartView.allowAnimations = NO;
    
    [self.view addSubview: self.chartView];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    NSDictionary *viewsDictionary = @{@"chartView" : self.chartView,
                                     @"periodView" : self.periodCollectionView};
    
    NSArray *chartHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-44-[chartView]-6-|"
                                                                                  options: 0
                                                                                  metrics: nil
                                                                                    views: viewsDictionary];
    
    NSArray *chartVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-0-[chartView]-5-[periodView]"
                                                                                options: 0
                                                                                metrics: nil
                                                                                  views: viewsDictionary];
    

    
    [self.view addConstraints: chartHorizontalConstraints];
    [self.view addConstraints: chartVerticalConstraints];
}

- (void)reloadCollectionViews
{
    [self.periodCollectionView reloadData];
    [self.cfCollectionView reloadData];
    [self.cpCollectionView reloadData];
    [self.sexCollectionView reloadData];
}

#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CycleCollectionViewCell *cell = [self.periodCollectionView  dequeueReusableCellWithReuseIdentifier: @"cycleCollectionViewCell" forIndexPath: indexPath];
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = collectionView.frame.size.width / 30;
    CGFloat height = collectionView.frame.size.height;
    CGSize size = CGSizeMake(width, height);
    
    return size;
}

@end
