//
//  ILSummaryDetailViewController.m
//  Ovatemp
//
//  Created by Daniel Lozano on 6/3/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILSummaryDetailViewController.h"

#import "User.h"
#import "ILCheckmarkView.h"
#import "CoachingDataStore.h"

@interface ILSummaryDetailViewController ()

@end

@implementation ILSummaryDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self currentWeek];
    
    [self customizeAppearance];
    [self setUpWebView];

    [self updateScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Appearance / SetUp

- (void)customizeAppearance
{
    self.title = @"Coaching";
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(didSelectDone)];
    [self.topBar addGestureRecognizer: recognizer];
    
    NSString *profileName = [User current].fertilityProfileName;
    self.profileLabel.text = [profileName capitalizedString];
    self.profileImageView.image = [UIImage imageNamed:[profileName stringByAppendingString: @"_small"]];
    
    self.activityTitleLabel.text = self.activityName;
    self.activitySubtitleLabel.text = self.timeOfDay;
    self.activityImageView.image = [UIImage imageNamed: self.activityImageName];
}

- (void)updateScreen
{
    ILActivityType type = [self getActivityTypeForString: self.activityName];
    
    // Fill Out TODAY
    [[CoachingDataStore sharedSession] getStatusForActivityType: type
                                                        forDate: [NSDate date]
                                                 withCompletion:^(BOOL status) {
                                                     
                                                     self.doneCheckmark.isChecked = status;
                                                     
                                                 }];
    
    [self fillOutWeek];
    
}

- (void)setUpWebView
{
    if (self.urlString) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: self.urlString]];
        [self.webView loadRequest: request];
    }
}

#pragma mark - IBAction

- (void)didSelectDone
{
    BOOL previousState = self.doneCheckmark.isChecked;
    self.doneCheckmark.isChecked = !previousState;
    
    ILActivityType type = [self getActivityTypeForString: self.activityName];
    
    [[CoachingDataStore sharedSession] setStatus: !previousState
                                 forActivityType: type
                                         forDate: [NSDate date]
                                  withCompletion:^(NSError *error) {
                                      [self updateScreen];
                                  }];
}

#pragma mark - Helper's

- (ILActivityType)getActivityTypeForString:(NSString *)type
{
    if ([type isEqualToString: @"Lifestyle"]) {
        return ILActivityTypeLifestyle;
        
    }else if ([type isEqualToString: @"Acupressure"]) {
        return ILActivityTypeAcupressure;
        
    }else if ([type isEqualToString: @"Massage"]) {
        return ILActivityTypeMassage;
        
    }else {
        return ILActivityTypeMeditation;
    }
}

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
    }];
    
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

- (void)currentWeek
{
    NSDate *today = [NSDate date];
    NSLog(@"Today date is %@",today);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    //Week Start Date
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [gregorian components: NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:today];
    
    NSInteger dayofweek = [[[NSCalendar currentCalendar] components: NSCalendarUnitWeekday fromDate: today] weekday];
    [components setDay:([components day] - ((dayofweek) - 1))];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents: components];
    NSDateFormatter *dateFormat_first = [[NSDateFormatter alloc] init];
    [dateFormat_first setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString2Prev = [dateFormat stringFromDate:beginningOfWeek];
    
    NSDate *weekstartPrev = [dateFormat_first dateFromString:dateString2Prev];
    
    NSLog(@"StartDate:%@", weekstartPrev);

    //Week End Date
    
    NSCalendar *gregorianEnd = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    NSDateComponents *componentsEnd = [gregorianEnd components: NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:today];
    
    NSInteger Enddayofweek = [[[NSCalendar currentCalendar] components: NSCalendarUnitWeekday fromDate: today] weekday];
    
    [componentsEnd setDay:([componentsEnd day] + (7 - Enddayofweek))];
    
    NSDate *EndOfWeek = [gregorianEnd dateFromComponents:componentsEnd];
    NSDateFormatter *dateFormat_End = [[NSDateFormatter alloc] init];
    [dateFormat_End setDateFormat:@"yyyy-MM-dd"];
    NSString *dateEndPrev = [dateFormat stringFromDate:EndOfWeek];
    
    NSDate *weekEndPrev = [dateFormat_End dateFromString:dateEndPrev];
    NSLog(@"EndDate:%@", weekEndPrev);
}

@end
