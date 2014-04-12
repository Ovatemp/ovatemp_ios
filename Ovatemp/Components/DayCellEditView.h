//
//  DayCellEditView.h
//  Ovatemp
//
//  Created by Flip Sasser on 4/11/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DayAttribute;

@protocol DayAttributeEditor <NSObject>

@required

- (void)attributeSelectionChanged:(DayAttribute *)attribute selected:(NSArray *)selection;
- (void)attributeToggled:(DayAttribute *)attribute choice:(NSInteger)choice;
- (void)attributeValueChanged:(DayAttribute *)attribute newValue:(id)value;

@end

@interface DayCellEditView : UIView <UITableViewDataSource, UITableViewDelegate>

@property id <DayAttributeEditor> delegate;

@property DayAttribute *attribute;
@property NSArray *buttons;
@property (readonly) UILabel *label;
@property BOOL hasLabel;

- (CGRect)buildCustomUI:(CGRect)frame;
- (void)setChoice:(NSInteger)choice;
- (void)setSelectedChoices:(NSMutableArray *)selectedChoices;
- (void)setValue:(id)value;

@end
