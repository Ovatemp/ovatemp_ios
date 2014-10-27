//
//  EditHeightTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 10/24/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditHeightTableViewCell : UITableViewCell <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *heightField;
@property UIPickerView *heightPicker;

@end
