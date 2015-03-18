//
//  TrackingMoodTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/7/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingMoodTableViewCell.h"

#import "ConnectionManager.h"
#import "Calendar.h"
#import "Alert.h"
#import "TrackingViewController.h"

@interface TrackingMoodTableViewCell () <UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation TrackingMoodTableViewCell

NSArray *moodDataSource;
NSIndexPath *selectedIndexPath;

- (void)awakeFromNib
{
    [self setUpActivityView];
    
    moodDataSource = [[NSArray alloc] initWithObjects: @"None", @"Angry", @"Anxious", @"Calm", @"Depressed", @"Emotional", @"Excited",
                      @"Frisky", @"Frustrated", @"Happy", @"In Love", @"Motivated", @"Neutral", @"Sad", @"Worried", nil];
    
    self.moodPickerView.delegate = self;
    self.moodPickerView.dataSource = self;
}

- (void)setUpActivityView
{
    self.activityView.hidden = YES;
    self.activityView.hidesWhenStopped = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(startActivity)
                                                 name: @"mood_start_activity"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(stopActivity)
                                                 name: @"mood_stop_activity"
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

- (IBAction)didSelectInfoButton:(id)sender
{
    [self.delegate pushInfoAlertWithTitle:@"Mood" AndMessage:@"Taking note of your mood throughout your cycle can help you identify patterns and understand both your cycles and your mood swings better.\n\nDid you know you feel your best when ovulating?" AndURL:@"http://ovatemp.helpshift.com/a/ovatemp/?s=fertility-faqs&f=learn-more-about-tracking-your-mood"];
}

#pragma mark - UIPickerView Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [moodDataSource count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [moodDataSource objectAtIndex: row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (row) {
        case 0:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: [NSNull null]];
            }
            self.moodTypeLabel.text = @"";
            
            break;
        }
        case 1:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"angry"];
            }
            self.moodTypeLabel.text = @"Angry";
            
            break;
        }
        case 2:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"anxious"];
            }
            self.moodTypeLabel.text = @"Anxious";
            
            break;
        }
        case 3:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"calm"];
            }
            self.moodTypeLabel.text = @"Calm";
            
            break;
        }
        case 4:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"depressed"];
            }
            self.moodTypeLabel.text = @"Depressed";
            
            break;
        }
        case 5:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"moody"];
            }
            self.moodTypeLabel.text = @"Emotional";
            
            break;
        }
        case 6:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"amazing"];
            }
            self.moodTypeLabel.text = @"Excited";
            
            break;
        }
        case 7:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"frisky"];
            }
            self.moodTypeLabel.text = @"Frisky";
            
            break;
        }
        case 8:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"frustrated"];
            }
            self.moodTypeLabel.text = @"Frustrated";
            
            break;
        }
        case 9:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"good"];
            }
            self.moodTypeLabel.text = @"Happy";
            
            break;
        }
        case 10:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"in love"];
            }
            self.moodTypeLabel.text = @"In Love";
            
            break;
        }
        case 11:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"motivated"];
            }
            self.moodTypeLabel.text = @"Motivated";
            
            break;
        }
        case 12:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"neutral"];
            }
            self.moodTypeLabel.text = @"Neutral";
            
            break;
        }
        case 13:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"sad"];
            }
            self.moodTypeLabel.text = @"Sad";
            
            break;
        }
        case 14:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"worried"];
            }
            self.moodTypeLabel.text = @"Worried";
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - Appearance

- (void)updateCell
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    if ([selectedDay.mood isEqualToString:@"angry"]) {
        [self.moodPickerView selectRow: 1 inComponent: 0 animated: NO];
        self.moodTypeLabel.text = @"Angry";
        
    } else if ([selectedDay.mood isEqualToString:@"anxious"]) {
        [self.moodPickerView selectRow: 2 inComponent: 0 animated: NO];
        self.moodTypeLabel.text = @"Anxious";
        
    } else if ([selectedDay.mood isEqualToString:@"calm"]) {
        [self.moodPickerView selectRow: 3 inComponent: 0 animated: NO];
        self.moodTypeLabel.text = @"Calm";
        
    } else if ([selectedDay.mood isEqualToString:@"depressed"]) {
        [self.moodPickerView selectRow: 4 inComponent: 0 animated: NO];
        self.moodTypeLabel.text = @"Depressed";
        
    } else if ([selectedDay.mood isEqualToString:@"moody"] || [selectedDay.mood isEqual:@"emotional"]) { // emotional
        [self.moodPickerView selectRow: 5 inComponent: 0 animated: NO];
        self.moodTypeLabel.text = @"Emotional";
        
    } else if ([selectedDay.mood isEqualToString:@"amazing"] || [selectedDay.mood isEqual:@"excited"]) { // excited
        [self.moodPickerView selectRow: 6 inComponent: 0 animated: NO];
        self.moodTypeLabel.text = @"Excited";
        
    } else if ([selectedDay.mood isEqualToString:@"frisky"]) {
        [self.moodPickerView selectRow: 7 inComponent: 0 animated: NO];
        self.moodTypeLabel.text = @"Frisky";
        
    } else if ([selectedDay.mood isEqualToString:@"frustrated"]) {
        [self.moodPickerView selectRow: 8 inComponent: 0 animated: NO];
        self.moodTypeLabel.text = @"Frustrated";
        
    } else if ([selectedDay.mood isEqualToString:@"good"] || [selectedDay.mood isEqual:@"happy"]) { // happy
        [self.moodPickerView selectRow: 9 inComponent: 0 animated: NO];
        self.moodTypeLabel.text = @"Happy";
        
    } else if ([selectedDay.mood isEqualToString:@"in love"]) {
        [self.moodPickerView selectRow: 10 inComponent: 0 animated: NO];
        self.moodTypeLabel.text = @"In Love";
        
    } else if ([selectedDay.mood isEqualToString:@"motivated"]) {
        [self.moodPickerView selectRow: 11 inComponent: 0 animated: NO];
        self.moodTypeLabel.text = @"Motivated";
        
    } else if ([selectedDay.mood isEqualToString:@"neutral"]) {
        [self.moodPickerView selectRow: 12 inComponent: 0 animated: NO];
        self.moodTypeLabel.text = @"Neutral";
        
    } else if ([selectedDay.mood isEqualToString:@"sad"]) {
        [self.moodPickerView selectRow: 13 inComponent: 0 animated: NO];
        self.moodTypeLabel.text = @"Sad";
        
    } else if ([selectedDay.mood isEqualToString:@"worried"]) {
        [self.moodPickerView selectRow: 14 inComponent: 0 animated: NO];
        self.moodTypeLabel.text = @"Worried";
        
    } else {
        [self.moodPickerView selectRow: 0 inComponent: 0 animated: NO];
        self.moodTypeLabel.text = @"";
        
    }
}

- (void)setMinimized
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    self.moodPickerView.hidden = YES;
    
    if (selectedDay.mood.length > 0) {
        // Minimized Cell, With Data
        self.moodPlaceholderLabel.hidden = YES;
        self.moodCollapsedLabel.hidden = NO;
        self.moodTypeLabel.hidden = NO;
    }else{
        // Minimized Cell, Without Data
        self.moodPlaceholderLabel.hidden = NO;
        self.moodCollapsedLabel.hidden = YES;
        self.moodTypeLabel.hidden = YES;
    }
    
}

- (void)setExpanded
{
    self.moodPickerView.hidden = NO;
    
    self.moodPlaceholderLabel.hidden = YES;
    self.moodCollapsedLabel.hidden = NO;
    self.moodTypeLabel.hidden = NO;
}


@end
