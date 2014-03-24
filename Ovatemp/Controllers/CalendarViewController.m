//
//  CalendarViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/4/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarCell.h"
#import "Calendar.h"
#import "NSDate+CalendarOps.h"

static NSString * const kCalendarCellIdentifier = @"CalendarCell";

@interface CalendarViewController () {

}

@property (nonatomic, assign) NSInteger totalDays;
@property (nonatomic, strong) NSDate *firstDate;
@property (nonatomic, strong) NSDate *lastDate;

@end

@implementation CalendarViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  CGFloat itemWidth = self.view.frame.size.width / 8;
  layout.itemSize = CGSizeMake(itemWidth, itemWidth * 1.2);
  layout.minimumInteritemSpacing = 0;
  layout.minimumLineSpacing = 0;

  layout.sectionInset = UIEdgeInsetsMake(3, itemWidth / 2, 0, itemWidth / 2);  // top, left, bottom, right
  [self.collectionView setCollectionViewLayout:layout];
  self.collectionView.showsVerticalScrollIndicator = FALSE;
  self.collectionView.scrollsToTop = FALSE;

  [self.collectionView registerNib:[UINib nibWithNibName:kCalendarCellIdentifier bundle:nil] forCellWithReuseIdentifier:kCalendarCellIdentifier];
  [self.collectionView setBackgroundColor:[UIColor whiteColor]];


  [[Calendar sharedInstance] addObserver: self
                              forKeyPath: @"day"
                                 options: NSKeyValueObservingOptionNew
                                 context: NULL];

  [self setDateRange];

  NSArray *weekdays = [@"S M T W R F S" componentsSeparatedByString:@" "];
  for(int i=0; i < 7; i++) {
    CGRect frame = CGRectMake(i * itemWidth + layout.sectionInset.left, 0, itemWidth, self.headerView.frame.size.height);

    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = weekdays[i];
    label.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:label];
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [Cycle loadDatesFrom:self.firstDate to:self.lastDate success:^(NSDictionary *response){
    [self.collectionView reloadData];
    [self scrollToCurrentDay];
  } failure:^(NSError *error) {
    NSLog(@"couldn't refresh page");
  }];

  [self.fertilityStatusView updateWithDay:[Day forDate:[NSDate date]]];
}

- (void)scrollToCurrentDay {
  if([Calendar day] == nil) { return; }

  NSInteger todayIndex = [self.firstDate daysTilDate:[Calendar day].date];
  NSIndexPath *todayIndexPath = [NSIndexPath indexPathForItem:todayIndex inSection:0];

  [self.collectionView scrollToItemAtIndexPath:todayIndexPath
                              atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                      animated:NO];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context
{
  if([keyPath isEqualToString:@"day"] && [[Calendar sharedInstance] class] == [object class]) {
    [self scrollToCurrentDay];
  }
}

# pragma mark - Helpers

- (void)setDateRange {
  NSDate *today = [NSDate date];
  NSCalendar* calendar = [NSCalendar currentCalendar];
  NSDateComponents* comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:today];

  // Go to the end of two months from now
  [comps setMonth:[comps month]+3];
  [comps setDay:0];
  self.lastDate = [calendar dateFromComponents:comps];

  [comps setYear:1980];
  self.firstDate = [calendar dateFromComponents:comps];
  self.totalDays = [[[NSCalendar currentCalendar] components:NSDayCalendarUnit
                                                    fromDate:self.firstDate
                                                      toDate:self.lastDate
                                                     options:0] day];
}

- (NSDate *)dateForItemAtIndexPath:(NSIndexPath *)indexPath {
  return [self.firstDate addDays:indexPath.item];
}

# pragma mark - UICollectionViewDataSource/Delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.totalDays;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSDate *date = [self dateForItemAtIndexPath:indexPath];

  if([[NSDate date] compare:date] != NSOrderedDescending) {
    NSLog(@"can't go into the future");
    return;
  }

  [Calendar setDate:date];

  // Go to day view controller
  [self.tabBarController setSelectedIndex:0];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSCalendar *cal = [NSCalendar currentCalendar];
  CalendarCell *cell= (CalendarCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];

  NSDate *date = [self dateForItemAtIndexPath:indexPath];
  NSDateComponents *comps = [cal components:NSEraCalendarUnit | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
  date = [cal dateFromComponents:comps];

  Day *day = [Day forDate:date];
  BOOL inFertilityWindow = FALSE;
  cell.imageView.image = nil;
  
  if(day) {
    NSString *imageName;
    if(day.cervicalFluid) {
      imageName = [day imageNameForProperty:@"cervicalFluid"];
    } else if(day.period) {
      imageName = [day imageNameForProperty:@"period"];
    }
    if(imageName) {
      cell.imageView.image = [UIImage imageNamed:imageName];
    }

    inFertilityWindow = day.inFertilityWindow;
  }

  cell.fertilityWindowView.hidden = !inFertilityWindow;
  cell.fertilityWindowView.backgroundColor = FERTILITY_WINDOW_COLOR;

  NSDateComponents *todayComps = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
  NSDate *today = [cal dateFromComponents:todayComps];

  // If the cell is the first day of the month
  if(comps.day == 1) {
    cell.dateLabel.text = [date shortMonth];
    //cell.leftBorder.hidden = FALSE;
  } else {
    cell.dateLabel.text = [NSString stringWithFormat:@"%ld", (long)comps.day];
    //cell.leftBorder.hidden = TRUE;
  }
  cell.leftBorder.hidden = TRUE;

  // If the cell is today
  [cell.dateLabel sizeToFit];

  if([today isEqualToDate:date]) {
    cell.dateLabel.backgroundColor = CALENDAR_TODAY_COLOR;
    [cell.dateLabel.layer setMasksToBounds:YES];
    cell.dateLabel.layer.cornerRadius = 8;
    cell.dateLabel.textColor = [UIColor whiteColor];
  } else {
    cell.dateLabel.textColor = [UIColor blackColor];
    cell.dateLabel.backgroundColor = [UIColor clearColor];
  }

  if([date compare:today] == NSOrderedDescending) {
    cell.backgroundColor = CALENDAR_FUTURE_COLOR;
  } else {
    cell.backgroundColor = [UIColor clearColor];
  }
  cell.dateLabel.center = CGPointMake(cell.imageView.center.x, cell.dateLabel.center.y);

  [cell needsUpdateConstraints];
  return cell;
}

@end
