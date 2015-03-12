//
//  TrackingIntercourseTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/7/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackingTemperatureTableViewCell.h" // where our delegate is

typedef enum {
    IntercourseSelectionNone,
    IntercourseSelectionUnprotected,
    IntercourseSelectionProtected
} IntercourseSelectionType;

@protocol TrackingIntercourseCellDelegate <NSObject>

- (void)didSelectIntercourseWithType:(IntercourseSelectionType)type;
- (void)pushInfoAlertWithTitle:(NSString *)title AndMessage:(NSString *)message AndURL:(NSString *)url;

- (Day *)getSelectedDay;
- (NSDate *)getSelectedDate;

@end

@interface TrackingIntercourseTableViewCell : UITableViewCell

@property(nonatomic,retain) id<TrackingIntercourseCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *intercourseCollapsedLabel;
@property (weak, nonatomic) IBOutlet UILabel *intercourseTypeCollapsedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *intercourseTypeCollapsedImageView;

@property (weak, nonatomic) IBOutlet UIButton *unprotectedImageView;
@property (weak, nonatomic) IBOutlet UILabel *unprotectedLabel;

@property (weak, nonatomic) IBOutlet UIButton *protectedImageView;
@property (weak, nonatomic) IBOutlet UILabel *protectedLabel;

- (void)updateCell;
- (void)setMinimized;
- (void)setExpanded;

@end
