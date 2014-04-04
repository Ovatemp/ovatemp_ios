//
//  CommunityForumsViewController.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/3/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "CommunityForumsViewController.h"

#import "CommunityForumViewController.h"

#import "UIColor+Traits.h"

static NSString * const kCommunityForumCellIdentifier = @"CommunityForumCell";
static NSArray const *kCommunityForums;
static NSString * const kForumName = @"name";
static NSString * const kForumIcon = @"icon";
static NSString * const kForumURL = @"url";

@interface CommunityForumsViewController () {
  NSDictionary *_selectedForum;
}
@end

@implementation CommunityForumsViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  if (!kCommunityForums) {
    kCommunityForums = @[
                         @{kForumName: @"Trying to Conceive",
                           kForumIcon: @"TryingToConceive.png",
                           kForumURL: @"/category/trying-to-conceive"},
                         @{kForumName: @"Trying to Avoid",
                           kForumIcon: @"TryingToAvoid.png",
                           kForumURL: @"/category/trying-to-avoid"},
                         @{kForumName: @"Share the good news",
                           kForumIcon: @"ShareTheNews.png",
                           kForumURL: @"/category/share-the-good-news"},
                         @{kForumName: @"Fertility Questions",
                           kForumIcon: @"FertilityQuestions.png",
                           kForumURL: @"/category/fertility-questions"},
                         @{kForumName: @"Ovatemp Support",
                           kForumIcon: @"OvatempSupport.png",
                           kForumURL: @"/category/ovatemp-support"},
                         ];
  }
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
//  self.navigationController.navigationBar.backgroundColor = LIGHT;
  self.navigationController.navigationBar.barTintColor = LIGHT;
  self.navigationController.navigationBar.tintColor = DARK;
  self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: DARK};
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return kCommunityForums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommunityForumCellIdentifier forIndexPath:indexPath];
  
  NSDictionary *forum = kCommunityForums[indexPath.row];
  UIColor *blue = [COMMUNITY_BLUE darkenBy:-0.075 * indexPath.row];
  blue = [blue desaturateBy:0.22 * indexPath.row];
  cell.backgroundColor = blue;
  cell.imageView.image = [UIImage imageNamed:forum[kForumIcon]];
  cell.textLabel.text = forum[kForumName];
  cell.textLabel.textColor = LIGHT;

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 85.0f;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  _selectedForum = kCommunityForums[indexPath.row];
  return indexPath;
 }

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  CommunityForumViewController *forumViewController = [segue destinationViewController];
  forumViewController.navigationItem.title = _selectedForum[kForumName];
  forumViewController.URL = _selectedForum[kForumURL];
  self.navigationController.navigationBar.barTintColor = [sender backgroundColor];
  self.navigationController.navigationBar.tintColor = LIGHT;
  self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: LIGHT};
}

@end
