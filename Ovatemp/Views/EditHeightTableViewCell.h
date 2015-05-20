//
//  EditHeightTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 10/24/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditHeightTableViewCellDelegate <NSObject>

- (void)didSelectHealthKitForHeight;

@end

@interface EditHeightTableViewCell : UITableViewCell <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *heightField;

@property (weak, nonatomic) id <EditHeightTableViewCellDelegate> delegate;
@property UIPickerView *heightPicker;

- (IBAction)didSelectHealthKit:(id)sender;

@end
