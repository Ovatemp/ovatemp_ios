//
//  CoachingRootViewController.h
//  Ovatemp
//
//  Created by Chris Cahoon on 3/25/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoachingRootViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic) BOOL showFirstScreen;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@end
