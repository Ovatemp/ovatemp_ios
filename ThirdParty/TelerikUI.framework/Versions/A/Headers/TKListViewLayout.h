//
//  TKListViewLayout.h
//  TelerikUI
//
//  Copyright (c) 2015 Telerik. All rights reserved.
//

@class TKListView;
@class TKListViewItemAnimator;

/**
 A base layout used to render cells in TKListView.
 */
@interface TKListViewLayout : UICollectionViewFlowLayout

/**
 The offset that serves as a treshold to trigger autoscroll when dragging/reordering an item.
 */
@property (nonatomic, readonly) CGPoint autoScrollOffset;

@end
