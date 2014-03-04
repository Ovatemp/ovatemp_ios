//
//  CalendarViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/4/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarCell.h"

static NSString * const kCalendarCellIdentifier = @"CalendarCell";

@interface CalendarViewController () {

}

@end

@implementation CalendarViewController

- (id)initWithDefaultLayoutAndFrameHint:(CGRect)frame {
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

  layout.minimumInteritemSpacing = 0;
  layout.minimumLineSpacing = 0;

  CGFloat itemWidth = frame.size.width / 8;
  layout.itemSize = CGSizeMake(itemWidth, itemWidth * 1.2);

  self = [super initWithCollectionViewLayout:layout];
  if(!self) {
    return nil;
  }

  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.collectionView registerNib:[UINib nibWithNibName:kCalendarCellIdentifier bundle:nil] forCellWithReuseIdentifier:kCalendarCellIdentifier];

  [self.collectionView setBackgroundColor:[UIColor whiteColor]];
  NSLog(@"frame: %@, collection view frame: %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.collectionView.frame));
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return 70;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  CalendarCell *cell= (CalendarCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];

  NSLog(@"index path section: %ld", (long)indexPath.section);
  cell.dateLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.item];
  cell.imageView.image = [UIImage imageNamed:@"Light"];
  
  return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsMake(0,10,0,10);  // top, left, bottom, right
}

@end
