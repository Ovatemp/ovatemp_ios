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
//    self.selectedDate = [[NSDate alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)didSelectDry:(id)sender
{
    if (self.selectedCervicalFluidType == CervicalFluidSelectionDry) { // deselect
        self.selectedCervicalFluidType = CervicalFluidSelectionNone;
        [self hitBackendWithCervicalFluidType:[NSNull null]];
        [self.dryImageView setSelected:NO];
        self.cfTypeCollapsedLabel.text = @"";
    } else {
        self.selectedCervicalFluidType = CervicalFluidSelectionDry;
        [self hitBackendWithCervicalFluidType:@"dry"];
        
        // update local labels
        self.cfTypeCollapsedLabel.text = @"Dry";
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_dry"];
        
        [self deselectAllButtons];
        [self.dryImageView setSelected:YES];
    }
}

- (IBAction)didSelectSticky:(id)sender
{
    if (self.selectedCervicalFluidType == CervicalFluidSelectionSticky) {
        self.selectedCervicalFluidType = CervicalFluidSelectionNone;
        [self hitBackendWithCervicalFluidType:[NSNull null]];
        [self.stickyImageView setSelected:NO];
        self.cfTypeCollapsedLabel.text = @"";
    } else {
        self.selectedCervicalFluidType = CervicalFluidSelectionSticky;
        [self hitBackendWithCervicalFluidType:@"sticky"];
        self.cfTypeCollapsedLabel.text = @"Sticky";
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_sticky"];
        
        [self deselectAllButtons];
        [self.stickyImageView setSelected:YES];
    }
}
- (IBAction)didSelectCreamy:(id)sender
{
    if (self.selectedCervicalFluidType == CervicalFluidSelectionCreamy) {
        self.selectedCervicalFluidType = CervicalFluidSelectionNone;
        [self hitBackendWithCervicalFluidType:[NSNull null]];
        [self.creamyImageView setSelected:NO];
        self.cfTypeCollapsedLabel.text = @"";
    } else {
        self.selectedCervicalFluidType = CervicalFluidSelectionCreamy;
        [self hitBackendWithCervicalFluidType:@"creamy"];
        self.cfTypeCollapsedLabel.text = @"Creamy";
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_creamy"];
        
        [self deselectAllButtons];
        [self.creamyImageView setSelected:YES];
    }
}
- (IBAction)didSelectEggwhite:(id)sender
{
    if (self.selectedCervicalFluidType == CervicalFluidSelectionEggwhite) {
        self.selectedCervicalFluidType = CervicalFluidSelectionNone;
        [self hitBackendWithCervicalFluidType:[NSNull null]];
        [self.eggwhiteImageView setSelected:NO];
        self.cfTypeCollapsedLabel.text = @"";
    } else {
        self.selectedCervicalFluidType = CervicalFluidSelectionEggwhite;
        [self hitBackendWithCervicalFluidType:@"eggwhite"];
        self.cfTypeCollapsedLabel.text = @"Eggwhite";
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_eggwhite"];
        
        [self deselectAllButtons];
        [self.eggwhiteImageView setSelected:YES];
    }
}

- (void)deselectAllButtons
{
    [self.dryImageView setSelected:NO];
    [self.stickyImageView setSelected:NO];
    [self.creamyImageView setSelected:NO];
    [self.eggwhiteImageView setSelected:NO];
}

- (void)hitBackendWithCervicalFluidType:(id)cfType
{
    NSDate *selectedDate = [self.delegate getSelectedDate];
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setObject: cfType forKey: @"cervical_fluid"];
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
