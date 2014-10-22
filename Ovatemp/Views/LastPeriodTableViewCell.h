//
//  LastPeriodTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 10/21/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LastPeriodTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *lastPeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
