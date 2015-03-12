//
//  TrackingSupplementsTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/16/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"

@protocol TrackingSupplementsCellDelegate <NSObject>

- (void)pushInfoAlertWithTitle:(NSString *)title AndMessage:(NSString *)message AndURL:(NSString *)url;

- (Day *)getSelectedDay;
- (NSDate *)getSelectedDate;

@end

@interface TrackingSupplementsTableViewCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<TrackingSupplementsCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *supplementsTypeCollapsedLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *supplementsCollapsedLabel;
@property (weak, nonatomic) IBOutlet UITableView *supplementsTableView;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *addSupplementButton;

@property NSMutableArray *supplementsTableViewDataSource;
@property NSMutableArray *allSupplementIDs;
@property NSMutableArray *selectedSupplementIDs;

@property NSNumber *addedSupplementID;
@property NSString *addedSupllementString;

- (void)reloadSupplements;

- (void)updateCell;
- (void)setMinimized;
- (void)setExpanded;

@end
