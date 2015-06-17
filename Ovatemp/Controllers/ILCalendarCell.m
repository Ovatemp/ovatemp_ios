//
//  ILCalendarCell.m
//  Ovatemp
//
//  Created by Daniel Lozano on 3/23/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILCalendarCell.h"

#import "UserProfile.h"
#import "UIColor+Traits.h"

@interface ILCalendarCell ()

@property (nonatomic) UIColor *periodColor;
@property (nonatomic) UIColor *fertilityColorConceive;
@property (nonatomic) UIColor *fertilityColorAvoid;
@property (nonatomic) UIColor *notFertileColor;

@end

@implementation ILCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.periodColor = [UIColor colorWithRed: 251.0/255.0 green: 95.0/255.0 blue: 98.0/255.0 alpha: 1];
//        self.fertilityColorConceive = [UIColor colorWithRed: 56.0/255.0 green: 192.0/255.0 blue: 191.0/255.0 alpha: 1];
//        self.fertilityColorAvoid = self.periodColor;
//        self.notFertileColor = [UIColor colorWithRed: 143.0/255.0 green: 130.0/255.0 blue: 157.0/255.0 alpha: 1];
        
    }
    return self;
}

- (void)updateVisuals
{
    [super updateVisuals];
    
    if (self.dayType == CalendarDayTypePeriod || self.dayType == CalendarDayTypeFertile || self.dayType == CalendarDayTypeNotFertile) {
        self.label.textColor = [UIColor whiteColor];
        
    }else{
        self.label.textColor = [UIColor darkGrayColor];
    }
    
}

- (void)drawRect:(CGRect)rect
{
    UIColor *strokeColor;
    UIColor *fillColor;
    
    if (self.dayType == CalendarDayTypePeriod) {
        
        strokeColor = [UIColor il_lightRedColor];
        fillColor = [UIColor il_darkRedColor];
        
        CGFloat size = rect.size.width * .6;
        CGFloat centerX = rect.size.width / 2 - (size / 2);
        CGFloat centerY = rect.size.height /2 - (size / 2);
        
        UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(centerX, centerY, size, size)];
        [fillColor setFill];
        [ovalPath fill];
        [strokeColor setStroke];
        ovalPath.lineWidth = 2;
        [ovalPath stroke];
        
    }else if(self.dayType == CalendarDayTypeFertile || self.dayType == CalendarDayTypeNotFertile){
        
        CGRect frame = rect;
        
        UserProfile *currentUserProfile = [UserProfile current];
        
        if (self.dayType == CalendarDayTypeFertile) {
            // Fertile
            if (currentUserProfile.tryingToConceive) {
                // TTC
                strokeColor = [UIColor il_greenColor];
                fillColor = [UIColor il_greenColor];
            }else{
                // TTA
                strokeColor = [UIColor il_lightRedColor];
                fillColor = [UIColor il_lightRedColor];
            }
            
        }else{
            // Not Fertile
            if (currentUserProfile.tryingToConceive) {
                // TTC
                strokeColor = [UIColor il_purple];
                fillColor = [UIColor il_purple];
            }else{
                // TTA
                
                if ([self.cyclePhase isEqualToString: @"preovulation"]) {
                    // Pre Ovulation - Yellow Icon
                    strokeColor = [UIColor il_yellowColor];
                    fillColor = [UIColor il_yellowColor];
                }else{
                    // Post Ovulation - Green Icon
                    strokeColor = [UIColor il_greenColor];
                    fillColor = [UIColor il_greenColor];
                }
            }
            
        }
        
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
        
        [fillColor setFill];
        [bezierPath fill];
        
        [strokeColor setStroke];
        bezierPath.lineWidth = 2;
        [bezierPath stroke];
        
    }else{
        
        fillColor = [UIColor colorWithRed: 248.0/255.0 green: 248.0/255.0 blue: 248.0/255.0 alpha: 1];
        
        UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect: rect];
        [fillColor setFill];
        [rectanglePath fill];
        
    }
    
    if (self.completedActivity) {
        [self drawCheckmarkInFrame: rect];
    }

    [super drawRect: rect];
}

- (void)drawCheckmarkInFrame:(CGRect)frame
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color2 = [UIColor colorWithRed: 0.514 green: 0.875 blue: 0.867 alpha: 1];
    UIColor* color3 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    
    //// Subframes
    CGRect group = CGRectMake(CGRectGetMinX(frame) + CGRectGetWidth(frame) - 10.5, CGRectGetMinY(frame) + 2.5, 9.67, 8);
    
    
    //// Group
    {
        //// Oval Drawing
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(group), CGRectGetMinY(group), 8, 8)];
        [color2 setFill];
        [ovalPath fill];
        [color2 setStroke];
        ovalPath.lineWidth = 1;
        [ovalPath stroke];
        
        
        //// Rectangle Drawing
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, CGRectGetMinX(group) + 2.68, CGRectGetMinY(group) + 5.07);
        CGContextRotateCTM(context, -36.23 * M_PI / 180);
        
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(-0.59, -1.94, 1.18, 3.88)];
        [color3 setFill];
        [rectanglePath fill];
        
        CGContextRestoreGState(context);
        
        
        //// Rectangle 2 Drawing
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, CGRectGetMinX(group) + 6.35, CGRectGetMinY(group) + 3.81);
        CGContextRotateCTM(context, 51.37 * M_PI / 180);
        
        UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(-0.64, -3.73, 1.29, 7.45)];
        [color3 setFill];
        [rectangle2Path fill];
        
        CGContextRestoreGState(context);
    }
}

@end
