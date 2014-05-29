//
//  FormRow.h
//  Ovatemp
//
//  Created by Flip Sasser on 9/3/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Form, FormRow;

typedef void (^FormRowValueChange) (FormRow *row, id newValue);
typedef void (^FormRowTapped) (FormRow *row);

@interface FormRow : NSObject <UITextFieldDelegate>

// Message passing
@property (nonatomic, weak) Form *form;
@property (readonly) id value;

// Building the form controls
@property UIControl *control;
@property NSString *keyPath;
@property NSString *label;
@property (readonly) UIImage *image;
@property NSString *imageName;
@property NSString *type;
@property NSValueTransformer *valueTransformer;

// Events
@property (nonatomic, strong) FormRowValueChange onChange;
@property (nonatomic, strong) FormRowTapped onSelect;

// Control configuration
@property UITableViewCellAccessoryType accessoryType;
@property (readonly) UIDatePicker *datePicker;
@property NSString *dateFormat;

@property NSInteger section;
@property NSInteger index;

+ (FormRow *)rowWithKeyPath:(NSString *)keyPath label:(NSString *)label imageName:(NSString *)image type:(NSString *)type;

- (UITableViewCell *)buildCellForObject:(id)object inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (UIControl *)buildControlForObject:(id)object;


- (void)becomeFirstResponder;
- (void)resignFirstResponder;

@end
