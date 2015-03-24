//
//  ILCalendarCell.m
//  Ovatemp
//
//  Created by Daniel Lozano on 3/23/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILCalendarCell.h"

@interface ILCalendarCell ()

@property (nonatomic) UIColor *periodColor;
@property (nonatomic) UIColor *fertilityColor;

@end

@implementation ILCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.periodColor = [UIColor colorWithRed: 251.0/255.0 green: 95.0/255.0 blue: 98.0/255.0 alpha: 1];
        self.fertilityColor = [UIColor colorWithRed: 56.0/255.0 green: 192.0/255.0 blue: 191.0/255.0 alpha: 1];
        
    }
    return self;
}

- (void)updateVisuals
{
    [super updateVisuals];
    
    if (self.dayType == CalendarDayTypePeriod || self.dayType == CalendarDayTypeFertile) {
        self.label.textColor = [UIColor whiteColor];
        
    }else if(self.dayType == CalendarDayTypePredictedFertile || self.dayType == CalendarDayTypePredictedPeriod){
        self.label.textColor = [UIColor darkGrayColor];
        
    }else{
        self.label.textColor = [UIColor darkGrayColor];
    }
    
}

- (void)drawRect:(CGRect)rect
{
    UIColor *strokeColor;
    UIColor *fillColor;
    
    if (self.dayType == CalendarDayTypePeriod || self.dayType == CalendarDayTypePredictedPeriod) {
        
        strokeColor = self.periodColor;
        fillColor = self.periodColor;
        
        CGFloat size = rect.size.width * .6;
        CGFloat centerX = rect.size.width / 2 - (size / 2);
        CGFloat centerY = rect.size.height /2 - (size / 2);
        
        UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(centerX, centerY, size, size)];
        [fillColor setFill];
        [ovalPath fill];
        [strokeColor setStroke];
        ovalPath.lineWidth = 2;
        [ovalPath stroke];
        
    }else if(self.dayType == CalendarDayTypeFertile || self.dayType == CalendarDayTypePredictedFertile){
        
        CGRect frame = rect;
        
        strokeColor = self.fertilityColor;
        fillColor = self.fertilityColor;
        
        //// Bezier Drawing
//        UIBezierPath *bezierPath = UIBezierPath.bezierPath;
//        [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.80000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.46760 * CGRectGetHeight(frame))];
//        [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.69083 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.64900 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.80000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.54099 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.75738 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.60643 * CGRectGetHeight(frame))];
//        [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50909 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.79412 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.66091 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67289 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.50909 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.79412 * CGRectGetHeight(frame))];
//        [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.33109 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65197 * CGRectGetHeight(frame))];
//        [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.21818 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.46760 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.26259 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.60914 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.21818 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.54251 * CGRectGetHeight(frame))];
//        [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.27100 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33408 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.21818 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.41790 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.23772 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37185 * CGRectGetHeight(frame))];
//        [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50909 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.23529 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.32364 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.27433 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.41066 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.23529 * CGRectGetHeight(frame))];
//        [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.80000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.46760 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.66976 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.23529 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.80000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33930 * CGRectGetHeight(frame))];
//        [bezierPath closePath];
        
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.80000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.46396 * CGRectGetHeight(frame))];
        [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.69083 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.63104 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.80000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.53156 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.75738 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.59183 * CGRectGetHeight(frame))];
        [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50909 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.76471 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.66091 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65305 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.50909 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.76471 * CGRectGetHeight(frame))];
        [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.33109 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.63378 * CGRectGetHeight(frame))];
        [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.21818 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.46396 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.26259 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.59433 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.21818 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.53296 * CGRectGetHeight(frame))];
        [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.27100 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34099 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.21818 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.41819 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.23772 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37578 * CGRectGetHeight(frame))];
        [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50909 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.25000 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.32364 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.28596 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.41066 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.25000 * CGRectGetHeight(frame))];
        [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.80000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.46396 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.66976 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.25000 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.80000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34579 * CGRectGetHeight(frame))];
        [bezierPath closePath];
        
        if (self.dayType == CalendarDayTypeFertile) {
            [fillColor setFill];
            [bezierPath fill];
        }
        
        [strokeColor setStroke];
        bezierPath.lineWidth = 2;
        [bezierPath stroke];
        
    }else{
        
        fillColor = [UIColor colorWithRed: 248.0/255.0 green: 248.0/255.0 blue: 248.0/255.0 alpha: 1];
        
        UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect: rect];
        [fillColor setFill];
        [rectanglePath fill];
        
    }

    [super drawRect: rect];
}

@end
