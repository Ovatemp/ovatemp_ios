//
//  ILCoachingBreakViewController.h
//  Ovatemp
//
//  Created by Daniel Lozano on 6/3/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILCoachingBreakViewController : UIViewController

@property (nonatomic) NSInteger currentQuestion;

@property (weak, nonatomic) IBOutlet UILabel *headingLabel;

- (IBAction)didSelectYes:(id)sender;
- (IBAction)didSelectNo:(id)sender;

@end
