//
//  ILCalendarViewController.h
//  Ovatemp
//
//  Created by Daniel Lozano on 3/23/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TelerikUI/TelerikUI.h>

@protocol ILCalendarViewControllerDelegate <NSObject>

- (void)didSelectDateInCalendar:(NSDate *)date;

@end

@interface ILCalendarViewController : UIViewController

@property (weak, nonatomic) id<ILCalendarViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *infoView;

- (IBAction)didSelectBack:(id)sender;
- (IBAction)didSelectForward:(id)sender;

@end
