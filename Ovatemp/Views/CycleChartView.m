//
//  CycleChartView.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/27/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "CycleChartView.h"

@implementation DayDot
@end

@interface CycleChartView () {
  NSUInteger daysToShow;
  CGFloat pointWidth;
  CGFloat canvasWidth;
  CGFloat canvasHeight;
  CGFloat leftPadding;
  CGFloat topPadding;
  CGFloat rightPadding;
  CGFloat bottomPadding;
  CGFloat height;
}

@end

@implementation CycleChartView

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};

- (BOOL)isFlipped {
  return TRUE;
}

- (void)setCycle:(Cycle *)cycle {
  _cycle = cycle;

  [self setNeedsDisplay];
}

- (void)layoutSubviews {
  [super layoutSubviews];

  [self calculateStyle:self.chartImageView.frame.size];

  for(UIView *view in @[self.cervicalFluidIconsView, self.periodIconsView, self.opkIconsView, self.sexIconsView]) {
    for(UIView *subview in view.subviews) {
      [subview removeFromSuperview];
    }
  }

  CGRect iconFrame;
  for(int i=0; i < daysToShow; i++) {
    iconFrame = CGRectMake(i * pointWidth, pointWidth / 2, pointWidth, pointWidth);

    [self.cervicalFluidIconsView addSubview:[self imageViewWithName:@"Creamy" andFrame:iconFrame]];

    [self.periodIconsView addSubview:[self imageViewWithName:@"Medium" andFrame:iconFrame]];

    [self.opkIconsView addSubview:[self imageViewWithName:@"Positive" andFrame:iconFrame]];

    [self.sexIconsView addSubview:[self imageViewWithName:@"Unprotected" andFrame:iconFrame]];
  }

  self.chartImageView.image = [self drawChart:self.chartImageView.frame.size];
}

- (UIImageView *)imageViewWithName:(NSString *)name andFrame:(CGRect)frame {
  UIImageView *imageView;
  imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  imageView.frame = frame;

  return imageView;
}

- (void)calculateStyle:(CGSize)size {
  canvasWidth = size.width;
  canvasHeight = size.height;

  CGFloat bottomPaddingPoints = 1;
  CGFloat leftPaddingPoints = 2.5;
  CGFloat rightPaddingPoints = 1;

  daysToShow = 30;
  pointWidth = canvasWidth / ((CGFloat)daysToShow + leftPaddingPoints + rightPaddingPoints);

  if(self.iconsContainerLeadingSpace) {
    leftPadding = self.iconsContainerLeadingSpace.constant;
  } else {
    leftPadding = leftPaddingPoints * pointWidth;
  }
  topPadding = pointWidth * .45;
  rightPadding = rightPaddingPoints * pointWidth;
  bottomPadding = bottomPaddingPoints * pointWidth;
  height = canvasHeight - bottomPadding - topPadding;
}

