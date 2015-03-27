//
//  TKListViewCellAppearBehavior.h
//  TelerikUI
//
//  Copyright (c) 2013 Telerik. All rights reserved.
//

#import "TKListViewCellAnimationBehavior.h"

/**
 * @enum TKListViewSide
 * @discussion Defines a side of TKListView.
 */
typedef NS_OPTIONS(NSInteger, TKListViewSide)
{
    /**
     Left side.
     */
    TKListViewSideLeft,
    
    /**
     Right side.
     */
    TKListViewSideRight,
    
    /**
     Top side.
     */
    TKListViewSideTop,
    
    /**
     Bottom side.
     */
    TKListViewSideBottom,
};

/**
 A cell behavior providing animation during cell appearance.
 */
@interface TKListViewCellAppearBehavior : TKListViewCellAnimationBehavior

/**
 Used to detemine the side of a TKListView where cell enters the viewport.
*/
@property (nonatomic,readonly) TKListViewSide appearsFromSide;

/**
 Defines whether the item is animated once - on the first entry or always - on each entry of the viewport.
 */
@property (nonatomic) BOOL animateOnce;

@end

