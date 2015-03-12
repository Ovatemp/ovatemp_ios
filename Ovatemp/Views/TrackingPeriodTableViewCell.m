//
//  TrackingPeriodTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/6/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingPeriodTableViewCell.h"
#import "ConnectionManager.h"
#import "Cycle.h"
#import "Calendar.h"
#import "Alert.h"

#import "TrackingViewController.h"

@interface TrackingPeriodTableViewCell ()

@property PeriodSelectionType selectedPeriodType;

@end

@implementation TrackingPeriodTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
//    self.selectedDate = [[NSDate alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)didSelectNone:(id)sender
{
    if (self.selectedPeriodType == PeriodSelectionNone) {
        self.selectedPeriodType = PeriodSelectionNoSelection;
        [self hitBackendWithPeriodType:[NSNull null]];
        [self deselectAllButtons];
        self.periodTypeCollapsedLabel.text = @"";
    } else {
        self.selectedPeriodType = PeriodSelectionNone;
        self.periodTypeCollapsedLabel.text = @"None";
        self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_none"];
        [self hitBackendWithPeriodType:@"none"];
        
        [self deselectAllButtons];
        [self.noneImageView setSelected:YES];
    }
}

- (IBAction)didSelectSpotting:(id)sender
{
    if (self.selectedPeriodType == PeriodSelectionSpotting) {
        self.selectedPeriodType = PeriodSelectionNoSelection;
        [self hitBackendWithPeriodType:[NSNull null]];
        [self deselectAllButtons];
        self.periodTypeCollapsedLabel.text = @"";
    } else {
        self.selectedPeriodType = PeriodSelectionSpotting;
        self.periodTypeCollapsedLabel.text = @"Spotting";
        self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_spotting"];
        [self hitBackendWithPeriodType:@"spotting"];
        
        [self deselectAllButtons];
        [self.spottingImageView setSelected:YES];
    }
}

- (IBAction)didSelectLight:(id)sender
{
    if (self.selectedPeriodType == PeriodSelectionLight) {
        self.selectedPeriodType = PeriodSelectionNoSelection;
        [self hitBackendWithPeriodType:[NSNull null]];
        [self deselectAllButtons];
        self.periodTypeCollapsedLabel.text = @"";
    } else {
        self.selectedPeriodType = PeriodSelectionLight;
        self.periodTypeCollapsedLabel.text = @"Light";
        self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_light"];
        [self hitBackendWithPeriodType:@"light"];
        
        [self deselectAllButtons];
        [self.lightImageView setSelected:YES];
    }
}

- (IBAction)didSelectMedium:(id)sender
{
    if (self.selectedPeriodType == PeriodSelectionMedium) {
        self.selectedPeriodType = PeriodSelectionNoSelection;
        [self hitBackendWithPeriodType:[NSNull null]];
        [self deselectAllButtons];
        self.periodTypeCollapsedLabel.text = @"";
    } else {
        self.selectedPeriodType = PeriodSelectionMedium;
        self.periodTypeCollapsedLabel.text = @"Medium";
        self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_medium"];
        [self hitBackendWithPeriodType:@"medium"];
        
        [self deselectAllButtons];
        [self.mediumImageView setSelected:YES];
    }
}

- (IBAction)didSelectHeavy:(id)sender
{
    if (self.selectedPeriodType == PeriodSelectionHeavy) {
        self.selectedPeriodType = PeriodSelectionNoSelection;
        [self hitBackendWithPeriodType:[NSNull null]];
        [self deselectAllButtons];
        self.periodTypeCollapsedLabel.text = @"";
    } else {
        self.selectedPeriodType = PeriodSelectionHeavy;
        self.periodTypeCollapsedLabel.text = @"Heavy";
        self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_heavy"];
        [self hitBackendWithPeriodType:@"heavy"];
        
        [self deselectAllButtons];
        [self.heavyImageView setSelected:YES];
    }
}

- (void)deselectAllButtons
{
    [self.noneImageView setSelected:NO];
    [self.spottingImageView setSelected:NO];
    [self.lightImageView setSelected:NO];
    [self.mediumImageView setSelected:NO];
    [self.heavyImageView setSelected:NO];
}

- (void)hitBackendWithPeriodType:(id)periodType
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    NSDate *selectedDate = [self.delegate getSelectedDate];
    
    [attributes setObject: periodType forKey: @"period"];
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

- (IBAction)didSelectInfoButton:(id)sender
{
    [self.delegate pushInfoAlertWithTitle:@"Period" AndMessage:@"Your period can last for 3 to 7 days and represents the beginning of a new cycle. You should always consider the first day of bleeding as your Cycle Day 1.  Spotting does not count." AndURL:@"http://ovatemp.helpshift.com/a/ovatemp/?s=fertility-faqs&f=learn-more-about-your-period"];
}

#pragma mark - Appearance

