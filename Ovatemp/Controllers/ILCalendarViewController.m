//
//  ILCalendarViewController.m
//  Ovatemp
//
//  Created by Daniel Lozano on 3/23/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILCalendarViewController.h"

#import "Day.h"
#import "Calendar.h"
#import "UIColor+Traits.h"
#import "ILCalendarCell.h"

@interface ILCalendarViewController () <TKCalendarDataSource,TKCalendarDelegate>

@property (nonatomic) TKCalendar *calendarView;
@property (nonatomic) NSMutableArray *events;

@end

@implementation ILCalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customizeAppearance];
    [self setUpCalendar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction's

- (void)didSelectDone
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction)didSelectBack:(id)sender
{
    [self.calendarView navigateBack: YES];
}

- (IBAction)didSelectForward:(id)sender
{
    [self.calendarView navigateForward: YES];
}

#pragma mark - Appearance

- (void)customizeAppearance
{
    //self.title = @"Calendar";
    //[self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor darkGrayColor]}];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(didSelectDone)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)setUpCalendar
{
    // Create Calendar View
    
    self.calendarView = [[TKCalendar alloc] init];
    self.calendarView.translatesAutoresizingMaskIntoConstraints = NO;
    self.calendarView.dataSource = self;
    self.calendarView.delegate = self;
    
    self.calendarView.minDate = [TKCalendar dateWithYear: 2014 month: 1 day: 1 withCalendar:nil];
    self.calendarView.maxDate = [NSDate date];
    
    self.calendarView.viewMode = TKCalendarViewModeMonth;
    self.calendarView.selectionMode = TKCalendarSelectionModeSingle;
    //self.calendarView.backgroundColor = [UIColor colorWithRed: 245.0/255.0 green: 245.0/255.0 blue: 245.0/255.0 alpha: 1];

    TKCalendarMonthPresenter *presenter = (TKCalendarMonthPresenter *)self.calendarView.presenter;
    presenter.transitionMode = TKCalendarTransitionModeScroll;
    
    [self.view addSubview: self.calendarView];
    [self addConstraintsToView];
}

#pragma mark - TKCalendar Data Source

//- (NSArray *)calendar:(TKCalendar *)calendar eventsForDate:(NSDate *)date
//{
//    return nil;
//}

- (void)calendar:(TKCalendar *)calendar updateVisualsForCell:(TKCalendarCell *)cell;
{
    if ([cell isKindOfClass:[TKCalendarDayCell class]]) {
        ILCalendarCell *dayCell = (ILCalendarCell *)cell;
        
        Day *day = [Day forDate: dayCell.date];
        if(day) {
            if(day.cervicalFluid) {
                dayCell.dayType = CalendarDayTypePredictedFertile;
            } else if(day.period) {
                dayCell.dayType = CalendarDayTypePeriod;
            }else{
                dayCell.dayType = CalendarDayTypeNone;
            }
        }else{
            dayCell.dayType = CalendarDayTypeNone;
        }
        
    }
}

- (TKCalendarCell *)calendar:(TKCalendar *)calendar viewForCellOfKind:(TKCalendarCellType)cellType
{
    if (cellType == TKCalendarCellTypeDay) {
        ILCalendarCell *cell = [[ILCalendarCell alloc] init];
        return cell;
    }
    return nil;
}

#pragma mark - TKCalendar Delegate

- (BOOL)calendar:(TKCalendar *)calendar shouldSelectDate:(NSDate *)date
{
    return YES;
}

- (void)calendar:(TKCalendar *)calendar didSelectDate:(NSDate *)date
{
    if ([self.delegate respondsToSelector: @selector(didSelectDateInCalendar:)]) {
        [self.delegate didSelectDateInCalendar: date];
    }
}

#pragma mark - Helper's

- (void)addConstraintsToView
{
    NSDictionary *viewsDictionary = @{@"calendarView" : self.calendarView,
                                      @"infoView" : self.infoView};
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-0-[calendarView]-0-[infoView]"
                                                                           options: 0
                                                                           metrics: nil
                                                                             views: viewsDictionary];
    
    NSArray *calendarConstraintsHorizontal = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-0-[calendarView]-0-|"
                                                                                     options: 0
                                                                                     metrics: nil
                                                                                       views: viewsDictionary];
    
    NSLayoutConstraint *calendarHeightConstraint = [NSLayoutConstraint constraintWithItem: self.calendarView
                                                                                attribute: NSLayoutAttributeHeight
                                                                                relatedBy: NSLayoutRelationEqual
                                                                                   toItem: self.view
                                                                                attribute: NSLayoutAttributeHeight
                                                                               multiplier: .88
                                                                                 constant: 0];
    
    
    [self.view addConstraints: verticalConstraints];
    [self.view addConstraints: calendarConstraintsHorizontal];
    [self.view addConstraints: @[calendarHeightConstraint]];
}

@end