- (UIImage *)drawChart:(CGSize)size {
  NSArray *days = self.cycle.days;

  CGFloat minValue = 400, maxValue = 0, val;
  for(Day *day in days) {
    if(![day temperature]) continue;

    val = [day.temperature floatValue];
    if(val < minValue) {
      minValue = val;
    }
    if(val > maxValue) {
      maxValue = val;
    }
  }
  maxValue = ceil(maxValue);
  minValue = floor(minValue);

  UIGraphicsBeginImageContextWithOptions(size, YES, 0);   // 0 means let iOS deal with scale for you (for Retina)
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGFloat tempRange = maxValue - minValue;
  CGFloat lowValue = minValue + (tempRange * .25);
  CGFloat highValue = minValue + (tempRange * .75);

  UIFont* font = [UIFont systemFontOfSize:pointWidth * 0.8];
  UIColor* textColor = [UIColor blackColor];

  CGFloat dotRadius = 2.75;

  // Draw white background
  [[UIColor whiteColor] set];
  UIRectFill(CGRectMake(0, 0, canvasWidth, canvasHeight));

  UIBezierPath *path = [[UIBezierPath alloc] init];

#pragma mark - Axes
  // Draw the top line
  [[UIColor blackColor] set];
  [path setLineWidth:.5];

  CGFloat lineY = topPadding;

  [path moveToPoint:CGPointMake(leftPadding, lineY)];
  [path addLineToPoint:CGPointMake(canvasWidth - rightPadding, lineY)];

  [path stroke];
  [path removeAllPoints];

  // Draw top temperature key
  NSString *tempFormat = @"%.1fº";
  NSString *tempStr = [NSString stringWithFormat:tempFormat, maxValue];
  font = [UIFont systemFontOfSize:pointWidth * .9];

  NSDictionary* stringAttrs = @{NSFontAttributeName: font, NSForegroundColorAttributeName: textColor};
  NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:tempStr attributes:stringAttrs];

  [attrStr drawAtPoint:CGPointMake(0, 0)];

  // Draw the bottom line
  CGFloat col = (216/255.0);
  [[UIColor colorWithRed:col green:col blue:col alpha:1] set];
  [path setLineWidth:1];

  CGFloat ratio = (minValue - minValue) / tempRange;
  lineY = (1 - ratio) * height + topPadding;

  [path moveToPoint:CGPointMake(leftPadding, lineY)];
  [path addLineToPoint:CGPointMake(canvasWidth - rightPadding, lineY)];

  [path stroke];
  [path removeAllPoints];

  // Draw bottom temperature key
  tempStr = [NSString stringWithFormat:tempFormat, minValue];
  attrStr = [[NSAttributedString alloc] initWithString:tempStr attributes:stringAttrs];

  [attrStr drawAtPoint:CGPointMake(0, lineY - pointWidth / 2)];

  // Draw the low line
  col = (150/255.0);
  UIColor *weakColor = [UIColor colorWithRed:col green:col blue:col alpha:1];
  [weakColor set];
  [path setLineWidth:.5];

  ratio = (lowValue - minValue) / tempRange;
  lineY = (1 - ratio) * height + topPadding;

  [path moveToPoint:CGPointMake(leftPadding, lineY)];
  [path addLineToPoint:CGPointMake(canvasWidth - rightPadding, lineY)];

  [path stroke];
  [path removeAllPoints];

  // Draw low temperature key
  font = [UIFont systemFontOfSize:pointWidth * .6];
  stringAttrs =  @{NSFontAttributeName: font, NSForegroundColorAttributeName: weakColor};
  tempStr = [NSString stringWithFormat:tempFormat, lowValue];
  attrStr = [[NSAttributedString alloc] initWithString:tempStr attributes:stringAttrs];

  [attrStr drawAtPoint:CGPointMake(pointWidth / 3, lineY - pointWidth / 2)];

  // Draw the high line
  ratio = (highValue - minValue) / tempRange;
  lineY = (1 - ratio) * height + topPadding;

  [path moveToPoint:CGPointMake(leftPadding, lineY)];
  [path addLineToPoint:CGPointMake(canvasWidth - rightPadding, lineY)];

  [path stroke];
  [path removeAllPoints];

  // Draw low temperature key
  tempStr = [NSString stringWithFormat:tempFormat, highValue];
  attrStr = [[NSAttributedString alloc] initWithString:tempStr attributes:stringAttrs];

  [attrStr drawAtPoint:CGPointMake(pointWidth / 3, lineY - pointWidth / 2)];