- (void)updateCell
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    if ([selectedDay.period isEqualToString: @"none"]) {
        
        self.selectedPeriodType = PeriodSelectionNone;
        
        self.placeholderLabel.hidden = YES;
        self.periodCollapsedLabel.hidden = NO;
        self.periodTypeCollapsedLabel.text = @"None";
        self.periodTypeCollapsedLabel.hidden = YES;
        self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_none"];
        [self.noneImageView setSelected:YES];
        [self.spottingImageView setSelected:NO];
        [self.lightImageView setSelected:NO];
        [self.mediumImageView setSelected:NO];
        [self.heavyImageView setSelected:NO];
        
    } else if ([selectedDay.period isEqualToString: @"spotting"]) {
        
        self.selectedPeriodType = PeriodSelectionSpotting;
        
        self.placeholderLabel.hidden = YES;
        self.periodCollapsedLabel.hidden = NO;
        self.periodTypeCollapsedLabel.text = @"Spotting";
        self.periodTypeCollapsedLabel.hidden = YES;
        self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_spotting"];
        [self.spottingImageView setSelected:YES];
        
    } else if ([selectedDay.period isEqual: @"light"]) {
        
        self.selectedPeriodType = PeriodSelectionLight;
        
        self.placeholderLabel.hidden = YES;
        self.periodCollapsedLabel.hidden = NO;
        self.periodTypeCollapsedLabel.text = @"Light";
        self.periodTypeCollapsedLabel.hidden = YES;
        self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_light"];
        [self.lightImageView setSelected:YES];
        [self.noneImageView setSelected:NO];
        [self.spottingImageView setSelected:NO];
        [self.mediumImageView setSelected:NO];
        [self.heavyImageView setSelected:NO];
        
    } else if ([selectedDay.period isEqual: @"medium"]) {
        
        self.selectedPeriodType = PeriodSelectionMedium;
        
        self.placeholderLabel.hidden = YES;
        self.periodCollapsedLabel.hidden = NO;
        self.periodTypeCollapsedLabel.text = @"Medium";
        self.periodTypeCollapsedLabel.hidden = NO;
        self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_medium"];
        [self.mediumImageView setSelected:YES];
        [self.noneImageView setSelected:NO];
        [self.spottingImageView setSelected:NO];
        [self.lightImageView setSelected:NO];
        [self.heavyImageView setSelected:NO];
        
    } else if ([selectedDay.period isEqual: @"heavy"]) {
        
        self.selectedPeriodType = PeriodSelectionHeavy;
        
        self.placeholderLabel.hidden = YES;
        self.periodCollapsedLabel.hidden = NO;
        self.periodTypeCollapsedLabel.text = @"Heavy";
        self.periodTypeCollapsedLabel.hidden = YES;
        self.periodTypeImageView.image = [UIImage imageNamed:@"icn_p_heavy"];
        [self.heavyImageView setSelected:YES];
        [self.noneImageView setSelected:NO];
        [self.spottingImageView setSelected:NO];
        [self.lightImageView setSelected:NO];
        [self.mediumImageView setSelected:NO];
        
    } else {
        
        self.selectedPeriodType = PeriodSelectionNone;
        
        self.placeholderLabel.hidden = NO;
        self.periodCollapsedLabel.hidden = NO;
        self.periodTypeCollapsedLabel.text = @"";
        self.periodTypeCollapsedLabel.hidden = NO;
        self.periodTypeImageView.hidden = YES;
        [self.noneImageView setSelected:NO];
        [self.spottingImageView setSelected:NO];
        [self.lightImageView setSelected:NO];
        [self.mediumImageView setSelected:NO];
        [self.heavyImageView setSelected:NO];
        
    }
}

- (void)setMinimized
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    self.noneImageView.hidden = YES;
    self.noneLabel.hidden = YES;
    
    self.spottingImageView.hidden = YES;
    self.spottingLabel.hidden = YES;
    
    self.lightImageView.hidden = YES;
    self.lightLabel.hidden = YES;
    
    self.mediumImageView.hidden = YES;
    self.mediumLabel.hidden = YES;
    
    self.heavyImageView.hidden = YES;
    self.heavyLabel.hidden = YES;

    if (selectedDay.period.length > 0) {
        // Minimized Cell, With Data
        self.placeholderLabel.hidden = YES;
        self.periodCollapsedLabel.hidden = NO;
        self.periodTypeCollapsedLabel.hidden = NO;
        self.periodTypeImageView.hidden = NO;
    }else{
        // Minimized Cell, Without Data
        self.placeholderLabel.hidden = NO;
        self.periodCollapsedLabel.hidden = YES;
        self.periodTypeCollapsedLabel.hidden = YES;
        self.periodTypeImageView.hidden = YES;
    }
    
}

- (void)setExpanded
{
    self.noneImageView.hidden = NO;
    self.noneLabel.hidden = NO;
    
    self.spottingImageView.hidden = NO;
    self.spottingLabel.hidden = NO;
    
    self.lightImageView.hidden = NO;
    self.lightLabel.hidden = NO;
    
    self.mediumImageView.hidden = NO;
    self.mediumLabel.hidden = NO;
    
    self.heavyImageView.hidden = NO;
    self.heavyLabel.hidden = NO;
    
    self.placeholderLabel.hidden = YES;
    self.periodCollapsedLabel.hidden = NO;
    self.periodTypeCollapsedLabel.hidden = YES;
    self.periodTypeImageView.hidden = YES;
}

@end
