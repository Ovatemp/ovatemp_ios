//
//  TrackingMedicinesTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/17/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackingTemperatureTableViewCell.h" // where our delegate is

@interface TrackingMedicinesTableViewCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,retain)id<PresentInfoAlertDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *addMedicinesButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UILabel *medicinesTypeCollapsedLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *medicinesCollapsedLabel;
@property (weak, nonatomic) IBOutlet UITableView *medicinesTableView;

@property NSDate *selectedDate;

@property NSMutableArray *medicinesTableViewDataSource;
@property NSMutableArray *allMedicineIDs;
@property NSMutableArray *selectedMedicineIDs;
@property NSNumber *addedMedicineID;
@property NSString *addedMedicineString;

- (void)reloadMedicines;

@end
