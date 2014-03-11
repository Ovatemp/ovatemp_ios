//
//  CycleViewController.h
//  Ovatemp
//
//  Created by Chris Cahoon on 3/10/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"

@interface CycleViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

- (void)setDay:(Day *)day;

@end
