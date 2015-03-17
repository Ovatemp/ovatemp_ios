//
//  TrackingCervicalFluidTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/5/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingCervicalFluidTableViewCell.h"
#import "Alert.h"
#import "ConnectionManager.h"
#import "Cycle.h"
#import "Calendar.h"

#import "TrackingViewController.h"

@interface TrackingCervicalFluidTableViewCell ()

@property (nonatomic) CervicalFluidSelectionType selectedCervicalFluidType;

@end

@implementation TrackingCervicalFluidTableViewCell

- (void)awakeFromNib
{
    self.activityView.hidden = YES;
    self.activityView.hidesWhenStopped = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(startActivity)
                                                 name: @"cf_start_activity"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(stopActivity)
                                                 name: @"cf_stop_activity"
                                               object: nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
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

- (IBAction)didSelectDry:(id)sender
{
    if (self.selectedCervicalFluidType == CervicalFluidSelectionDry) {
        self.selectedCervicalFluidType = CervicalFluidSelectionNone;
        
        [self.dryImageView setSelected:NO];
        self.cfTypeCollapsedLabel.text = @"";
        
        if ([self.delegate respondsToSelector: @selector(didSelectCervicalFluidType:)]) {
            [self.delegate didSelectCervicalFluidType: [NSNull null]];
        }
        
    } else {
        self.selectedCervicalFluidType = CervicalFluidSelectionDry;
        
        self.cfTypeCollapsedLabel.text = @"Dry";
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_dry"];
        
        [self deselectAllButtons];
        [self.dryImageView setSelected:YES];
        
        if ([self.delegate respondsToSelector: @selector(didSelectCervicalFluidType:)]) {
            [self.delegate didSelectCervicalFluidType: @"dry"];
        }
    }
}

- (IBAction)didSelectSticky:(id)sender
{
    if (self.selectedCervicalFluidType == CervicalFluidSelectionSticky) {
        self.selectedCervicalFluidType = CervicalFluidSelectionNone;
        
        [self.stickyImageView setSelected:NO];
        self.cfTypeCollapsedLabel.text = @"";
        
        if ([self.delegate respondsToSelector: @selector(didSelectCervicalFluidType:)]) {
            [self.delegate didSelectCervicalFluidType: [NSNull null]];
        }
        
    } else {
        self.selectedCervicalFluidType = CervicalFluidSelectionSticky;
        
        self.cfTypeCollapsedLabel.text = @"Sticky";
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_sticky"];
        
        [self deselectAllButtons];
        [self.stickyImageView setSelected:YES];
        
        if ([self.delegate respondsToSelector: @selector(didSelectCervicalFluidType:)]) {
            [self.delegate didSelectCervicalFluidType: @"sticky"];
        }
    }
}
- (IBAction)didSelectCreamy:(id)sender
{
    if (self.selectedCervicalFluidType == CervicalFluidSelectionCreamy) {
        self.selectedCervicalFluidType = CervicalFluidSelectionNone;
        
        [self.creamyImageView setSelected:NO];
        self.cfTypeCollapsedLabel.text = @"";
        
        if ([self.delegate respondsToSelector: @selector(didSelectCervicalFluidType:)]) {
            [self.delegate didSelectCervicalFluidType: [NSNull null]];
        }
        
    } else {
        self.selectedCervicalFluidType = CervicalFluidSelectionCreamy;
        
        self.cfTypeCollapsedLabel.text = @"Creamy";
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_creamy"];
        
        [self deselectAllButtons];
        [self.creamyImageView setSelected:YES];
        
        if ([self.delegate respondsToSelector: @selector(didSelectCervicalFluidType:)]) {
            [self.delegate didSelectCervicalFluidType: @"creamy"];
        }
    }
}
- (IBAction)didSelectEggwhite:(id)sender
{
    if (self.selectedCervicalFluidType == CervicalFluidSelectionEggwhite) {
        self.selectedCervicalFluidType = CervicalFluidSelectionNone;
        
        [self.eggwhiteImageView setSelected:NO];
        self.cfTypeCollapsedLabel.text = @"";
        
        if ([self.delegate respondsToSelector: @selector(didSelectCervicalFluidType:)]) {
            [self.delegate didSelectCervicalFluidType: [NSNull null]];
        }
        
    } else {
        self.selectedCervicalFluidType = CervicalFluidSelectionEggwhite;
        
        self.cfTypeCollapsedLabel.text = @"Eggwhite";
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_eggwhite"];
        
        [self deselectAllButtons];
        [self.eggwhiteImageView setSelected:YES];
        
        if ([self.delegate respondsToSelector: @selector(didSelectCervicalFluidType:)]) {
            [self.delegate didSelectCervicalFluidType: @"eggwhite"];
        }
    }
}

- (void)deselectAllButtons
{
    [self.dryImageView setSelected: NO];
    [self.stickyImageView setSelected: NO];
    [self.creamyImageView setSelected: NO];
    [self.eggwhiteImageView setSelected: NO];
}

- (IBAction)didSelectInfo:(id)sender
{
    [self.delegate pushInfoAlertWithTitle:@"Cervical Fluid" AndMessage:@"Cervical fluid is like the “water for the swimmers”. The wetter the fluid the more chances you have of getting pregnant.\n\nThere are three types of cervical fluid: sticky; the LEAST fertile, creamy; SOMEWHAT fertile and eggwhite; MOST fertile." AndURL:@"http://ovatemp.helpshift.com/a/ovatemp/?s=fertility-faqs&f=learn-more-about-cervical-fluid"];
}

#pragma mark - Appearance

- (void)updateCell
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    if ([selectedDay.cervicalFluid isEqual: @"dry"]) {
        
        self.selectedCervicalFluidType = CervicalFluidSelectionDry;
        
        self.placeholderLabel.alpha = 0.0;
        self.cfCollapsedLabel.alpha = 1.0;
        self.cfTypeCollapsedLabel.text = @"Dry";
        self.cfTypeCollapsedLabel.alpha = 1.0;
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_dry"];
        self.cfTypeImageView.alpha = 1.0;
        [self.dryImageView setSelected:YES];
        [self.stickyImageView setSelected:NO];
        [self.creamyImageView setSelected:NO];
        [self.eggwhiteImageView setSelected:NO];
        
    } else if ([selectedDay.cervicalFluid isEqual: @"sticky"]) {
        
        self.selectedCervicalFluidType = CervicalFluidSelectionSticky;
        
        self.placeholderLabel.alpha = 0.0;
        self.cfCollapsedLabel.alpha = 1.0;
        self.cfTypeCollapsedLabel.text = @"Sticky";
        self.cfTypeCollapsedLabel.alpha = 1.0;
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_sticky"];
        self.cfTypeImageView.alpha = 1.0;
        [self.stickyImageView setSelected:YES];
        [self.dryImageView setSelected:NO];
        [self.creamyImageView setSelected:NO];
        [self.eggwhiteImageView setSelected:NO];
        
    } else if ([selectedDay.cervicalFluid isEqual: @"creamy"]) {
        
        self.selectedCervicalFluidType = CervicalFluidSelectionCreamy;
        
        self.placeholderLabel.alpha = 0.0;
        self.cfCollapsedLabel.alpha = 1.0;
        self.cfTypeCollapsedLabel.text = @"Creamy";
        self.cfTypeCollapsedLabel.alpha = 1.0;
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_creamy"];
        self.cfTypeImageView.alpha = 1.0;
        [self.creamyImageView setSelected:YES];
        [self.dryImageView setSelected:NO];
        [self.stickyImageView setSelected:NO];
        [self.eggwhiteImageView setSelected:NO];
        
    } else if ([selectedDay.cervicalFluid isEqual: @"eggwhite"]) {
        
        self.selectedCervicalFluidType = CervicalFluidSelectionEggwhite;
        
        self.placeholderLabel.alpha = 0.0;
        self.cfCollapsedLabel.alpha = 1.0;
        self.cfTypeCollapsedLabel.text = @"Eggwhite";
        self.cfTypeCollapsedLabel.alpha = 1.0;
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_eggwhite"];
        self.cfTypeImageView.alpha = 1.0;
        [self.eggwhiteImageView setSelected:YES];
        [self.creamyImageView setSelected:NO];
        [self.dryImageView setSelected:NO];
        [self.stickyImageView setSelected:NO];
        
    } else { // no selection
        
        self.selectedCervicalFluidType = CervicalFluidSelectionNone;
        
        self.placeholderLabel.alpha = 1.0;
        self.cfCollapsedLabel.alpha = 0.0;
        self.cfTypeCollapsedLabel.text = @"";
        self.cfTypeCollapsedLabel.alpha = 0.0;
        //        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_eggwhite"];
        self.cfTypeImageView.alpha = 0.0;
        [self.eggwhiteImageView setSelected:NO];
        [self.creamyImageView setSelected:NO];
        [self.dryImageView setSelected:NO];
        [self.stickyImageView setSelected:NO];
        
    }
}

