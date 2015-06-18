//
//  OndoTutorialViewController.h
//  Ovatemp
//
//  Created by Daniel Lozano on 6/17/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OndoTutorialViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)didSelectNext:(id)sender;

@end
