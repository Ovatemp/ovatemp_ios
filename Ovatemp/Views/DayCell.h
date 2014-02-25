//
//  DayCell.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"
#import "DayToggleButton.h"

@interface DayCell : UITableViewCell <UIScrollViewDelegate>

@property (nonatomic, weak) Day *day;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *page1;
@property (nonatomic, weak) IBOutlet UIView *page2;
@property (nonatomic, weak) IBOutlet UIView *page3;

@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

- (void)toggleDayProperty:(NSString *)key withIndex:(NSInteger)index;
- (BOOL)isDayProperty:(NSString *)key ofType:(NSInteger)index;
- (void)refreshControls;
- (void)initializeControls;

- (void)showCreateFormWithTitle:(NSString *)title andClass:(id)class;

@end