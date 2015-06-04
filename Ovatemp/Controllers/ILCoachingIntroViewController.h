//
//  ILCoachingIntroViewController.h
//  Ovatemp
//
//  Created by Daniel Lozano on 6/3/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ILButton.h"

@interface ILCoachingIntroViewController : UIViewController

@property (nonatomic) BOOL onSecondScreen;

@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *subHeadingLabel;
@property (weak, nonatomic) IBOutlet ILButton *nextButton;


- (IBAction)didSelectNext:(id)sender;

@end
