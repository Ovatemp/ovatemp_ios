//
//  TrackingViewController.h
//  Ovatemp
//
//  Created by Josh L on 10/29/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *drawerView;
@property (weak, nonatomic) IBOutlet UICollectionView *drawerCollectionView;

@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;

- (IBAction)openCalendar:(id)sender;
- (IBAction)openGraph:(id)sender;
- (IBAction)toggleMiniCalendar:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarTopConstraint;

@end
