//
//  TrackingSupplementsTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/16/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackingTemperatureTableViewCell.h" // where our delegate is

@interface TrackingSupplementsTableViewCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,retain)id<PresentInfoAlertDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *supplementsTypeCollapsedLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *supplementsCollapsedLabel;
@property (weak, nonatomic) IBOutlet UITableView *supplementsTableView;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *addSupplementButton;

@property NSDate *selectedDate;

@property NSMutableArray *supplementsTableViewDataSource;

@property NSMutableArray *allSupplementIDs;

@property NSMutableArray *selectedSupplementIDs;

@property NSNumber *addedSupplementID;
@property NSString *addedSupllementString;

@end
