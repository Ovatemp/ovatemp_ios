//
//  ILCoachingSummaryViewController.h
//  Ovatemp
//
//  Created by Daniel Lozano on 6/3/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ILCheckmarkView;

@interface ILCoachingSummaryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileLabel;

@property (weak, nonatomic) IBOutlet ILCheckmarkView *sunCheckmark;
@property (weak, nonatomic) IBOutlet ILCheckmarkView *monCheckmark;
@property (weak, nonatomic) IBOutlet ILCheckmarkView *tuesCheckmark;
@property (weak, nonatomic) IBOutlet ILCheckmarkView *wedCheckmark;
@property (weak, nonatomic) IBOutlet ILCheckmarkView *thurCheckmark;
@property (weak, nonatomic) IBOutlet ILCheckmarkView *fridayCheckmark;
@property (weak, nonatomic) IBOutlet ILCheckmarkView *satCheckmark;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
