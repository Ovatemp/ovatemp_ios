//
//  CoachingMenuViewController.h
//  Ovatemp
//
//  Created by Chris Cahoon on 3/24/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoachingMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
