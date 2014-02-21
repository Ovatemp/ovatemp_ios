//
//  SupplementsDayCell.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayCell.h"
#import "CheckCell.h"

@interface SupplementsDayCell : DayCell <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextView *supplementsTextView;
@property (weak, nonatomic) IBOutlet UITableView *supplementsTableView;

@property (weak, nonatomic) IBOutlet UITextView *medicinesTextView;
@property (weak, nonatomic) IBOutlet UITableView *medicinesTableView;


@end
