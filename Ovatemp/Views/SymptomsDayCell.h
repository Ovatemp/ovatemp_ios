//
//  SymptomsDayCell.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayCell.h"

@interface SymptomsDayCell : DayCell <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextView *symptomsTextView;
@property (weak, nonatomic) IBOutlet UITableView *symptomsTableView;

@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;
@property (weak, nonatomic) IBOutlet UILabel *moodLabel;

@property (strong, nonatomic) NSArray *symptoms;

@property (weak, nonatomic) IBOutlet DayToggleButton *sadButton;
@property (weak, nonatomic) IBOutlet DayToggleButton *worriedButton;
@property (weak, nonatomic) IBOutlet DayToggleButton *goodButton;
@property (weak, nonatomic) IBOutlet DayToggleButton *amazingButton;

@end
