//
//  CycleLengthTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 10/22/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleLengthTableViewCell : UITableViewCell <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cycleLengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *cycleLengthValueLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *cycleLengthPicker;

@end
