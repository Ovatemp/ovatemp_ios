//
//  TutorialViewController.h
//  Ovatemp
//
//  Created by Daniel Lozano on 4/22/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController

@property (nonatomic) NSArray *images;

@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)didSelectSkipTutorial:(id)sender;

@end
