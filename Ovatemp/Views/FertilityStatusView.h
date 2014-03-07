//
//  FertilityStatusView.h
//  Ovatemp
//
//  Created by Chris Cahoon on 3/7/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"

@interface FertilityStatusView : UIView

@property (nonatomic, strong) UILabel *label;
- (void)updateWithDay:(Day *)day;

@end
