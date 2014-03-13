//
//  CalendarViewController.h
//  Ovatemp
//
//  Created by Chris Cahoon on 3/4/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

- (id)initWithDefaultLayoutAndFrameHint:(CGRect)frame;

@end
