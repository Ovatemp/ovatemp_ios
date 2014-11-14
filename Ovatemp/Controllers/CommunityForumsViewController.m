//
//  CommunityForumsViewController.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/3/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "CommunityForumsViewController.h"

#import "CommunityForumViewController.h"

#import "ConnectionManager.h"

static NSString * const kCommunityForumCellIdentifier = @"CommunityForumCell";
static NSArray const *kCommunityForums;
static NSString * const kForumName = @"name";
static NSString * const kForumIcon = @"icon";
static NSString * const kForumURL = @"url";

static CGFloat const kDarkenBy = -0.075;
static CGFloat const kDesaturateBy = 0.22;

@interface CommunityForumsViewController () {
  NSDictionary *_selectedForum;
}
@end

@implementation CommunityForumsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    
    // nav bar title color
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor ovatempDarkGreyTitleColor] forKey:NSForegroundColorAttributeName];

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

  NSInteger colorOffset = kCommunityForums.count;
  UIColor *blue = [COMMUNITY_BLUE darkenBy:kDarkenBy * colorOffset];
  blue = [blue desaturateBy:kDesaturateBy * colorOffset];
  self.view.backgroundColor = blue;
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
//  self.navigationController.navigationBar.backgroundColor = LIGHT;
  self.navigationController.navigationBar.barTintColor = LIGHT;
  self.navigationController.navigationBar.tintColor = DARK;
//  self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: DARK};
  [self trackScreenView:@"Community"];
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
  UIColor *blue = [COMMUNITY_BLUE darkenBy:kDarkenBy * indexPath.row];
  blue = [blue desaturateBy:kDesaturateBy * indexPath.row];
  cell.backgroundColor = blue;
  cell.imageView.image = [UIImage imageNamed:forum[kForumIcon]];
  cell.textLabel.text = forum[kForumName];
  cell.textLabel.textColor = LIGHT;

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 85.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  _selectedForum = kCommunityForums[indexPath.row];

  NSString *redirectURL = _selectedForum[kForumURL];
  NSString *apiParams = [[ConnectionManager sharedConnectionManager] queryStringForDictionary:@{@"return_path": redirectURL}];
  NSString *url = [API_URL stringByAppendingFormat:@"/community?%@", apiParams];
  CommunityForumViewController *forumViewController = [CommunityForumViewController withURL:url];
  forumViewController.navigationItem.title = _selectedForum[kForumName];
  [forumViewController trackScreenView];

  self.navigationController.navigationBar.barTintColor = [tableView cellForRowAtIndexPath:indexPath].backgroundColor;
  self.navigationController.navigationBar.tintColor = LIGHT;
  self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: LIGHT};
  [self.navigationController pushViewController:forumViewController animated:YES];
}

@end
