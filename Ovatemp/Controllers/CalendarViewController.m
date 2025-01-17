//
//  CalendarViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/4/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "CalendarViewController.h"

#import "Alert.h"
#import "CalendarCell.h"
#import "Calendar.h"
#import "NSDate+CalendarOps.h"

static NSString * const kCalendarCellIdentifier = @"CalendarCell";

@interface CalendarViewController () {
  BOOL loaded;
  NSInteger year;
}

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

  [[Calendar sharedInstance] addObserver: self
                              forKeyPath: @"day"
                                 options: NSKeyValueObservingOptionNew
                                 context: NULL];

  [self refresh];

  if (![Cycle fullyLoaded]) {
    [self startLoading];
    [Cycle loadAllAnd:^(id response) {
      [self stopLoading];
      [self refresh];
      loaded = YES;
    } failure:^(NSError *error) {
      [self stopLoading];
      [Alert presentError:error];
    }];
  }
}

- (void)refresh {
  [self.collectionView reloadData];
  [self scrollToCurrentDay];
  [self.fertilityStatusView updateWithDay:[Day forDate:[NSDate date]]];
  [self trackScreenView:@"Calendar"];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[Calendar sharedInstance] removeObserver:self forKeyPath:@"day"];
}

- (BOOL)shouldAutorotate {
  return FALSE;
}

- (void)scrollToCurrentDay {
  if([Calendar day] == nil) { return; }

  NSInteger todayIndex = [[Cycle firstDate] daysTilDate:[Calendar day].date];
  NSIndexPath *todayIndexPath = [NSIndexPath indexPathForItem:todayIndex inSection:0];

  [self.collectionView scrollToItemAtIndexPath:todayIndexPath
                              atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                      animated:NO];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context {
  if([keyPath isEqualToString:@"day"] && [[Calendar sharedInstance] class] == [object class]) {
    [self scrollToCurrentDay];
  }
}

# pragma mark - Helpers

- (NSDate *)dateForItemAtIndexPath:(NSIndexPath *)indexPath {
  return [[Cycle firstDate] addDays:indexPath.item];
}

# pragma mark - UICollectionViewDataSource/Delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return [Cycle totalDays];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSDate *date = [self dateForItemAtIndexPath:indexPath];

  if([[NSDate date] compare:date] != NSOrderedDescending) {
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

  if (loaded && comps.year != year) {
    year = comps.year;
    [self flashStatus:@(year).stringValue];
  }

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

  cell.dateLabel.text = [NSString stringWithFormat:@"%ld", (long)comps.day];

  // If the cell is the first day of the month
  if(comps.day == 1) {
    cell.monthLabel.text = [date shortMonth];
  } else {
    cell.monthLabel.text = nil;
  }
  cell.leftBorder.hidden = TRUE;

  // If the cell is today
  if([today isEqualToDate:date]) {
    cell.dateLabel.backgroundColor = PURPLE;
    [cell.dateLabel.layer setMasksToBounds:YES];
    cell.dateLabel.layer.cornerRadius = 8;
    cell.dateLabel.textColor = LIGHT;
  } else {
    cell.dateLabel.textColor = DARK;
    cell.dateLabel.backgroundColor = [UIColor clearColor];
  }

  if([date compare:today] == NSOrderedDescending) {
    cell.backgroundColor = LIGHT_GREY;
  } else {
    cell.backgroundColor = [UIColor clearColor];
  }

  [cell needsUpdateConstraints];
  return cell;
}

@end
