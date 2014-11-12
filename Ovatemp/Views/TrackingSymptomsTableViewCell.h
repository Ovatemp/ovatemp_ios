//
//  TrackingSymptomsTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/7/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackingTemperatureTableViewCell.h" // where our delegate is

@interface TrackingSymptomsTableViewCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,retain)id<PresentInfoAlertDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *symptomsCollapsedLabel;
@property (weak, nonatomic) IBOutlet UITableView *symptomsTableView;

@property NSDate *selectedDate;

@property NSMutableArray *selectedSymptoms;

@end
