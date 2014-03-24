//
//  LifestyleViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/24/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "LifestyleViewController.h"
#import "LifestyleCell.h"
#import "CoachingWebViewController.h"

@interface LifestyleViewController ()

@property (nonatomic, strong) NSArray *itemNames;

@end

@implementation LifestyleViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.edgesForExtendedLayout = UIRectEdgeNone;

  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

  CGRect container = self.collectionView.frame;
  CGFloat itemWidth = container.size.width / 2;
  CGFloat itemHeight = container.size.height / 2;
  layout.itemSize = CGSizeMake(itemWidth, itemHeight);
  layout.minimumInteritemSpacing = 0;
  layout.minimumLineSpacing = 0;

  layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);  // top, left, bottom, right
  [self.collectionView setCollectionViewLayout:layout];
  self.collectionView.showsVerticalScrollIndicator = FALSE;
  self.collectionView.scrollsToTop = FALSE;

  self.itemNames = @[@"Diet", @"Supplements", @"Exercise", @"Meditation"];

}

# pragma mark - UICollectionViewDataSource/Delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.itemNames.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  CoachingWebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CoachingWebViewController"];
  vc.titleLabel.text = self.itemNames[indexPath.row];

  NSString *htmlFilePath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"html"];
  NSString *contents = [NSString stringWithContentsOfFile:htmlFilePath
                                                 encoding:NSUTF8StringEncoding
                                                    error:NULL];

  NSLog(@"contents: %@", vc);

  vc.webViewContents = contents;
  [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  LifestyleCell *cell= (LifestyleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"LifestyleCell" forIndexPath:indexPath];

  cell.imageView.image = [UIImage imageNamed:@"Sticky"];
  cell.titleLabel.text = self.itemNames[indexPath.row];

  return cell;
}

@end
