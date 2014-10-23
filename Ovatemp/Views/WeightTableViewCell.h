//
//  WeightTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 10/23/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeightTableViewCell : UITableViewCell <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightValueLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *weightPicker;

@end
