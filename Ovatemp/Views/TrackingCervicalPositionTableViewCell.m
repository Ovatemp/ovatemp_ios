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
    [self setUpActivityView];
}

- (void)setUpActivityView
{
    self.activityView.hidden = YES;
    self.activityView.hidesWhenStopped = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(startActivity)
                                                 name: @"cp_start_activity"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(stopActivity)
                                                 name: @"cp_stop_activity"
                                               object: nil];
}

- (void)startActivity
{
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
}

- (void)stopActivity
{
    [self.activityView stopAnimating];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)didSelectLowButton:(id)sender
{
    if (self.selectedCervicalPositionType == CervicalPositionSelectionLow) {
        self.selectedCervicalPositionType = CervicalPositionSelectionNone;
        
        [self deselectAllButtons];
        self.cpTypeCollapsedLabel.text = @"";
        
        if ([self.delegate respondsToSelector: @selector(didSelectCervicalPositionType:)]) {
            [self.delegate didSelectCervicalPositionType: [NSNull null]];
        }
        
    } else {
        self.selectedCervicalPositionType = CervicalPositionSelectionLow;

        self.cpTypeCollapsedLabel.text = @"Low/Closed/Firm";
        self.cpTypeImageView.image = [UIImage imageNamed:@"icn_cp_lowclosedfirm"];
        
        [self deselectAllButtons];
        [self.lowImageView setSelected:YES];
        
        if ([self.delegate respondsToSelector: @selector(didSelectCervicalPositionType:)]) {
            [self.delegate didSelectCervicalPositionType: @"low/closed/firm"];
        }
    }
}
- (IBAction)didSelectHighButton:(id)sender
{
    if (self.selectedCervicalPositionType == CervicalPositionSelectionHigh) {
        self.selectedCervicalPositionType = CervicalPositionSelectionNone;
        
        [self deselectAllButtons];
        self.cpTypeCollapsedLabel.text = @"";
        
        if ([self.delegate respondsToSelector: @selector(didSelectCervicalPositionType:)]) {
            [self.delegate didSelectCervicalPositionType: [NSNull null]];
        }
        
    } else {
        self.selectedCervicalPositionType = CervicalPositionSelectionHigh;

        self.cpTypeCollapsedLabel.text = @"High/Open/Soft";
        self.cpTypeImageView.image = [UIImage imageNamed:@"icn_cp_highopensoft"];
        
        [self deselectAllButtons];
        [self.highImageView setSelected:YES];
        
        if ([self.delegate respondsToSelector: @selector(didSelectCervicalPositionType:)]) {
            [self.delegate didSelectCervicalPositionType: @"high/open/soft"];
        }
        
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



#pragma mark - Appearance

- (void)updateCell
{
    ILDay *selectedDay = [self.delegate getSelectedDay];
    
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
    ILDay *selectedDay = [self.delegate getSelectedDay];
    
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
