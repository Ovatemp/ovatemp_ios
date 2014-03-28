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
#import "UIViewController+Loading.h"
#import "ConnectionManager.h"

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
  CGFloat itemWidth = container.size.width / 2 - .5;
  CGFloat itemHeight = container.size.height / 2;
  layout.itemSize = CGSizeMake(itemWidth, itemHeight);
  layout.minimumInteritemSpacing = .5;
  layout.minimumLineSpacing = .5;

  layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);  // top, left, bottom, right
  [self.collectionView setCollectionViewLayout:layout];
  self.collectionView.showsVerticalScrollIndicator = FALSE;
  self.collectionView.scrollsToTop = FALSE;
  self.collectionView.backgroundColor = [UIColor blackColor];

  self.itemNames = @[@"Diet", @"Supplements", @"Exercise", @"Habits"];
}

# pragma mark - UICollectionViewDataSource/Delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.itemNames.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  CoachingWebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CoachingWebViewController"];

  NSString *name = self.itemNames[indexPath.row];
  vc.titleLabel.text = name;

  [self startLoading];

  NSString *url = [Configuration sharedConfiguration].coachingContentUrls[name];

  [ConnectionManager get:url params:@{}
                 success:^(NSData *response) {
                   NSString *content = [[NSString alloc] initWithData:response
                                                             encoding:NSUTF8StringEncoding];
                   vc.webViewContents = content;
                   [self.navigationController pushViewController:vc animated:YES];
                   [self stopLoading];
                 }
                 failure:^(NSError *error) {
                   NSLog(@"failed to load");
                   [self stopLoading];
                 }];

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  LifestyleCell *cell= (LifestyleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"LifestyleCell" forIndexPath:indexPath];

  cell.imageView.image = [UIImage imageNamed:self.itemNames[indexPath.row]];
  cell.titleLabel.text = self.itemNames[indexPath.row];

  return cell;
}

- (IBAction)backButtonTapped:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotate {
  return FALSE;
}

@end
