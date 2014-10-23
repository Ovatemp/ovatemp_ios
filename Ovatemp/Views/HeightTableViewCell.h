//
//  HeightTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 10/23/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeightTableViewCell : UITableViewCell <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightValueLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *heightPicker;

@end
