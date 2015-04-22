//
//  TutorialContentViewController.h
//  Ovatemp
//
//  Created by Daniel Lozano on 4/22/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialContentViewController : UIViewController

@property (nonatomic) NSUInteger index;
@property (nonatomic) UIImage *image;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
