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
        
        if (currentUserProfile.tryingToConceive) {
            
            self.peakLabel.text = @"PEAK";
            self.fertilityLabel.text = @"FERTILITY";
            self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_fertile"];
            
            self.peakLabel.hidden = NO;
            self.fertilityLabel.hidden = NO;
            self.notEnoughInfoLabel.hidden = YES;
            self.periodLabel.hidden = YES;
            
            self.enterMoreInfoLabel.text = selectedDay.fertility.message;
            self.enterMoreInfoLabel.hidden = NO;
            
        }else{

            self.peakLabel.text = @"PEAK";
            self.fertilityLabel.text = @"FERTILITY";
            self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_period-1"]; // I know it's not the period phase, my designer named the asset wrong
            
            self.peakLabel.hidden = NO;
            self.fertilityLabel.hidden = NO;
            self.notEnoughInfoLabel.hidden = YES;
            self.periodLabel.hidden = YES;
            
            self.enterMoreInfoLabel.text = selectedDay.fertility.message;
            self.enterMoreInfoLabel.hidden = NO;
            
        }
        
    }else if (selectedDay.fertility.status == ILFertilityStatusTypeFertile){
     
        if (currentUserProfile.tryingToConceive) {
            
            self.periodLabel.text = @"FERTILE";
            self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_fertile"];

            self.periodLabel.hidden = NO;
            self.peakLabel.hidden = YES;
            self.fertilityLabel.hidden = YES;
            self.notEnoughInfoLabel.hidden = YES;
            
            self.enterMoreInfoLabel.text = selectedDay.fertility.message;
            self.enterMoreInfoLabel.hidden = NO;
            
        }else{
            
            self.periodLabel.text = @"FERTILE";
            self.periodLabel.hidden = NO;
            self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_period-1"]; // I know it's not the period phase, my designer named the asset wrong
            
            self.peakLabel.hidden = YES;
            self.fertilityLabel.hidden = YES;
            self.notEnoughInfoLabel.hidden = YES;
            
            self.enterMoreInfoLabel.text = selectedDay.fertility.message;
            self.enterMoreInfoLabel.hidden = NO;
            
        }
        
    }else if (selectedDay.fertility.status == ILFertilityStatusTypeNotFertile) {
        
        self.peakLabel.text = @"NOT";
        self.fertilityLabel.text = @"FERTILE";
        self.cycleImageView.image = [UIImage imageNamed:@"icn_tracking_notfertile"];
        
        self.peakLabel.hidden = NO;
        self.fertilityLabel.hidden = NO;
        self.notEnoughInfoLabel.hidden = YES;
        self.periodLabel.hidden = YES;

        self.enterMoreInfoLabel.text = selectedDay.fertility.message;
        self.enterMoreInfoLabel.hidden = NO;
        
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
