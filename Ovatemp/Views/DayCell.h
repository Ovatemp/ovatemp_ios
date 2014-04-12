//
//  DayCell.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Day.h"

#import "DayAttribute.h"
#import "DayCellEditView.h"
#import "DayCellStaticView.h"

@interface DayCell : UITableViewCell <DayAttributeEditor, UIScrollViewDelegate>

@property (nonatomic, weak) Day *day;

@property NSMutableArray *editViews;
@property UIView *staticContainerView;
@property NSMutableArray *staticViews;
@property CGFloat width;

+ (DayCell *)withAttribute:(DayAttribute *)attribute;
+ (DayCell *)withAttributes:(NSArray *)attributes;

- (void)addAttribute:(DayAttribute *)attribute;
- (void)build;

@end
