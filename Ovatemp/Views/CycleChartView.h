//
//  CycleChartView.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/27/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cycle.h"

@interface DayDot : NSObject

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, weak) Day *day;

@end

@interface CycleChartView : UIView

@property NSArray *days;
@property (nonatomic, strong) Cycle *cycle;
@property (nonatomic, assign) BOOL landscape;

@property (weak, nonatomic) IBOutlet UIImageView *chartImageView;

@property (weak, nonatomic) IBOutlet UILabel *dateRangeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconsContainerLeadingSpace;
@property (weak, nonatomic) IBOutlet UIView *iconsContainerView;
@property (weak, nonatomic) IBOutlet UIView *periodIconsView;
@property (weak, nonatomic) IBOutlet UIView *opkIconsView;
@property (weak, nonatomic) IBOutlet UIView *sexIconsView;
@property (weak, nonatomic) IBOutlet UIView *cervicalFluidIconsView;

- (UIImage *)drawChart:(CGSize)size;
- (void)calculateStyle:(CGSize)size;

@end
