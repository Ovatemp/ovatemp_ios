//
//  Alert.h
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AlertCallback) ();

@interface Alert : NSObject <UIAlertViewDelegate>

@property UIAlertViewStyle alertViewStyle;
@property NSString *title;
@property NSString *message;
@property UIAlertView *view;

+ (Alert *)alertForError:(NSError *)error;
+ (Alert *)alertWithTitle:(NSString *)title message:(NSString *)message;
+ (Alert *)presentError:(NSError *)error;
+ (Alert *)showAlertWithTitle:(NSString *)title message:(NSString *)message;

- (void)addButtonWithTitle:(NSString *)title;
- (void)addButtonWithTitle:(NSString *)title callback:(AlertCallback)callback;
- (void)addButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

- (void)hide;
- (IBAction)hide:(id)sender;
- (void)show;

@end
