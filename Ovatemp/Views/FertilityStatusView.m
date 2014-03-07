//
//  FertilityStatusView.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/7/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "FertilityStatusView.h"

@implementation FertilityStatusView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      self.label = [[UILabel alloc] initWithFrame:frame];
      self.label.font = [UIFont systemFontOfSize:16];
      self.label.textColor = [UIColor whiteColor];
      self.label.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

@end
