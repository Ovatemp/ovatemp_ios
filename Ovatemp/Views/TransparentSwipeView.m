//
//  TransparentSwipeView.m
//  Ovatemp
//
//  Created by Daniel Lozano on 4/8/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "TransparentSwipeView.h"

@implementation TransparentSwipeView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSEnumerator *reverseE = [self.subviews reverseObjectEnumerator];
    UIView *iSubView;
    
    while ((iSubView = [reverseE nextObject])) {
        
        UIView *viewWasHit = [iSubView hitTest:[self convertPoint:point toView:iSubView] withEvent:event];
        if(viewWasHit) {
            return viewWasHit;
        }
        
    }
    return [super hitTest:point withEvent:event];
}

@end
