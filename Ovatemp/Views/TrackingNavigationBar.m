//
//  TrackingNavigationBar.m
//  Ovatemp
//
//  Created by Josh L on 10/29/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingNavigationBar.h"

@implementation TrackingNavigationBar


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    rect.size.height = 90.0f;
//
//    [self setNeedsLayout];
//    [super drawRect:rect];
//}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize newSize = CGSizeMake(self.frame.size.width,70);
    return newSize;
}

@end