- (void)setMinimized
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    self.dryImageView.alpha = 0.0;
    self.dryLabel.alpha = 0.0;
    
    self.stickyImageView.alpha = 0.0;
    self.stickyLabel.alpha = 0.0;
    
    self.creamyImageView.alpha = 0.0;
    self.creamyLabel.alpha = 0.0;
    
    self.eggwhiteImageView.alpha = 0.0;
    self.eggwhiteLabel.alpha = 0.0;
    
    if (selectedDay.cervicalFluid.length > 0) {
        // Minimized Cell, With Data
        self.placeholderLabel.alpha = 0.0;
        self.cfCollapsedLabel.alpha = 1.0;
        self.cfTypeCollapsedLabel.alpha = 1.0;
        self.cfTypeImageView.alpha = 1.0;
    } else {
        // Minimized Cell, Without Data
        self.placeholderLabel.alpha = 1.0;
        self.cfCollapsedLabel.alpha = 0.0;
        self.cfTypeCollapsedLabel.alpha = 0.0;
        self.cfTypeImageView.alpha = 0.0;
    }
}

- (void)setExpanded
{
    // Expanded Cell
    self.dryImageView.alpha = 1.0;
    self.dryLabel.alpha = 1.0;
    
    self.stickyImageView.alpha = 1.0;
    self.stickyLabel.alpha = 1.0;
    
    self.creamyImageView.alpha = 1.0;
    self.creamyLabel.alpha = 1.0;
    
    self.eggwhiteImageView.alpha = 1.0;
    self.eggwhiteLabel.alpha = 1.0;
    
    self.placeholderLabel.alpha = 0.0;
    self.cfCollapsedLabel.alpha = 1.0;
    self.cfTypeCollapsedLabel.alpha = 0.0;
    self.cfTypeImageView.alpha = 0.0;
}

@end
