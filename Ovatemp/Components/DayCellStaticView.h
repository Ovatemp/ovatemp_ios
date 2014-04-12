//
//  DayCellStaticView.h
//  Ovatemp
//
//  Created by Flip Sasser on 4/11/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DayAttribute;

@interface DayCellStaticView : UIView

@property DayAttribute *attribute;
@property (readonly) UILabel *label;
@property BOOL solitary;

- (void)setChoice:(NSString *)choice;
- (void)setSelectedChoices:(NSArray *)selectedChoices;
- (void)setValue:(id)value;

@end
