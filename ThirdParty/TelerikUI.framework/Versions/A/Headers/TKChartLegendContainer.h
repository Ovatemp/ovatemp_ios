//
//  TKChartLegendContainer.h
//
//  Copyright (c) 2013 Telerik. All rights reserved.
//

#import "TKStackLayoutView.h"
#import "TKChartLegendItem.h"

@class TKChartPaletteItem;

/**
 @discussion The container which contains legend items.
 */
@interface TKChartLegendContainer : TKStackLayoutView

/**
 Set preferred size fot the container.
 */
@property (nonatomic) CGSize preferredSize;

/**
 Adds a legend item.
 @param item The item to add to the legend container.
 */
- (void)addItem:(TKChartLegendItem *)item;

/**
 Removes all items contained in this container.
 */
- (void)removeAllItems;

/**
 Returns the item at a specified index.
 @param index The index of the item that the method should return.
 @return An instance of TKLegendItem which represents the legend item.
 */
- (TKChartLegendItem *)itemAtIndex:(NSUInteger)index;

- (NSUInteger)itemCount;

@end
