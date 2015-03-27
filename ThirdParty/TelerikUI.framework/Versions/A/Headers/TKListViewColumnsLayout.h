//
//  TKListViewColumnsLayout.h
//  TelerikUI
//
//  Copyright (c) 2015 Telerik. All rights reserved.
//

#import "TKListViewLayout.h"

/**
 @enum TKListViewCellAlignment
 @discussion Defines the cell alignment when using columns layout.
 */
typedef NS_ENUM(NSInteger, TKListViewCellAlignment)
{
    /**
     Visually stretch cells.
     */
    TKListViewCellAlignmentStretch   = 0,
    /**
     Visually left align cells.
     */
    TKListViewCellAlignmentLeft      = 1,
    /**
     Visually center cells.
     */
    TKListViewCellAlignmentCenter    = 2,
    /**
     Visually right align cells.
     */
    TKListViewCellAlignmentRight     = 3,
    /**
     Visually justify cells.
     */
    TKListViewCellAlignmentJustify   = 4,
};

/**
 A layout that renders cells in TKListView by distributing them in a fixed columns count. Supports cell alignment e.g. left, right , center, justify 
 */
@interface TKListViewColumnsLayout : TKListViewLayout

/**
 The count of columns to be rendered.
 */
@property (nonatomic,assign) NSInteger columnsCount;

/**
 The desired cell alignment within a column.
 */
@property (nonatomic) TKListViewCellAlignment cellAlignment;

@end
