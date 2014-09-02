//
//  SubscriptionSelectionController.h
//  Ovatemp
//
//  Created by Ed Schmalzle on 7/9/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubscriptionSelectionController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property IBOutlet UITableView *tableView;

-(IBAction)restoreButtonTapped:(id)sender;

@end
