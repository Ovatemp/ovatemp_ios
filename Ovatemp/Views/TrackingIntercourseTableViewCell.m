//
//  TrackingIntercourseTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/7/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingIntercourseTableViewCell.h"
#import "ConnectionManager.h"
#import "Calendar.h"
#import "Alert.h"

#import "TrackingViewController.h"

@interface TrackingIntercourseTableViewCell ()

@property IntercourseSelectionType selectedIntercourseType;

@end

@implementation TrackingIntercourseTableViewCell

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
                                                 name: @"intercourse_start_activity"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(stopActivity)
                                                 name: @"intercourse_stop_activity"
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

- (IBAction)didSelectUnprotected:(id)sender
{
    if (self.selectedIntercourseType == IntercourseSelectionUnprotected) {
        self.selectedIntercourseType = IntercourseSelectionNone;
        
        [self.protectedImageView setSelected:NO];
        [self.unprotectedImageView setSelected:NO];
        self.intercourseTypeCollapsedLabel.text = @"";
        
        if ([self.delegate respondsToSelector: @selector(didSelectIntercourseWithType:)]) {
            [self.delegate didSelectIntercourseWithType: [NSNull null]];
        }
        
    } else {
        self.selectedIntercourseType = IntercourseSelectionUnprotected;
        
        self.intercourseTypeCollapsedLabel.text = @"Unprotected";
        self.intercourseTypeCollapsedImageView.image = [UIImage imageNamed:@"icn_i_unprotected"];
        [self.protectedImageView setSelected:NO];
        [self.unprotectedImageView setSelected:YES];
        
        if ([self.delegate respondsToSelector: @selector(didSelectIntercourseWithType:)]) {
            [self.delegate didSelectIntercourseWithType: @"unprotected"];
        }
        
    }
}

- (IBAction)didSelectProtected:(id)sender
{
    if (self.selectedIntercourseType == IntercourseSelectionProtected) {
        self.selectedIntercourseType = IntercourseSelectionNone;
        
        [self.protectedImageView setSelected:NO];
        [self.unprotectedImageView setSelected:NO];
        self.intercourseTypeCollapsedLabel.text = @"";
        
        if ([self.delegate respondsToSelector: @selector(didSelectIntercourseWithType:)]) {
            [self.delegate didSelectIntercourseWithType: [NSNull null]];
        }
        
    } else {
        self.selectedIntercourseType = IntercourseSelectionProtected;
        
        self.intercourseTypeCollapsedLabel.text = @"Protected";
        self.intercourseTypeCollapsedImageView.image = [UIImage imageNamed:@"icn_i_protected"];
        [self.protectedImageView setSelected:YES];
        [self.unprotectedImageView setSelected:NO];
        
        if ([self.delegate respondsToSelector: @selector(didSelectIntercourseWithType:)]) {
            [self.delegate didSelectIntercourseWithType: @"protected"];
        }
        
    }
}

- (IBAction)didSelectInfoButton:(id)sender
{
    [self.delegate pushInfoAlertWithTitle:@"Intercourse" AndMessage:@"Fancy word for sex. When trying to conceive you should have unprotected sex. When trying to avoid we recommend that you have protected sex when you are not on a dry day or your temperature has not risen yet  since a temperature shift is the only way to confirm ovulation.\n\nAlways use protection against STDs when you are not in a committed relationship." AndURL:@"http://ovatemp.helpshift.com/a/ovatemp/?s=fertility-faqs&f=learn-more-about-timing-intercourse"];
}

- (void)updateCell
{
    ILDay *selectedDay = [self.delegate getSelectedDay];
    
    if ([selectedDay.intercourse isEqualToString:@"protected"]) {
        
        self.selectedIntercourseType = IntercourseSelectionProtected;
        
        self.placeholderLabel.hidden = YES;
        self.intercourseCollapsedLabel.hidden = NO;
        self.intercourseTypeCollapsedLabel.text = @"Protected";
        self.intercourseTypeCollapsedLabel.hidden = YES;
        self.intercourseTypeCollapsedImageView.image = [UIImage imageNamed:@"icn_i_protected"];
        [self.protectedImageView setSelected:YES];
        [self.unprotectedImageView setSelected:NO];
        
        
    } else if ([selectedDay.intercourse isEqualToString:@"unprotected"]) {
        
        self.selectedIntercourseType = IntercourseSelectionUnprotected;
        
        self.placeholderLabel.hidden = YES;
        self.intercourseCollapsedLabel.hidden = NO;
        self.intercourseTypeCollapsedLabel.text = @"Unprotected";
        self.intercourseTypeCollapsedLabel.hidden = YES;
        self.intercourseTypeCollapsedImageView.image = [UIImage imageNamed:@"icn_i_unprotected"];
        [self.protectedImageView setSelected:NO];
        [self.unprotectedImageView setSelected:YES];
        
        
    } else {
        
        self.selectedIntercourseType = IntercourseSelectionNone;
        
        self.placeholderLabel.hidden = NO;
        self.intercourseCollapsedLabel.hidden = YES;
        self.intercourseTypeCollapsedLabel.text = @"";
        self.intercourseTypeCollapsedLabel.hidden = YES;
        self.intercourseTypeCollapsedImageView.hidden = YES;
        [self.protectedImageView setSelected:NO];
        [self.unprotectedImageView setSelected:NO];
        
    }
}

- (void)setMinimized
{
    ILDay *selectedDay = [self.delegate getSelectedDay];
    
    self.protectedImageView.hidden = YES;
    self.protectedLabel.hidden = YES;
    
    self.unprotectedImageView.hidden = YES;
    self.unprotectedLabel.hidden = YES;
    
    if (selectedDay.intercourse.length > 0) {
        self.placeholderLabel.hidden = YES;
        self.intercourseCollapsedLabel.hidden = NO;
        self.intercourseTypeCollapsedLabel.hidden = NO;
        self.intercourseTypeCollapsedImageView.hidden = NO;
    } else {
        self.placeholderLabel.hidden = NO;
        self.intercourseCollapsedLabel.hidden = YES;
        self.intercourseTypeCollapsedLabel.hidden = YES;
        self.intercourseTypeCollapsedImageView.hidden = YES;
    }
    
}

- (void)setExpanded
{
    self.unprotectedImageView.hidden = NO;
    self.unprotectedLabel.hidden = NO;
    
    self.protectedImageView.hidden = NO;
    self.protectedLabel.hidden = NO;
    
    self.placeholderLabel.hidden = YES;
    self.intercourseCollapsedLabel.hidden = NO;
    self.intercourseTypeCollapsedLabel.hidden = YES;
    self.intercourseTypeCollapsedImageView.hidden = YES;
}

@end
