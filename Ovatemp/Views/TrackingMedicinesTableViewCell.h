//
//  TrackingMedicinesTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/17/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ILDay.h"

@protocol TrackingMedicinesCellDelegate <NSObject>

- (void)reloadTrackingView;
- (void)presentViewControllerWithViewController:(UIViewController *)viewController;
- (void)pushInfoAlertWithTitle:(NSString *)title AndMessage:(NSString *)message AndURL:(NSString *)url;

- (ILDay *)getSelectedDay;
- (void)updateSelectedDay:(ILDay *)day;

@end

@interface TrackingMedicinesTableViewCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<TrackingMedicinesCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *addMedicinesButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UILabel *medicinesTypeCollapsedLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *medicinesCollapsedLabel;
@property (weak, nonatomic) IBOutlet UITableView *medicinesTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@property NSMutableArray *medicinesTableViewDataSource;
@property NSMutableArray *allMedicineIDs;
@property NSMutableArray *selectedMedicineIDs;
@property NSNumber *addedMedicineID;
@property NSString *addedMedicineString;

- (void)reloadMedicines;

- (void)updateCell;
- (void)setMinimized;
- (void)setExpanded;

@end
