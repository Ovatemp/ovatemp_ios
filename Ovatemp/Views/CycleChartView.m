//
//  CycleChartView.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/27/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "CycleChartView.h"
#import "Calendar.h"

#import "CycleViewController.h"

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

- (IBAction)goBack:(id)sender {
    // reset orientation
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)getInfo:(id)sender {
    UIAlertController *errorAlert = [UIAlertController
                                     alertControllerWithTitle:@"Hey"
                                     message:@"Stay Awesome"
                                     preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                               handler:nil];
    
    [errorAlert addAction:ok];
    
    //    [self presentViewController:errorAlert animated:YES completion:nil];
    [self.delegate pushAlertController:errorAlert];
    
}

- (void)setCycle:(Cycle *)cycle {
    _cycle = cycle;
    
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    [self calculateStyle:self.chartImageView.frame.size];
    
    [super layoutSubviews];
    
    for(UIView *view in @[self.cervicalFluidIconsView, self.periodIconsView, self.opkIconsView, self.sexIconsView]) {
        for(UIView *subview in view.subviews) {
            [subview removeFromSuperview];
        }
    }
    
    CGRect iconFrame;
    for(Day *day in self.cycle.days) {
        NSInteger dayIndex = [day.cycleDay intValue] - 1;
        iconFrame = CGRectMake(dayIndex * pointWidth + (pointWidth * (.25 / 2)), pointWidth / 2, pointWidth * 0.75, pointWidth * 0.75);
        
        [self.cervicalFluidIconsView addSubview:[self imageViewWithName:[day imageNameForProperty:@"cervicalFluid"] andFrame:iconFrame]];
        [self.periodIconsView addSubview:[self imageViewWithName:[day imageNameForProperty:@"period"] andFrame:iconFrame]];
        [self.opkIconsView addSubview:[self imageViewWithName:[day imageNameForProperty:@"opk"] andFrame:iconFrame]];
        [self.sexIconsView addSubview:[self imageViewWithName:[day imageNameForProperty:@"intercourse"] andFrame:iconFrame]];
    }
    
    self.chartImageView.image = [self drawChart:self.chartImageView.frame.size];
}

- (UIImageView *)imageViewWithName:(NSString *)name andFrame:(CGRect)frame {
    if(!name) { return nil; }
    
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
    
    int newCount = [[Calendar day].cycleDay intValue];
    
    static int maxCycleCount;
    if (!maxCycleCount) {
        maxCycleCount = newCount;
    } else if (newCount > maxCycleCount) {
        maxCycleCount = newCount;
    } else if (newCount == 1) {
        maxCycleCount = 1;
    }
    
    if (newCount < 30 && maxCycleCount < 30) {
        daysToShow = 30;
    } else {
        daysToShow = MIN(40, maxCycleCount);
    }
    pointWidth = canvasWidth / ((CGFloat)daysToShow + leftPaddingPoints + rightPaddingPoints);
    
    leftPadding = leftPaddingPoints * pointWidth;
    topPadding = pointWidth * .45;
    rightPadding = rightPaddingPoints * pointWidth;
    bottomPadding = bottomPaddingPoints * pointWidth;
    height = canvasHeight - bottomPadding - topPadding;
    
    self.iconsContainerLeadingSpace.constant = self.chartImageView.frame.origin.x + leftPadding;
}

