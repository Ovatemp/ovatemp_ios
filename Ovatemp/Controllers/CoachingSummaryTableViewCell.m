//
//  CoachingSummaryTableViewCell.m
//  Ovatemp
//
//  Created by Daniel Lozano on 6/11/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "CoachingSummaryTableViewCell.h"

@implementation CoachingSummaryTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(ctx, 124.0/255.0, 65.0/255.0, 160.0/255.0, 1.0);
    CGContextSetLineWidth(ctx, 2);
    
    CGContextMoveToPoint(ctx, 64, 0);
    CGContextAddLineToPoint(ctx, 64, self.bounds.size.height);
    
    CGContextStrokePath(ctx);
    
    [super drawRect: rect];
}

@end
