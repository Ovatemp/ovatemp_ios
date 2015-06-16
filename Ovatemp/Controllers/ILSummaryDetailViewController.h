//
//  ILSummaryDetailViewController.h
//  Ovatemp
//
//  Created by Daniel Lozano on 6/3/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ILCheckmarkView;

@interface ILSummaryDetailViewController : UIViewController

@property (nonatomic) NSString *urlString;

@property (nonatomic) NSString *activityName;
@property (nonatomic) NSString *timeOfDay;
@property (nonatomic) NSString *activityImageName;

@property (weak, nonatomic) IBOutlet UIView *topBar;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileLabel;

@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activitySubtitleLabel;

@property (weak, nonatomic) IBOutlet ILCheckmarkView *doneCheckmark;

@property (weak, nonatomic) IBOutlet ILCheckmarkView *sunCheckmark;
@property (weak, nonatomic) IBOutlet ILCheckmarkView *monCheckmark;
@property (weak, nonatomic) IBOutlet ILCheckmarkView *tuesCheckmark;
@property (weak, nonatomic) IBOutlet ILCheckmarkView *wedCheckmark;
@property (weak, nonatomic) IBOutlet ILCheckmarkView *thurCheckmark;
@property (weak, nonatomic) IBOutlet ILCheckmarkView *fridayCheckmark;
@property (weak, nonatomic) IBOutlet ILCheckmarkView *satCheckmark;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
