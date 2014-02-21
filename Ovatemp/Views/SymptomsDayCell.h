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

@end
