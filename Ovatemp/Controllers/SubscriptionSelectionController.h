//
//  SubscriptionSelectionController.h
//  Ovatemp
//
//  Created by Ed Schmalzle on 7/9/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientButton.h"


@interface SubscriptionSelectionController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet GradientButton *leftSegmentedButton;
@property (strong, nonatomic) IBOutlet GradientButton *centerSegmentedButton;
@property (strong, nonatomic) IBOutlet GradientButton *rightSegmentedButton;
@property (strong, nonatomic) IBOutlet GradientButton *centerDiscountButton;
@property (strong, nonatomic) IBOutlet GradientButton *rightDiscountButton;

- (IBAction)leftSegmentedButtonPressed:(GradientButton *)sender;
- (IBAction)centerSegmentedButtonPressed:(GradientButton *)sender;
- (IBAction)rightSegmentedButtonPressed:(GradientButton *)sender;
- (IBAction)centerDiscountButtonPressed:(GradientButton *)sender;
- (IBAction)rightDiscountButtonPressed:(GradientButton *)sender;





-(IBAction)restoreButtonTapped:(id)sender;

@end
