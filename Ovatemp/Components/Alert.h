//
//  Alert.h
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum AlertType {
  AlertError,
  AlertNotification
} AlertType;

typedef enum AlertButtonType {
  AlertButtonError,
  AlertButtonDefault,
  AlertButtonOK
} AlertButtonType;

@interface Alert : UIToolbar

@property AlertType alertType;
@property NSString *title;
@property NSString *message;

+ (Alert *)errorWithTitle:(NSString *)title message:(NSString *)message;
+ (Alert *)notificationWithTitle:(NSString *)title message:(NSString *)message;
- (id)initWithAlertType:(AlertType)alertType;

- (void)addButtonWithText:(NSString *)text type:(AlertButtonType)type;
- (void)addButtonWithText:(NSString *)text type:(AlertButtonType)type target:(id)target action:(SEL)action;

- (void)hide;
- (IBAction)hide:(id)sender;
- (void)show;

@end
