//
//  LifestyleViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/24/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "LifestyleViewController.h"
#import "LifestyleCell.h"
#import "UINavigationItem+IconLabel.h"
#import "ConnectionManager.h"
#import "WebViewController.h"

@interface LifestyleViewController ()

@property (nonatomic, strong) NSArray *itemNames;

@end

@implementation LifestyleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;

    self.edgesForExtendedLayout = UIRectEdgeNone;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    CGRect container = self.collectionView.frame;
    container = UIEdgeInsetsInsetRect(container, self.collectionView.contentInset);
    CGFloat itemWidth = container.size.width / 2 - 0.5;
    CGFloat itemHeight = container.size.height / 2 - 44.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 1.0;

    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);  // top, left, bottom, right
    [self.collectionView setCollectionViewLayout:layout];

    self.itemNames = @[@"Diet", @"Supplements", @"Exercise", @"Habits"];
    self.collectionView.backgroundColor = [LIGHT darkenBy:0.2];
}

# pragma mark - UICollectionViewDataSource/Delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemNames.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = self.itemNames[indexPath.row];
    NSString *url = [Configuration sharedConfiguration].coachingContentUrls[name];

    WebViewController *webViewController = [WebViewController withURL:url];
    webViewController.navigationItem.title = name;
    UIImage *image = [UIImage imageNamed:[name stringByAppendingString:@"Small"]];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    webViewController.navigationItem.titleIcon = image;
    webViewController.navigationItem.iconLabel.tintColor = LIGHT;
    webViewController.navigationItem.iconLabel.textColor = LIGHT;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LifestyleCell *cell= (LifestyleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"LifestyleCell" forIndexPath:indexPath];

    cell.imageView.image = [UIImage imageNamed: self.itemNames[indexPath.row]];
    cell.titleLabel.text = self.itemNames[indexPath.row];

    return cell;
}

- (BOOL)shouldAutorotate
{
    return FALSE;
}

@end
