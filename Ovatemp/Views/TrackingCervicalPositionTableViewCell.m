//
//  TrackingCervicalPositionTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/5/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingCervicalPositionTableViewCell.h"

#import "TrackingViewController.h"
#import "Calendar.h"
#import "Alert.h"

@interface TrackingCervicalPositionTableViewCell ()

@property CervicalPositionSelectionType selectedCervicalPositionType;

@end

@implementation TrackingCervicalPositionTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
//    self.selectedDate = [[NSDate alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)didSelectLowButton:(id)sender
{
    if (self.selectedCervicalPositionType == CervicalPositionSelectionLow) {
        self.selectedCervicalPositionType = CervicalPositionSelectionNone;
        [self hitBackendWithCervicalPositionType:[NSNull null]];
        [self deselectAllButtons];
        self.cpTypeCollapsedLabel.text = @"";
    } else {
        self.selectedCervicalPositionType = CervicalPositionSelectionLow;
        [self hitBackendWithCervicalPositionType:@"low/closed/firm"];
        self.cpTypeCollapsedLabel.text = @"Low/Closed/Firm";
        self.cpTypeImageView.image = [UIImage imageNamed:@"icn_cp_lowclosedfirm"];
        
        [self deselectAllButtons];
        [self.lowImageView setSelected:YES];
    }
}
- (IBAction)didSelectHighButton:(id)sender
{
    if (self.selectedCervicalPositionType == CervicalPositionSelectionHigh) {
        self.selectedCervicalPositionType = CervicalPositionSelectionNone;
        [self hitBackendWithCervicalPositionType:[NSNull null]];
        [self deselectAllButtons];
        self.cpTypeCollapsedLabel.text = @"";
    } else {
        self.selectedCervicalPositionType = CervicalPositionSelectionHigh;
        [self hitBackendWithCervicalPositionType:@"high/open/soft"];
        self.cpTypeCollapsedLabel.text = @"High/Open/Soft";
        self.cpTypeImageView.image = [UIImage imageNamed:@"icn_cp_highopensoft"];
        
        [self deselectAllButtons];
        [self.highImageView setSelected:YES];
    }
}

- (void)deselectAllButtons
{
    [self.highImageView setSelected:NO];
    [self.lowImageView setSelected:NO];
}

- (IBAction)didSelectInfoButton:(id)sender
{
    [self.delegate pushInfoAlertWithTitle:@"Cervical Position" AndMessage:@"The position of your cervix changes throughout your cycle. When you are not fertile your cervix is low, closed and firm. When fertile your cervix moves up and opens up so that the fittest swimmers reach the egg.\n\nTo learn how to track your cervical position, tap Learn More." AndURL:@"http://ovatemp.helpshift.com/a/ovatemp/?s=fertility-faqs&f=learn-more-about-cervical-position"];
}

- (void)hitBackendWithCervicalPositionType:(id)cpType
{
    NSDate *selectedDate = [self.delegate getSelectedDate];
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setObject: cpType forKey: @"cervical_position"];
    [attributes setObject: selectedDate forKey: @"date"];
    
    [ConnectionManager put:@"/days/"
                    params:@{
                             @"day": attributes,
                             }
                   success:^(NSDictionary *response) {
                       [Cycle cycleFromResponse:response];
                       [Calendar setDate: selectedDate];
//                       if (onSuccess) onSuccess(response);
                   }
                   failure:^(NSError *error) {
                       [Alert presentError:error];
                   }];
}

#pragma mark - Appearance

- (void)updateCell
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    if (selectedDay.cervicalPosition.length > 0) {
        self.cpTypeCollapsedLabel.text = selectedDay.cervicalPosition;
    }
    
    if ([selectedDay.cervicalPosition isEqual:@"low/closed/firm"]) {
        
        self.selectedCervicalPositionType = CervicalPositionSelectionLow;
        
        self.placeholderLabel.hidden = YES;
        self.collapsedLabel.hidden = NO;
        self.cpTypeCollapsedLabel.text = @"Low/Closed/Firm";
        self.cpTypeCollapsedLabel.hidden = NO;
        self.cpTypeImageView.image = [UIImage imageNamed:@"icn_cp_lowclosedfirm"];
        [self.lowImageView setSelected:YES];
        [self.highImageView setSelected:NO];
        
    } else if ([selectedDay.cervicalPosition isEqual:@"high/open/soft"]) {
        
        self.selectedCervicalPositionType = CervicalPositionSelectionHigh;
        
        self.placeholderLabel.hidden = YES;
        self.collapsedLabel.hidden = NO;
        self.cpTypeCollapsedLabel.text = @"High/Open/Soft";
        self.cpTypeCollapsedLabel.hidden = YES;
        self.cpTypeImageView.image = [UIImage imageNamed:@"icn_cp_highopensoft"];
        [self.highImageView setSelected:YES];
        [self.lowImageView setSelected:NO];
        
    } else {

        self.selectedCervicalPositionType = CervicalPositionSelectionNone;
        
        self.placeholderLabel.hidden = NO;
        self.collapsedLabel.hidden = YES;
        self.cpTypeCollapsedLabel.text = @"";
        self.cpTypeCollapsedLabel.hidden = NO;
        self.cpTypeImageView.hidden = YES;
        [self.highImageView setSelected:NO];
        [self.lowImageView setSelected:NO];
        
    }
    
}

- (void)setMinimized
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    self.highImageView.hidden = YES;
    self.highLabel.hidden = YES;
    
    self.lowImageView.hidden = YES;
    self.lowLabel.hidden = YES;
    
    if (selectedDay.cervicalPosition.length > 0) {
        // Minimized Cell, With Data
        self.placeholderLabel.hidden = YES;
        self.collapsedLabel.hidden = NO;
        self.cpTypeImageView.hidden = NO;
        self.cpTypeCollapsedLabel.hidden = NO;
    } else {
        // Minimized Cell, Without Data
        self.placeholderLabel.hidden = NO;
        self.collapsedLabel.hidden = YES;
        self.cpTypeImageView.hidden = YES;
        self.cpTypeCollapsedLabel.hidden = YES;
    }
}

- (void)setExpanded
{
    self.highImageView.hidden = NO;
    self.highLabel.hidden = NO;
    
    self.lowImageView.hidden = NO;
    self.lowLabel.hidden = NO;
    
    self.placeholderLabel.hidden = YES;
    self.collapsedLabel.hidden = NO;
    self.cpTypeCollapsedLabel.hidden = YES;
    self.cpTypeImageView.hidden = YES;

}

@end
