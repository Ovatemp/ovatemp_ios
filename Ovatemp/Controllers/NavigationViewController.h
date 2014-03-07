//
//  NavigationViewController.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FertilityStatusView.h"

@interface NavigationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *dayForwardButton;
@property (weak, nonatomic) IBOutlet UIButton *dayBackwardButton;

@property (weak, nonatomic) IBOutlet UIView *dayNavigationView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet FertilityStatusView *fertilityStatusView;

@property (strong, nonatomic) UIViewController *contentViewController;

- (id)initWithContentViewController:(UIViewController *)contentViewController;

@end
