//
//  CycleViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/10/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "CycleViewController.h"
#import "CycleChartView.h"

@interface CycleViewController ()

@end

@implementation CycleViewController

- (id)init {
  self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:nil];
  if (self) {
    self.delegate = self;
    self.dataSource = self;
  }
  return self;
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

- (void)setCycle:(Cycle *)cycle {
  UIViewController *vc = [self viewControllerWithCycle:cycle];

  [self setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (UIViewController *)viewControllerWithCycle:(Cycle *)cycle {
  CycleChartView *chart = [[[NSBundle mainBundle] loadNibNamed:@"CycleChartView" owner:self options:nil] lastObject];

  chart.cycle = cycle;
  chart.landscape = TRUE;

  chart.dateRangeLabel.text = cycle.rangeString;

  UIViewController *vc = [[UIViewController alloc] init];
  vc.view = chart;

  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  if(orientation == UIInterfaceOrientationLandscapeRight) {
    vc.view.transform = CGAffineTransformMakeRotation(M_PI/2);
  } else {
    vc.view.transform = CGAffineTransformMakeRotation(3 * M_PI/2);
  }

  return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
  CycleChartView *otherChart = (CycleChartView *)viewController.view;
  Cycle *cycle = [otherChart.cycle nextCycle];
  if (cycle) {
    return [self viewControllerWithCycle:cycle];
  }
  return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
  CycleChartView *otherChart = (CycleChartView *)viewController.view;
  Cycle *cycle = [otherChart.cycle previousCycle];
  if (cycle) {
    return [self viewControllerWithCycle:cycle];
  }
  return nil;
}

- (BOOL)shouldAutorotate {
  return FALSE;
}

@end
