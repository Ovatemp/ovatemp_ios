//
//  ILTrackingViewController.h
//  Ovatemp
//
//  Created by Daniel Lozano on 3/10/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILTrackingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *navigationBarView;
@property (weak, nonatomic) IBOutlet UIView *calendarView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *drawerCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarTopConstraint;

- (IBAction)openGraph:(id)sender;
- (IBAction)openCalendar:(id)sender;
- (IBAction)toggleDrawer:(id)sender;

@end
