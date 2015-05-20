//
//  EditWeightTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 10/24/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditWeightTableViewCell : UITableViewCell <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *weightField;

@property UIPickerView *weightPicker;

- (IBAction)didSelectHealthKit:(id)sender;

@end
