//
//  ILCheckmarkView.m
//  Ovatemp
//
//  Created by Daniel Lozano on 6/15/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILCheckmarkView.h"

@implementation ILCheckmarkView

- (void)drawRect:(CGRect)rect
{
    if (self.isChecked) {
        [self drawCheckmarkInFrame: rect];
    }else{
        [self drawEmptyCircleInFrame: rect];
    }
}

- (void)drawEmptyCircleInFrame:(CGRect)frame
{
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(1.5, 1.5, 17, 17)];
    [UIColor.lightGrayColor setFill];
    [ovalPath fill];
    [UIColor.darkGrayColor setStroke];
    ovalPath.lineWidth = 1;
    [ovalPath stroke];
}

- (void)drawCheckmarkInFrame:(CGRect)frame
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color2 = [UIColor colorWithRed: 0.514 green: 0.875 blue: 0.867 alpha: 1];
    UIColor* color3 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Group
    {
        //// Oval Drawing
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(1.5, 1.5, 17, 17)];
        [color2 setFill];
        [ovalPath fill];
        [color2 setStroke];
        ovalPath.lineWidth = 1;
        [ovalPath stroke];
        
        
        //// Rectangle Drawing
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 7.23, 12.27);
        CGContextRotateCTM(context, -36.23 * M_PI / 180);
        
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(-1.24, -4.13, 2.49, 8.25)];
        [color3 setFill];
        [rectanglePath fill];
        
        CGContextRestoreGState(context);
        
        
        //// Rectangle 2 Drawing
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 15.09, 9.59);
        CGContextRotateCTM(context, 51.37 * M_PI / 180);
        
        UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(-1.39, -7.95, 2.79, 15.91)];
        [color3 setFill];
        [rectangle2Path fill];
        
        CGContextRestoreGState(context);
    }
}

#pragma mark - Set/Get

- (void)setIsChecked:(BOOL)isChecked
{
    _isChecked = isChecked;
    
    [self setNeedsDisplay];
}

@end
