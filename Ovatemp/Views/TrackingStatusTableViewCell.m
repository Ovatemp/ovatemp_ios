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
    ILDay *selectedDay = [self.delegate getSelectedDay];
    UserProfile *currentUserProfile = [UserProfile current];
    
    if ([selectedDay.notes length] > 0) {
        [self.notesButton setImage:[UIImage imageNamed:@"icn_notes_entered"] forState:UIControlStateNormal];
    } else {
        [self.notesButton setImage:[UIImage imageNamed:@"icn_notes_empty"] forState:UIControlStateNormal];
    }
    
    if (selectedDay.fertility.status == ILFertilityStatusTypePeriod) {
        
        self.periodLabel.text = @"PERIOD";
        self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_period"];
        
        self.notEnoughInfoLabel.hidden = YES;
        self.periodLabel.hidden = NO;
        self.peakLabel.hidden = YES;
        self.fertilityLabel.hidden = YES;
        self.enterMoreInfoLabel.text = selectedDay.fertility.message;
        self.enterMoreInfoLabel.hidden = NO;
        
    }else if (selectedDay.fertility.status == ILFertilityStatusTypePeakFertility) {
        
        self.peakLabel.text = @"PEAK";
        self.fertilityLabel.text = @"FERTILITY";

        self.peakLabel.hidden = NO;
        self.fertilityLabel.hidden = NO;
        self.notEnoughInfoLabel.hidden = YES;
        self.periodLabel.hidden = YES;
        self.enterMoreInfoLabel.text = selectedDay.fertility.message;
        self.enterMoreInfoLabel.hidden = NO;
        
        if (currentUserProfile.tryingToConceive) {
            self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_ttc_fertile"];
        }else{
            self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_tta_fertile"];
        }
        
    }else if (selectedDay.fertility.status == ILFertilityStatusTypeFertile){
     
        self.periodLabel.text = @"FERTILE";
        self.enterMoreInfoLabel.text = selectedDay.fertility.message;

        self.periodLabel.hidden = NO;
        self.peakLabel.hidden = YES;
        self.fertilityLabel.hidden = YES;
        self.notEnoughInfoLabel.hidden = YES;
        self.enterMoreInfoLabel.hidden = NO;

        if (currentUserProfile.tryingToConceive) {
            self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_ttc_fertile"];
        }else{
            self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_tta_fertile"];
        }
        
    }else if (selectedDay.fertility.status == ILFertilityStatusTypeNotFertile) {
        
        self.peakLabel.text = @"NOT";
        self.fertilityLabel.text = @"FERTILE";
        self.enterMoreInfoLabel.text = selectedDay.fertility.message;
        
        self.peakLabel.hidden = NO;
        self.fertilityLabel.hidden = NO;
        self.notEnoughInfoLabel.hidden = YES;
        self.periodLabel.hidden = YES;
        self.enterMoreInfoLabel.hidden = NO;
        
        if (currentUserProfile.tryingToConceive) {
            // Trying to Conceive
            self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_ttc_notfertile"];
        }else{
            // Trying to Avoid
            if ([selectedDay.cyclePhase isEqualToString: @"preovulation"]) {
                // Pre-Ovulation
                self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_tta_notfertile_pre"];
            }else{
                // Post-Ovulation
                self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_ttc_fertile"]; // Green indicator
            }
        }
        
    }else {
        
        self.notEnoughInfoLabel.hidden = NO;
        self.periodLabel.hidden = YES;
        self.peakLabel.hidden = YES;
        self.fertilityLabel.hidden = YES;
        self.enterMoreInfoLabel.hidden = YES;
        
        self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_empty"];
        
    }

}

@end
