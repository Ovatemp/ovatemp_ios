//
//  TrackingSymptomsTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/7/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"

@protocol TrackingSymptomsCellDelegate <NSObject>

- (void)didSelectSymptomsWithTypes:(NSMutableArray *)types;
- (void)pushInfoAlertWithTitle:(NSString *)title AndMessage:(NSString *)message AndURL:(NSString *)url;

- (Day *)getSelectedDay;
- (NSDate *)getSelectedDate;

@end

@interface TrackingSymptomsTableViewCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<TrackingSymptomsCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *symptomsCollapsedLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeCollapsedLabel;
@property (weak, nonatomic) IBOutlet UITableView *symptomsTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@property NSMutableArray *selectedSymptoms;

@property BOOL breastTendernessSelected;
@property BOOL headachesSelected;
@property BOOL nauseaSeleted;
@property BOOL irritabilityMoodSwingsSelected;
@property BOOL bloatingSelected;
@property BOOL pmsSelected;
@property BOOL stressSelected;
@property BOOL travelSelected;
@property BOOL feverSelected;
@property BOOL crampsSelected;

- (void)updateCell;
- (void)setMinimized;
- (void)setExpanded;

@end
