//
//  ILCoachingSummaryViewController.m
//  Ovatemp
//
//  Created by Daniel Lozano on 6/3/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILCoachingSummaryViewController.h"

#import "User.h"
#import "CoachingSummaryTableViewCell.h"
#import "ILSummaryDetailViewController.h"
#import "CoachingDataStore.h"
#import "ILCheckmarkView.h"
#import "NSArray+ILRandom.h"

@interface ILCoachingSummaryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray *rowNames;
@property (nonatomic) NSArray *timesOfDay;

@end

@implementation ILCoachingSummaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rowNames = [self getRowNames];
    self.timesOfDay = @[@"Morning", @"Afternoon", @"Evening", @"Evening"];
    
    NSString *profileName = [User current].fertilityProfileName;
    self.profileLabel.text = [profileName capitalizedString];
    self.profileImage.image = [UIImage imageNamed:[profileName stringByAppendingString:@"_small"]];
    
    [self customizeAppearance];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    NSIndexPath *selection = [self.tableView indexPathForSelectedRow];
    if (selection) {
        [self.tableView deselectRowAtIndexPath:selection animated:YES];
    }
    
    [self updateScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Appearance

- (void)customizeAppearance
{
    self.title = @"Coaching";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Back"
                                                                             style: UIBarButtonItemStyleDone
                                                                            target: nil action: nil];
    
    [self.navigationItem setHidesBackButton: YES animated: YES];
    self.navigationController.navigationBar.tintColor = [UIColor ovatempAquaColor];
}

- (void)updateScreen
{
    [self fillOutWeek];
}

#pragma mark - Shuffle Row Names

- (NSArray *)getRowNames
{
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier: NSCalendarIdentifierGregorian];
    
    NSDate *today = [NSDate date];
    NSDate *lastShuffleDate = [self lastShuffleDate];
    
    if (!lastShuffleDate) {
        return [self shuffleRowNames];
    }
    
    NSComparisonResult result = [calendar compareDate: today toDate: lastShuffleDate toUnitGranularity: NSCalendarUnitDay];
    if (result == NSOrderedSame) {
        // Last shuffle date is today
        return [self lastShuffleOrder];
    }else{
        // Last shuffle date is NOT today. Reshuffle array.
        return [self shuffleRowNames];
    }
}

- (NSArray *)shuffleRowNames
{
    NSArray *rowNames = @[@"Acupressure", @"Lifestyle", @"Massage", @"Meditation"];
    NSArray *shuffledNames = [rowNames shuffle];
    [self setLastShuffleDate: [NSDate date]];
    [self setLastShuffleOrder: shuffledNames];
    return shuffledNames;
}

#pragma mark - User Defaults (Shuffling)

- (NSArray *)lastShuffleOrder
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey: @"LastShuffleOrder"];
}

- (void)setLastShuffleOrder:(NSArray *)shuffleOrder
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: shuffleOrder forKey: @"LastShuffleOrder"];
}

- (NSDate *)lastShuffleDate
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey: @"LastShuffleDate"];
}

- (void)setLastShuffleDate:(NSDate *)date
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: date forKey: @"LastShuffleDate"];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rowNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CoachingSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"CoachingSummaryCell" forIndexPath: indexPath];
    
    cell.titleLabel.text = self.rowNames[indexPath.row];
    cell.subtitleLabel.text = self.timesOfDay[indexPath.row];
    
    NSString *iconImageName = [NSString stringWithFormat: @"%@Icon", self.rowNames[indexPath.row]];
    cell.imageView.image = [UIImage imageNamed: iconImageName];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ILSummaryDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier: @"ILSummaryDetailViewController"];

    NSString *categoryName = self.rowNames[indexPath.row];
    NSString *url = [Configuration sharedConfiguration].coachingContentUrls[categoryName];
    
    detailVC.urlString = url;
    detailVC.activityName = self.rowNames[indexPath.row];
    detailVC.timeOfDay = self.timesOfDay[indexPath.row];
    
    NSString *iconImageName = [NSString stringWithFormat: @"%@Icon", self.rowNames[indexPath.row]];
    detailVC.activityImageName = iconImageName;
    
    [self.navigationController pushViewController: detailVC animated: YES];
}

#pragma mark - Helper's

- (void)fillOutWeek
{
    NSDate *sunday = [self startOfWeekDate];
    NSDate *monday = [self nextDayFromDate: sunday];
    NSDate *tuesday = [self nextDayFromDate: monday];
    NSDate *wednesday = [self nextDayFromDate: tuesday];
    NSDate *thursday = [self nextDayFromDate: wednesday];
    NSDate *friday = [self nextDayFromDate: thursday];
    NSDate *saturday = [self nextDayFromDate: friday];
    
    [[CoachingDataStore sharedSession] getStatusForDate: sunday withCompletion:^(BOOL status) {
        
        self.sunCheckmark.isChecked = status;
        
        [[CoachingDataStore sharedSession] getStatusForDate: monday withCompletion:^(BOOL status) {
            self.monCheckmark.isChecked = status;
        }];
        
        [[CoachingDataStore sharedSession] getStatusForDate: tuesday withCompletion:^(BOOL status) {
            self.tuesCheckmark.isChecked = status;
        }];
        
        [[CoachingDataStore sharedSession] getStatusForDate: wednesday withCompletion:^(BOOL status) {
            self.wedCheckmark.isChecked = status;
        }];
        
        [[CoachingDataStore sharedSession] getStatusForDate: thursday withCompletion:^(BOOL status) {
            self.thurCheckmark.isChecked = status;
        }];
        
        [[CoachingDataStore sharedSession] getStatusForDate: friday withCompletion:^(BOOL status) {
            self.fridayCheckmark.isChecked = status;
        }];
        
        [[CoachingDataStore sharedSession] getStatusForDate: saturday withCompletion:^(BOOL status) {
            self.satCheckmark.isChecked = status;
        }];
        
    }];
    
}

- (NSDate *)nextDayFromDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingUnit: NSCalendarUnitDay
                                value: 1
                               toDate: date
                              options: kNilOptions];
}

- (NSDate *)startOfWeekDate
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [gregorian components: NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:today];
    
    NSInteger dayofweek = [[[NSCalendar currentCalendar] components: NSCalendarUnitWeekday fromDate: today] weekday];
    [components setDay:([components day] - ((dayofweek) - 1))];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents: components];
    NSDateFormatter *dateFormat_first = [[NSDateFormatter alloc] init];
    [dateFormat_first setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString2Prev = [dateFormat stringFromDate:beginningOfWeek];
    
    NSDate *weekstartPrev = [dateFormat_first dateFromString:dateString2Prev];
    
    return weekstartPrev;
}

@end
