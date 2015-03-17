//
//  TrackingPregnancyTestTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/10/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingPregnancyTestTableViewCell.h"
#import "TrackingViewController.h"

#import "Calendar.h"
#import "Alert.h"

@interface TrackingPregnancyTestTableViewCell ()

@property PregnancyTestSelectionType selectedPregnancyTestType;

@end

@implementation TrackingPregnancyTestTableViewCell

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
                                                 name: @"pregnancy_start_activity"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(stopActivity)
                                                 name: @"pregnancy_stop_activity"
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

- (void)deselectAllButtons
{
    [self.pregnancyTypeNegativeImageView setSelected:NO];
    [self.pregnancyTypePositiveImageView setSelected:NO];
}

- (IBAction)didSelectNegative:(id)sender
{
    if (self.selectedPregnancyTestType == PregnancyTestSelectionNegative) {
        self.selectedPregnancyTestType = PregnancyTestSelectionNone;

        [self deselectAllButtons];
        self.pregnancyTypeCollapsedLabel.text = @"";
        
        if ([self.delegate respondsToSelector: @selector(didSelectPregnancyWithType:)]) {
            [self.delegate didSelectPregnancyWithType: [NSNull null]];
        }
        
    } else {
        self.selectedPregnancyTestType = PregnancyTestSelectionNegative;

        self.pregnancyTypeCollapsedLabel.text = @"Negative";
        self.pregnancyTypeImageView.image = [UIImage imageNamed:@"icn_negative"];
        
        [self deselectAllButtons];
        [self.pregnancyTypeNegativeImageView setSelected:YES];
        
        if ([self.delegate respondsToSelector: @selector(didSelectPregnancyWithType:)]) {
            [self.delegate didSelectPregnancyWithType: @"negative"];
        }
        
    }
}
- (IBAction)didSelectPositive:(id)sender
{
    if (self.selectedPregnancyTestType == PregnancyTestSelectionPositive) {
        self.selectedPregnancyTestType = PregnancyTestSelectionNone;

        [self deselectAllButtons];
        self.pregnancyTypeCollapsedLabel.text = @"";
        
        if ([self.delegate respondsToSelector: @selector(didSelectPregnancyWithType:)]) {
            [self.delegate didSelectPregnancyWithType: [NSNull null]];
        }
        
    } else {
        self.selectedPregnancyTestType = PregnancyTestSelectionPositive;

        self.pregnancyTypeCollapsedLabel.text = @"Positive";
        self.pregnancyTypeImageView.image = [UIImage imageNamed:@"icn_positive"];
        
        [self deselectAllButtons];
        [self.pregnancyTypePositiveImageView setSelected:YES];
        
        if ([self.delegate respondsToSelector: @selector(didSelectPregnancyWithType:)]) {
            [self.delegate didSelectPregnancyWithType: @"positive"];
        }
        
    }
}

- (IBAction)didSelectInfoButton:(id)sender
{
    [self.delegate pushInfoAlertWithTitle:@"Pregnancy Test" AndMessage:@"A home pregnancy test detects the human chorionic gonadotropin (hCG) hormone in urine.\n\nWe recommend you take a pregnancy test after 18 high temperatures or 3 days after you missed your period." AndURL:@"http://ovatemp.helpshift.com/a/ovatemp/?s=fertility-faqs&f=learn-more-about-pregnancy-tests"];
}

#pragma mark - Appearance

- (void)updateCell
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    if ([selectedDay.ferning isEqualToString:@"positive"]) {
        
        self.selectedPregnancyTestType = PregnancyTestSelectionPositive;
        
        [self.pregnancyTypeCollapsedLabel setText:@"Positive"];
        [self.pregnancyTypeNegativeImageView setSelected:NO];
        [self.pregnancyTypePositiveImageView setSelected:YES];
        self.pregnancyTypeImageView.image = [UIImage imageNamed:@"icn_positive"];
        
        
    } else if([selectedDay.ferning isEqualToString:@"negative"]) {
        
        self.selectedPregnancyTestType = PregnancyTestSelectionNegative;
        
        [self.pregnancyTypeCollapsedLabel setText:@"Negative"];
        [self.pregnancyTypeNegativeImageView setSelected:YES];
        [self.pregnancyTypePositiveImageView setSelected:NO];
        self.pregnancyTypeImageView.image = [UIImage imageNamed:@"icn_negative"];
        
    } else { // No Selection
        
        self.selectedPregnancyTestType = PregnancyTestSelectionNone;
        
        [self.pregnancyTypeCollapsedLabel setText:@""];
        [self.pregnancyTypeNegativeImageView setSelected:NO];
        [self.pregnancyTypePositiveImageView setSelected:NO];
        self.imageView.hidden = YES;
    
    }
}

- (void)setMinimized
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    self.pregnancyTypeNegativeImageView.hidden = YES;
    self.pregnancyTypeNegtaiveLabel.hidden = YES;
    
    self.pregnancyTypePositiveImageView.hidden = YES;
    self.pregnancyTypePositiveLabel.hidden = YES;
    
    if (selectedDay.ferning.length > 0) {
        // Minimized Cell, With Data
        self.pregnancyTypeCollapsedLabel.hidden = NO;
        self.pregnancyCollapsedLabel.hidden = NO;
        self.pregnancyTypeImageView.hidden = NO;
        self.placeholderLabel.hidden = YES;
    }else{
        // Minimized Cell, Without Data
        self.placeholderLabel.hidden = NO;
        self.pregnancyCollapsedLabel.hidden = YES;
        self.pregnancyTypeCollapsedLabel.hidden = YES;
        self.pregnancyTypeImageView.hidden = YES;
    }

}

- (void)setExpanded
{
    self.pregnancyTypeNegativeImageView.hidden = NO;
    self.pregnancyTypeNegtaiveLabel.hidden = NO;
    
    self.pregnancyTypePositiveImageView.hidden = NO;
    self.pregnancyTypePositiveLabel.hidden = NO;
        
    self.placeholderLabel.hidden = YES;
    self.pregnancyCollapsedLabel.hidden = NO;
    self.pregnancyTypeCollapsedLabel.hidden = YES;
    self.pregnancyTypeImageView.hidden = YES;
}

@end
