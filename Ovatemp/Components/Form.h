//
//  Form.h
//  Ovatemp
//
//  Created by Flip Sasser on 9/3/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FormRow.h"

@class Form;

typedef void (^FormValueChanged) (Form *form, FormRow *row, id newValue);

@interface Form : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<UITableViewDataSource> dataSource;
@property (nonatomic, weak) id<UITableViewDelegate> delegate;

@property (nonatomic, weak) FormRow *currentRow;
@property (nonatomic, strong) FormValueChanged onChange;
@property (nonatomic, weak) id representedObject;
@property (readonly) UIToolbar *toolbar;

+ (Form *)withTableView:(UITableView *)tableView;
+ (Form *)withViewController:(UIViewController *)viewController;

# pragma mark - Form rows
- (FormRow *)addKeyPath:(NSString *)keyPath toSection:(NSString *)section;
- (FormRow *)addKeyPath:(NSString *)keyPath withLabel:(NSString *)label toSection:(NSString *)section;
- (FormRow *)addKeyPath:(NSString *)keyPath
              withLabel:(NSString *)label
               andImage:(NSString *)image
              toSection:(NSString *)section;
//- (FormRow *)addKeyPath:(NSString *)keyPath
//                       withLabel:(NSString *)label
//                        andImage:(NSString *)image
//                         andType:(NSString *)type
//                       toSection:(NSString *)sectionName;

# pragma mark - Information rows
- (FormRow *)addLabel:(NSString *)label toSection:(NSString *)sectionName whenTapped:(FormRowTapped)onSelect;
- (FormRow *)addLabel:(NSString *)label
            withImage:(NSString *)image
            toSection:(NSString *)sectionName
           whenTapped:(FormRowTapped)onSelect;
- (FormRow *)addLabel:(NSString *)label
            withImage:(NSString *)image
     andAccessoryType:(UITableViewCellAccessoryType)accessoryType
            toSection:(NSString *)sectionName
           whenTapped:(FormRowTapped)onSelect;

@end
