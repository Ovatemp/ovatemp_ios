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
        
        self.placeholderLabel.hidden = YES;
        self.cfCollapsedLabel.hidden = NO;
        self.cfTypeCollapsedLabel.text = @"Dry";
        self.cfTypeCollapsedLabel.hidden = NO;
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_dry"];
        self.cfTypeImageView.hidden = NO;
        [self.dryImageView setSelected:YES];
        [self.stickyImageView setSelected:NO];
        [self.creamyImageView setSelected:NO];
        [self.eggwhiteImageView setSelected:NO];
        
    } else if ([selectedDay.cervicalFluid isEqual: @"sticky"]) {
        
        self.selectedCervicalFluidType = CervicalFluidSelectionSticky;
        
        self.placeholderLabel.hidden = YES;
        self.cfCollapsedLabel.hidden = NO;
        self.cfTypeCollapsedLabel.text = @"Sticky";
        self.cfTypeCollapsedLabel.hidden = NO;
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_sticky"];
        self.cfTypeImageView.hidden = NO;
        [self.stickyImageView setSelected:YES];
        [self.dryImageView setSelected:NO];
        [self.creamyImageView setSelected:NO];
        [self.eggwhiteImageView setSelected:NO];
        
    } else if ([selectedDay.cervicalFluid isEqual: @"creamy"]) {
        
        self.selectedCervicalFluidType = CervicalFluidSelectionCreamy;
        
        self.placeholderLabel.hidden = YES;
        self.cfCollapsedLabel.hidden = NO;
        self.cfTypeCollapsedLabel.text = @"Creamy";
        self.cfTypeCollapsedLabel.hidden = NO;
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_creamy"];
        self.cfTypeImageView.hidden = NO;
        [self.creamyImageView setSelected:YES];
        [self.dryImageView setSelected:NO];
        [self.stickyImageView setSelected:NO];
        [self.eggwhiteImageView setSelected:NO];
        
    } else if ([selectedDay.cervicalFluid isEqual: @"eggwhite"]) {
        
        self.selectedCervicalFluidType = CervicalFluidSelectionEggwhite;
        
        self.placeholderLabel.hidden = YES;
        self.cfCollapsedLabel.hidden = NO;
        self.cfTypeCollapsedLabel.text = @"Eggwhite";
        self.cfTypeCollapsedLabel.hidden = NO;
        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_eggwhite"];
        self.cfTypeImageView.hidden = NO;
        [self.eggwhiteImageView setSelected:YES];
        [self.creamyImageView setSelected:NO];
        [self.dryImageView setSelected:NO];
        [self.stickyImageView setSelected:NO];
        
    } else { // no selection
        
        self.selectedCervicalFluidType = CervicalFluidSelectionNone;
        
        self.placeholderLabel.hidden = NO;
        self.cfCollapsedLabel.hidden = YES;
        self.cfTypeCollapsedLabel.text = @"";
        self.cfTypeCollapsedLabel.hidden = YES;
        //        self.cfTypeImageView.image = [UIImage imageNamed:@"icn_cf_eggwhite"];
        self.cfTypeImageView.hidden = YES;
        [self.eggwhiteImageView setSelected:NO];
        [self.creamyImageView setSelected:NO];
        [self.dryImageView setSelected:NO];
        [self.stickyImageView setSelected:NO];
        
    }
}

- (void)setMinimized
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    self.dryImageView.hidden = YES;
    self.dryLabel.hidden = YES;
    
    self.stickyImageView.hidden = YES;
    self.stickyLabel.hidden = YES;
    
    self.creamyImageView.hidden = YES;
    self.creamyLabel.hidden = YES;
    
    self.eggwhiteImageView.hidden = YES;
    self.eggwhiteLabel.hidden = YES;
    
    if (selectedDay.cervicalFluid.length > 0) {
        // Minimized Cell, With Data
        self.placeholderLabel.hidden = YES;
        self.cfCollapsedLabel.hidden = NO;
        self.cfTypeCollapsedLabel.hidden = NO;
        self.cfTypeImageView.hidden = NO;
    } else {
        // Minimized Cell, Without Data
        self.placeholderLabel.hidden = NO;
        self.cfCollapsedLabel.hidden = YES;
        self.cfTypeCollapsedLabel.hidden = YES;
        self.cfTypeImageView.hidden = YES;
    }
}

- (void)setExpanded
{
    // Expanded Cell
    self.dryImageView.hidden = NO;
    self.dryLabel.hidden = NO;
    
    self.stickyImageView.hidden = NO;
    self.stickyLabel.hidden = NO;
    
    self.creamyImageView.hidden = NO;
    self.creamyLabel.hidden = NO;
    
    self.eggwhiteImageView.hidden = NO;
    self.eggwhiteLabel.hidden = NO;
    
    self.placeholderLabel.hidden = YES;
    self.cfCollapsedLabel.hidden = NO;
    self.cfTypeCollapsedLabel.hidden = YES;
    self.cfTypeImageView.hidden = YES;
}

@end
