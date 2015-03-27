//
//  TKListViewCellAnimationBehavior.h
//  TelerikUI
//
//  Copyright (c) 2013 Telerik. All rights reserved.
//

/**
A cell behavior providing cell animations while scrolling and reordering cells in a TKListView
*/
@interface TKListViewCellAnimationBehavior : NSObject

/**
 Adds a child behavior to an existing animation behavior in order to combine behaviors.
 @param childBehavior The child behavior.
 */
- (void)addChildBehavior:(TKListViewCellAnimationBehavior*) childBehavior;

@end
