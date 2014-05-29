//
//  ONDOPairViewController.h
//  Ovatemp
//
//  Created by Flip Sasser on 9/11/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ONDO.h"

@interface ONDOPairViewController : UIViewController <ONDODelegate>

@property id <ONDODelegate> delegate;

- (UINavigationController *)buildNavigationController;

@end