// NOTE: This method gets used in two places.
// a) Directly on the Today chart in the temperature cell
// b) In a modal that gets launched when the device is rotated to landscape on the today screen.
//    this gets drawn into a UIImageView.
- (UIImage *)drawChart:(CGSize)size {
    NSArray *days = self.cycle.days;
    
    CGFloat minValue, maxValue;
    
    // unit switch
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"temperatureUnitPreferenceFahrenheit"]) {
        // celsius
        minValue = 35.6;
        maxValue = 37.8;
        
    } else {
        // fahrenheit
        minValue = 96;
        maxValue = 100;
    }
    
    for(Day *day in days) {
        if(![day temperature]) continue;

        CGFloat temperature;
        if ([defaults boolForKey:@"temperatureUnitPreferenceFahrenheit"]) {
            // fahrenheit
            temperature = [day.temperature floatValue];
        } else {
            // celsius
            temperature = (([day.temperature floatValue] - 32) / 1.8000f);
        }
        
        if (temperature == 0) continue;
        
        minValue = MIN(minValue, temperature);
        maxValue = MAX(maxValue, temperature);
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
        // Draw the x axis label for this point
        NSDictionary* stringAttrs = @{NSFontAttributeName: font, NSForegroundColorAttributeName: textColor};
        NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:[[NSNumber numberWithInt:i+1] description] attributes:stringAttrs];
        
        point.x = pointWidth * i + leftPadding + (pointWidth - [attrStr size].width) / 2;
        
        [attrStr drawAtPoint:CGPointMake(point.x, canvasHeight - pointWidth)];
    }
    
    BOOL lastDayHadTemperature = FALSE;
    NSMutableSet *dots = [[NSMutableSet alloc] init];
    for(int i=0; i < days.count; i++) {
        // Build the line and store the location for the day
        point.x = pointWidth * i + leftPadding + pointWidth / 2;
        
        Day *day = days[i];
        
        // Draw the cycle day line
        if(day == [Calendar day]) {
            point.x = ([[Calendar day].cycleDay integerValue] - 1) * pointWidth + leftPadding + pointWidth / 2;
            [[UIColor blackColor] set];
            UIBezierPath *cycleDay = [[UIBezierPath alloc] init];
            [cycleDay setLineWidth:.5];
            [cycleDay moveToPoint:CGPointMake(point.x + dotRadius / 2, topPadding)];
            [cycleDay addLineToPoint:CGPointMake(point.x + dotRadius / 2, canvasHeight - bottomPadding)];
            [cycleDay stroke];
        }
        
        if(day.inFertilityWindow) {
            [FERTILITY_WINDOW_COLOR set];
            
            CGRect fertilityWindow = CGRectMake(pointWidth * i + leftPadding, topPadding, pointWidth, canvasHeight - topPadding - bottomPadding);
            CGContextFillRect(context, fertilityWindow);
        }
        
        if(day.temperature == nil) {
            lastDayHadTemperature = FALSE;
            continue;
        }
        
        CGFloat ratio;
        if ([defaults boolForKey:@"temperatureUnitPreferenceFahrenheit"]) {
            // fahrenheit
            ratio = ([day.temperature floatValue] - minValue) / tempRange;
        } else {
            // celsius
            ratio = ((([day.temperature floatValue] - 32) / 1.8000f) - minValue) / tempRange;
        }
        
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
    for (DayDot *dot in dots) {
        // CGFloat col = (dot.day.fertility * 50) * 255.0;
        
        if (dot.day.disturbance) {
            [LIGHT_GREY set];
        } else if (dot.day.inFertilityWindow) {
            [DARK_GREEN set];
        } else {
            [LIGHT_GREEN set];
        }
        
        [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(dot.point.x - dotRadius / 2, dot.point.y - dotRadius, dotRadius * 2, dotRadius * 2)] fill];
    }
    
#pragma mark - Drawing analysis outcomes (cover line, fertility window, cycle day indicator)
    if(self.cycle.coverline) {
        CGFloat coverlineValue = [self.cycle.coverline floatValue];
        
        // Draw the cover line
        [[UIColor colorWithRed:(144/255.0) green:(65/255.0) blue:(160/255.0) alpha:1] set];
        [path setLineWidth:2];
        
        // TODO figure out when we should draw the red rectangle. I think it's calendar day when we have
        // a coverline
        if(false) {
            // Draw cycle day indicator
            [[UIColor redColor] set];
            CGRect dayIndicator = CGRectMake(point.x - dotRadius, point.y, dotRadius, dotRadius * 3);
            CGContextFillRect(context, dayIndicator);
        }
        
        ratio = (coverlineValue - minValue) / tempRange;
        lineY = (1 - ratio) * height + topPadding;
        CGFloat coverlineY = lineY;
        
        [path moveToPoint:CGPointMake(leftPadding, coverlineY)];
        [path addLineToPoint:CGPointMake(canvasWidth - rightPadding, coverlineY)];
        
        [path stroke];
        [path removeAllPoints];
    }
    
    UIImage *chart = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return chart;
}

@end
