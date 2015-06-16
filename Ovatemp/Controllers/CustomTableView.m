//
//  CustomTableView.m
//  Ovatemp
//
//  Created by Daniel Lozano on 6/16/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "CustomTableView.h"

@implementation CustomTableView

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(ctx, 124.0/255.0, 65.0/255.0, 160.0/255.0, 1.0);
    CGContextSetLineWidth(ctx, 2);
    
    CGContextMoveToPoint(ctx, 63, 0);
    CGContextAddLineToPoint(ctx, 63, self.bounds.size.height);
    
    CGContextStrokePath(ctx);
    
    [super drawRect: rect];
}

@end
