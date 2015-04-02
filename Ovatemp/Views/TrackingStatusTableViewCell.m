//
//  TrackingStatusTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 10/30/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingStatusTableViewCell.h"

#import "UserProfile.h"

@implementation TrackingStatusTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)presentNotesView:(id)sender
{
    if ([self.delegate respondsToSelector: @selector(pressedNotes)]) {
        [self.delegate pressedNotes];
    }
}

- (void)updateCell
{
    UserProfile *currentUserProfile = [UserProfile current];
    
    NSDate *peakDate = [self.delegate getPeakDate];
    NSDate *selectedDate = [self.delegate getSelectedDate];
    Day *selectedDay = [self.delegate getSelectedDay];
    NSMutableArray *datesWithPeriod = [self.delegate getDatesWithPeriod];
    NSString *notes = [self.delegate getNotes];

    if ([notes length] > 0) {
        [self.notesButton setImage:[UIImage imageNamed:@"icn_notes_entered"] forState:UIControlStateNormal];
    } else {
        [self.notesButton setImage:[UIImage imageNamed:@"icn_notes_empty"] forState:UIControlStateNormal];
    }
    
    // FERTILITY STATUS CALCULATIONS
    
    // FIRST CHECKS FOR FERTILITY WINDOW BOOL, FROM BACKEND, IF TRUE IT RETURNS/EXITS OUT OF METHOD
    if (selectedDay.inFertilityWindow) {
        // IN FERTILITY WINDOW
        if ([selectedDay.cervicalFluid isEqualToString:@"eggwhite"]) {
            // PEAK FERTILITY
            if (currentUserProfile.tryingToConceive) {
                // TTC
                self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_fertile"];
                self.peakLabel.text = @"PEAK";
                self.fertilityLabel.text = @"FERTILITY";
                
                self.peakLabel.hidden = NO;
                self.fertilityLabel.hidden = NO;
                self.notEnoughInfoLabel.hidden = YES;
                self.periodLabel.hidden = YES;
                self.enterMoreInfoLabel.text = @"Optimal conditions to make babies!";
                self.enterMoreInfoLabel.hidden = NO;
                return;
            } else {
                // TTA
                self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_period-1"]; // I know it's not the period phase, my designer named the asset wrong
                self.peakLabel.text = @"PEAK";
                self.fertilityLabel.text = @"FERTILITY";
                
                self.peakLabel.hidden = NO;
                self.fertilityLabel.hidden = NO;
                self.notEnoughInfoLabel.hidden = YES;
                self.periodLabel.hidden = YES;
                self.enterMoreInfoLabel.text = @"Practice safe sex or avoid intercourse";
                self.enterMoreInfoLabel.hidden = NO;
                return;
            }
        } else {
            // REGULAR FERTILITY
            if (currentUserProfile.tryingToConceive) {
                // TTC
                self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_fertile"];
                self.periodLabel.text = @"FERTILE";
                self.periodLabel.hidden = NO;
                
                self.peakLabel.hidden = YES;
                self.fertilityLabel.hidden = YES;
                self.notEnoughInfoLabel.hidden = YES;
                self.enterMoreInfoLabel.text = @"Let’s get it on!";
                self.enterMoreInfoLabel.hidden = NO;
                return;
            } else {
                // TTA
                self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_period-1"]; // I know it's not the period phase, my designer named the asset wrong
                self.periodLabel.text = @"FERTILE";
                self.periodLabel.hidden = NO;
                
                self.peakLabel.hidden = YES;
                self.fertilityLabel.hidden = YES;
                self.notEnoughInfoLabel.hidden = YES;
                self.enterMoreInfoLabel.text = @"Practice safe sex or avoid intercourse";
                self.enterMoreInfoLabel.hidden = NO;
                return;
            }
        }
    }
    
    // IF DAY = SPOTTING, COULD BE PERIOD OR COULD BE RANDOM
    // get day before selected date
    // if that object is in the datesWithPeriod array and day.cyclePhase is not period, set day.cyclePhase to period
    if ([selectedDay.period isEqualToString:@"spotting"]) {
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = -1;
        NSCalendar *currentCalendar = [NSCalendar currentCalendar];
        NSDate *dayBeforeSelectedDate = [currentCalendar dateByAddingComponents: dayComponent toDate: selectedDate options:0];
        
        NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
        [dtFormatter setLocale:[NSLocale systemLocale]];
        [dtFormatter setDateFormat:@"yyyy-MM-dd"];
        
        for (NSDate *periodDate in datesWithPeriod) {
            if ([[dtFormatter stringFromDate:periodDate] isEqualToString:[dtFormatter stringFromDate:dayBeforeSelectedDate]]) {
                selectedDay.cyclePhase = @"period";
            }
        }
        
    }
    
    // FERTILITY WINDOW WAS FALSE
    // NOW CHECKS FOR CYCLE PHASE PARAMETER, FROM BACKEND
    
    if ([selectedDay.cyclePhase isEqualToString: @"period"]) {
        
        // CYCLE PHASE = PERIOD
        // NOT FERTILE
        
        self.notEnoughInfoLabel.hidden = YES;
        
        // set period, hide others
        self.periodLabel.text = @"PERIOD";
        self.periodLabel.hidden = NO;
        self.peakLabel.hidden = YES;
        self.fertilityLabel.hidden = YES;
        
        self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_period"];
        if (currentUserProfile.tryingToConceive) {
            // TTC
            self.enterMoreInfoLabel.text = @"Try to get some rest";
        } else {
            // TTA
            self.enterMoreInfoLabel.text = @"The first five days of your cycle are safe";
        }
        self.enterMoreInfoLabel.hidden = NO;
        
    } else if ([selectedDay.cyclePhase isEqualToString:@"ovulation"]) {
        
        // CYCLE PHASE = OVULATION
        // FERTILE
        
        if ([selectedDate isEqual: peakDate]) {
            // PEAK FERTILITY
            self.peakLabel.text = @"PEAK";
            self.fertilityLabel.text = @"FERTILITY";
            
            self.peakLabel.hidden = NO;
            self.fertilityLabel.hidden = NO;
            self.notEnoughInfoLabel.hidden = YES;
            
            if (currentUserProfile.tryingToConceive) {
                // TTC
                self.enterMoreInfoLabel.text = @"Optimal conditions to make babies!";
                self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_fertile"];
            } else {
                // TTA
                self.enterMoreInfoLabel.text = @"Practice safe sex or avoid intercourse";
                self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_period-1"]; // I know it's not the period phase, my designer named the asset wrong
            }
            
            self.enterMoreInfoLabel.hidden = NO;
            self.periodLabel.hidden = YES;
            
        } else {
            // REGULAR FERTILITY
            self.periodLabel.text = @"FERTILE";
            self.periodLabel.hidden = NO;
            
            self.peakLabel.hidden = YES;
            self.fertilityLabel.hidden = YES;
            self.notEnoughInfoLabel.hidden = YES;
            
            if (currentUserProfile.tryingToConceive) {
                // green fertility image
                self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_fertile"];
                self.enterMoreInfoLabel.text = @"Let’s get it on!";
            } else {
                // trying to avoid, red fertility image
                self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_period-1"]; // I know it's not the period phase, my designer named the asset wrong
                self.enterMoreInfoLabel.text = @"Practice safe sex or avoid intercourse";
            }
            
            self.enterMoreInfoLabel.hidden = NO;
        }
        
    } else if ([selectedDay.cyclePhase isEqualToString:@"preovulation"]) {
        
        // CYCLE PHASE = PRE-OVULATION
        // NOT FERTILE
        
        if (currentUserProfile.tryingToConceive) {
            // TTC
            self.enterMoreInfoLabel.text = @"Fertile window about to open, check for Cervical Fluid";
        } else {
            // TTA
            self.enterMoreInfoLabel.text = @"You are safe on the evening of a dry day";
        }
        
        if ([selectedDay.cervicalFluid isEqualToString:@"dry"] && !currentUserProfile.tryingToConceive) {
            // YELLOW CAUTION IMAGE
            self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_notfertile-1"];
        } else {
            self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_notfertile"];
        }
        
        self.notEnoughInfoLabel.hidden = YES;
        
        self.peakLabel.text = @"NOT";
        self.fertilityLabel.text = @"FERTILE";
        
        self.peakLabel.hidden = NO;
        self.fertilityLabel.hidden = NO;
        self.notEnoughInfoLabel.hidden = YES;
        self.periodLabel.hidden = YES;
        
        self.enterMoreInfoLabel.hidden = NO;
        
        if ([selectedDay.cervicalFluid isEqualToString:@"sticky"] && !currentUserProfile.tryingToConceive) {
            // FERTILE
            // RESET EVERYTHING TO RED
            self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_period-1"]; // I know it's not the period phase, my designer named the asset wrong
            
            self.periodLabel.text = @"FERTILE";
            self.periodLabel.hidden = NO;
            
            self.peakLabel.hidden = YES;
            self.fertilityLabel.hidden = YES;
            self.notEnoughInfoLabel.hidden = YES;
            self.enterMoreInfoLabel.text = @"Practice safe sex or avoid intercourse";
            self.enterMoreInfoLabel.hidden = NO;
        }
        
    } else if ([selectedDay.cyclePhase isEqualToString: @"postovulation"]) {
        
        // CYCLE PHASE = POST-OVULATION
        // NOT FERTILE
        
        self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_notfertile"];
        
        self.notEnoughInfoLabel.hidden = YES;
        
        self.peakLabel.text = @"NOT";
        self.fertilityLabel.text = @"FERTILE";
        
        self.peakLabel.hidden = NO;
        self.fertilityLabel.hidden = NO;
        self.notEnoughInfoLabel.hidden = YES;
        self.periodLabel.hidden = YES;
        
        if (currentUserProfile.tryingToConceive) {
            // TTC
            self.enterMoreInfoLabel.text = @"Crossing our fingers for you!";
        } else {
            // TTA
            self.enterMoreInfoLabel.text = @"You’re safe to have unprotected sex until your next period";
        }
        
        self.enterMoreInfoLabel.hidden = NO;
        
    } else {
        
        // NOT ENOUGH INFO
        
        self.notEnoughInfoLabel.hidden = NO;
        self.periodLabel.hidden = YES;
        self.peakLabel.hidden = YES;
        self.fertilityLabel.hidden = YES;
        self.enterMoreInfoLabel.hidden = YES;
        
        self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_empty"];
    }
}

@end
