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
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(2.5, 2.5, 20, 20)];
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
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(2.5, 2.5, 20, 20)];
    [color2 setFill];
    [ovalPath fill];
    [color2 setStroke];
    ovalPath.lineWidth = 1;
    [ovalPath stroke];
    
    
    //// Rectangle Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 9.06, 15.17);
    CGContextRotateCTM(context, -36.23 * M_PI / 180);
    
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(-1.5, -4.83, 3, 9.65)];
    [color3 setFill];
    [rectanglePath fill];
    
    CGContextRestoreGState(context);
    
    
    //// Rectangle 2 Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 18.06, 12.02);
    CGContextRotateCTM(context, 51.37 * M_PI / 180);
    
    UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(-1.5, -9.18, 3, 18.37)];
    [color3 setFill];
    [rectangle2Path fill];
    
    CGContextRestoreGState(context);


}

#pragma mark - Set/Get

- (void)setIsChecked:(BOOL)isChecked
{
    _isChecked = isChecked;
    
    [self setNeedsDisplay];
}

@end
