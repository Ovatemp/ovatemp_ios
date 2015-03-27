//
//  TKChartLegendItem.h
//
//  Copyright (c) 2013 Telerik. All rights reserved.
//

#import "TKStackLayout.h"

@class TKChart;
@class TKChartShapeView;
@class TKChartSelectionInfo;
@class TKChartLegendItemStyle;

/**
 @discussion The legend item contained in TKChartLegendContainer class.
 */
@interface TKChartLegendItem : UIView

/**
 The view containing the icon of the legend item.
 @return The UIView representing the icon of the legend item.
 */
@property (nonatomic, strong) UIView *icon;

/**
 The label of the legend item.
 @return The UILabel representing the text of the legend item.
 */
@property (nonatomic, strong) UILabel *label;

/**
 The selection information object.
 @discussion When this parameter is provided and the user touches the legend item related series (and data points if specified) are selected.
 */
@property (nonatomic, strong) TKChartSelectionInfo *selectionInfo;

/**
 The legend item's style.
 */
@property (nonatomic, strong) TKChartLegendItemStyle *style;

/**
 The stack layout responsible for arranging the legend items
 */
@property (nonatomic, strong, readonly) TKStackLayout *stack;

@end

/**
 @discussion This protocol is implemented by all series and provides items for the legend.
 */
@protocol TKChartLegendItemDelegate <NSObject>

/**
 Determines the number of items for a particular chart.
 @param chart The chart for which the method call is performed.
 @return The count of legend items for the series in the specified chart.
 */
- (NSUInteger)legendItemCountForChart:(TKChart *)chart;

/**
 Provides a legend item for the series in a specified chart.
 @discussion The legend asks all series first about the count of legend items they will provide and then gets this count of items.
 @param chart The chart for which the legend item is requested.
 @param index The index of the requested legend item.
 @return legend The item at the specified index.
 */
- (TKChartLegendItem *)legendItemForChart:(TKChart *)chart atIndex:(NSUInteger)index;

@end