#pragma mark - Drawing data points and x-axis label
  font = [UIFont systemFontOfSize:pointWidth * .7];
  CGPoint point;
  for(int i=0; i < daysToShow; i++) {
    point.x = pointWidth * i + leftPadding;

    // Draw the x axis label for this point
    NSDictionary* stringAttrs = @{NSFontAttributeName: font, NSForegroundColorAttributeName: textColor};
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:[[NSNumber numberWithInt:i+1] description] attributes:stringAttrs];

    [attrStr drawAtPoint:CGPointMake(point.x - 2, canvasHeight - pointWidth)];
  }

  BOOL lastDayHadTemperature = FALSE;
  NSMutableSet *dots = [[NSMutableSet alloc] init];
  for(int i=0; i < days.count; i++) {
    // Build the line and store the location for the day
    point.x = pointWidth * i + leftPadding;

    Day *day = days[i];
    if(day.temperature == nil) {
      lastDayHadTemperature = FALSE;
      continue;
    }

    CGFloat ratio = ([day.temperature floatValue] - minValue) / tempRange;
    point.y = (1 - ratio) * height + topPadding;

    DayDot *dot = [[DayDot alloc] init];
    dot.point = point;
    dot.day = day;
    [dots addObject:dot];

    if(lastDayHadTemperature) {
      [path addLineToPoint:point];
    } else {
      [path moveToPoint:point];
    }
    lastDayHadTemperature = TRUE;
  }

  // Draw the line for the data points
  [[UIColor colorWithRed:(151/255.0) green:(151/255.0) blue:(151/255.0) alpha:1] set];
  [path stroke];
  [path removeAllPoints];

  // Draw dots at the data points
  for(DayDot *dot in dots) {
    // CGFloat col = (dot.day.fertility * 50) * 255.0;

    if(dot.day.disturbance || TRUE) {
      [[UIColor redColor] set];
    } else {
      [[UIColor colorWithRed:col green:.5 blue:.5 alpha:1] set];
    }

    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(dot.point.x - dotRadius, dot.point.y - dotRadius, dotRadius * 2, dotRadius * 2)] fill];
  }

#pragma mark - Drawing analysis outcomes (cover line, fertility window, cycle day indicator)
  // Draw the cover line
  [[UIColor colorWithRed:(144/255.0) green:(65/255.0) blue:(160/255.0) alpha:1] set];
  [path setLineWidth:2];

  if(self.cycle.coverline) {
    CGFloat coverlineValue = [self.cycle.coverline floatValue];

    ratio = (coverlineValue - minValue) / tempRange;
    lineY = (1 - ratio) * height + topPadding;
    CGFloat coverlineY = lineY;

    [path moveToPoint:CGPointMake(leftPadding, coverlineY)];
    [path addLineToPoint:CGPointMake(canvasWidth - rightPadding, coverlineY)];

    [path stroke];
    [path removeAllPoints];
  }

  if(self.landscape) {
    [[UIColor colorWithRed:(56/255.0) green:(192/255.0) blue:(191/255.0) alpha:0.16] set];

    if(self.cycle.fertilityWindow) {
      CGPoint begin;
      CGPoint end;
      CGRect fertilityWindow = CGRectMake(begin.x - dotRadius, topPadding, end.x - point.x + dotRadius, canvasHeight - topPadding - bottomPadding);
      CGContextFillRect(context, fertilityWindow);
    }

    // Draw cycle day indicator
    [[UIColor redColor] set];

    CGPoint todayPoint = point;

    CGRect dayIndicator = CGRectMake(todayPoint.x - dotRadius / 2, todayPoint.y, dotRadius, dotRadius * 3);
    CGContextFillRect(context, dayIndicator);

    [path setLineWidth:.5];
    [path moveToPoint:CGPointMake(point.x, topPadding)];
    [path addLineToPoint:CGPointMake(point.x, canvasHeight - bottomPadding)];
    [path stroke];

    // Draw cycle day indicator line
    [path setLineWidth:.5];
    [path moveToPoint:CGPointMake(point.x, topPadding)];
    [path addLineToPoint:CGPointMake(point.x, canvasHeight - bottomPadding)];
    [path stroke];
  }

  UIImage *chart = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return chart;
}

@end