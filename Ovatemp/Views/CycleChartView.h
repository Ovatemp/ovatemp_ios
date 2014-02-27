//
//  CycleChartView.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/27/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleChartView : UIView

@property NSArray *days;

- (void)generateDays;

@end
