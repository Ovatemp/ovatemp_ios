//
//  TrackingOvulationTestTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/9/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingOvulationTestTableViewCell.h"

#import "TrackingViewController.h"

#import "Calendar.h"
#import "Alert.h"

@interface TrackingOvulationTestTableViewCell ()

@property OvulationTestSelectionType selectedOvulationTestType;

@end

@implementation TrackingOvulationTestTableViewCell

- (void)awakeFromNib
{
//    self.selectedDate = [[NSDate alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)deselectAllButtons
{
    [self.ovulationTypeNegativeImageView setSelected:NO];
    [self.ovulationTypePositiveImageView setSelected:NO];
}

- (IBAction)didSelectNegative:(id)sender
{
    if (self.selectedOvulationTestType == OvulationTestSelectionNegative) {
        self.selectedOvulationTestType = OvulationTestSelectionNone;
        [self hitBackendWithOvulationTestType:[NSNull null]];
        [self deselectAllButtons];
        self.ovulationTypeCollapsedLabel.text = @"";
    } else {
        self.selectedOvulationTestType = OvulationTestSelectionNegative;
        [self hitBackendWithOvulationTestType:@"negative"];
        self.ovulationTypeCollapsedLabel.text = @"Negative";
        self.ovulationTypeImageView.image = [UIImage imageNamed:@"icn_negative"];
        
        [self deselectAllButtons];
        [self.ovulationTypeNegativeImageView setSelected:YES];
    }
}

- (IBAction)didSelectPositive:(id)sender
{
    if (self.selectedOvulationTestType == OvulationTestSelectionPositive) {
        self.selectedOvulationTestType = OvulationTestSelectionNone;
        [self hitBackendWithOvulationTestType:[NSNull null]];
        [self deselectAllButtons];
        self.ovulationTypeCollapsedLabel.text = @"";
    } else {
        self.selectedOvulationTestType = OvulationTestSelectionPositive;
        [self hitBackendWithOvulationTestType:@"positive"];
        self.ovulationTypeCollapsedLabel.text = @"Positive";
        self.ovulationTypeImageView.image = [UIImage imageNamed:@"icn_positive"];
        
        [self deselectAllButtons];
        [self.ovulationTypePositiveImageView setSelected:YES];
    }
}

- (void)hitBackendWithOvulationTestType:(id)otType
{
    NSDate *selectedDate = [self.delegate getSelectedDate];
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setObject: otType forKey: @"opk"];
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
    [self.delegate pushInfoAlertWithTitle:@"Ovulation Test" AndMessage:@"Ovulation tests detect a surge in Luteinizing Hormone (LH) and can help you time intercourse during ovulation to achieve pregnancy.\n\nNot recommended for birth control since sperm can last days in optimal conditions and it would be risky." AndURL:@"http://ovatemp.helpshift.com/a/ovatemp/?s=fertility-faqs&f=learn-more-about-ovulation-tests"];
}

#pragma mark - Appearance

- (void)updateCell
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
//    self.ovulationTypeCollapsedLabel.text = selectedDay.opk;
    
    if ([selectedDay.opk isEqualToString: @"positive"]) {
        
        self.selectedOvulationTestType = OvulationTestSelectionPositive;
        
        self.ovulationTypeCollapsedLabel.text = @"Positive";
        [self.ovulationTypeNegativeImageView setSelected:NO];
        [self.ovulationTypePositiveImageView setSelected:YES];
        self.ovulationTypeImageView.image = [UIImage imageNamed:@"icn_positive"];
        
    } else if([selectedDay.opk isEqualToString: @"negative"]) {
        
        self.selectedOvulationTestType = OvulationTestSelectionNegative;
        
        self.ovulationTypeCollapsedLabel.text = @"Positive";
        [self.ovulationTypeNegativeImageView setSelected:YES];
        [self.ovulationTypePositiveImageView setSelected:NO];
        self.ovulationTypeImageView.image = [UIImage imageNamed:@"icn_negative"];
        
    } else {
        
        self.selectedOvulationTestType = OvulationTestSelectionNone;
        
        self.ovulationTypeCollapsedLabel.text = @"";
        [self.ovulationTypeNegativeImageView setSelected:NO];
        [self.ovulationTypePositiveImageView setSelected:NO];
        self.imageView.hidden = YES;
        
    }
}

- (void)setMinimized
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    self.ovulationTypeNegativeImageView.hidden = YES;
    self.ovulationTypeNegativeLabel.hidden = YES;
    
    self.ovulationTypePositiveImageView.hidden = YES;
    self.ovulationTypePositiveLabel.hidden = YES;
    
    if (selectedDay.opk.length > 0) {
        // Minimized Cell, With Data
        self.ovulationTypeCollapsedLabel.hidden = NO;
        self.ovulationCollapsedLabel.hidden = NO;
        self.ovulationTypeImageView.hidden = NO;
        self.placeholderLabel.hidden = YES;
    } else {
        // Minimized Cell, Without Data
        self.ovulationTypeCollapsedLabel.hidden = YES;
        self.ovulationCollapsedLabel.hidden = YES;
        self.ovulationTypeImageView.hidden = YES;
        self.placeholderLabel.hidden = NO;
    }
}

- (void)setExpanded
{
    self.ovulationTypeNegativeImageView.hidden = NO;
    self.ovulationTypeNegativeLabel.hidden = NO;
    
    self.ovulationTypePositiveImageView.hidden = NO;
    self.ovulationTypePositiveLabel.hidden = NO;
    
    self.ovulationTypeCollapsedLabel.hidden = YES;
    self.ovulationCollapsedLabel.hidden = NO;
    self.ovulationTypeImageView.hidden = YES;
    self.placeholderLabel.hidden = YES;
}

@end
