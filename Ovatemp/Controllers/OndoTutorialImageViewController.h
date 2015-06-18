//
//  OndoTutorialImageViewController.h
//  Ovatemp
//
//  Created by Daniel Lozano on 6/18/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OndoTutorialImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *ondoImageView;

@property (nonatomic) NSUInteger index;

- (IBAction)didSelectNext:(id)sender;

@end
