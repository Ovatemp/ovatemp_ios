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

@interface TrackingMoodTableViewCell () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) NSArray *moodDataSource;
@property (nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation TrackingMoodTableViewCell

- (void)awakeFromNib
{
    [self setUpActivityView];
    
    self.moodDataSource = [[NSArray alloc] initWithObjects: @"Angry", @"Anxious", @"Calm", @"Depressed", @"Emotional", @"Excited",
                      @"Frisky", @"Frustrated", @"Happy", @"In Love", @"Motivated", @"Neutral", @"Sad", @"Worried", nil];
    
    self.moodTableView.delegate = self;
    self.moodTableView.dataSource = self;
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

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.moodDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    cell.textLabel.text = [self.moodDataSource objectAtIndex: indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    if (self.selectedIndexPath && self.selectedIndexPath.row == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndexPath && self.selectedIndexPath.row == indexPath.row) {
        
        if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
            [self.delegate didSelectMoodWithType: [NSNull null]];
        }
        self.moodTypeLabel.text = @"";
        self.selectedIndexPath = nil;
        
        [self.moodTableView reloadData];
        return;
    }
    
    self.selectedIndexPath = indexPath;
    
    switch (indexPath.row) {
        case 0:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"angry"];
            }
            self.moodTypeLabel.text = @"Angry";
            
            break;
        }
        case 1:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"anxious"];
            }
            self.moodTypeLabel.text = @"Anxious";
            
            break;
        }
        case 2:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"calm"];
            }
            self.moodTypeLabel.text = @"Calm";
            
            break;
        }
        case 3:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"depressed"];
            }
            self.moodTypeLabel.text = @"Depressed";
            
            break;
        }
        case 4:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"moody"];
            }
            self.moodTypeLabel.text = @"Emotional";
            
            break;
        }
        case 5:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"amazing"];
            }
            self.moodTypeLabel.text = @"Excited";
            
            break;
        }
        case 6:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"frisky"];
            }
            self.moodTypeLabel.text = @"Frisky";
            
            break;
        }
        case 7:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"frustrated"];
            }
            self.moodTypeLabel.text = @"Frustrated";
            
            break;
        }
        case 8:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"good"];
            }
            self.moodTypeLabel.text = @"Happy";
            
            break;
        }
        case 9:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"in love"];
            }
            self.moodTypeLabel.text = @"In Love";
            
            break;
        }
        case 10:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"motivated"];
            }
            self.moodTypeLabel.text = @"Motivated";
            
            break;
        }
        case 11:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"neutral"];
            }
            self.moodTypeLabel.text = @"Neutral";
            
            break;
        }
        case 12:
        {
            if([self.delegate respondsToSelector: @selector(didSelectMoodWithType:)]){
                [self.delegate didSelectMoodWithType: @"sad"];
            }
            self.moodTypeLabel.text = @"Sad";
            
            break;
        }
        case 13:
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
    
    [self.moodTableView reloadData];
}

#pragma mark - Appearance

- (void)updateCell
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    if ([selectedDay.mood isEqualToString:@"angry"]) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
        self.moodTypeLabel.text = @"Angry";
        
    } else if ([selectedDay.mood isEqualToString:@"anxious"]) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow: 1 inSection: 0];
        self.moodTypeLabel.text = @"Anxious";
        
    } else if ([selectedDay.mood isEqualToString:@"calm"]) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow: 2 inSection: 0];
        self.moodTypeLabel.text = @"Calm";
        
    } else if ([selectedDay.mood isEqualToString:@"depressed"]) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow: 3 inSection: 0];
        self.moodTypeLabel.text = @"Depressed";
        
    } else if ([selectedDay.mood isEqualToString:@"moody"] || [selectedDay.mood isEqual:@"emotional"]) { // emotional
        self.selectedIndexPath = [NSIndexPath indexPathForRow: 4 inSection: 0];
        self.moodTypeLabel.text = @"Emotional";
        
    } else if ([selectedDay.mood isEqualToString:@"amazing"] || [selectedDay.mood isEqual:@"excited"]) { // excited
        self.selectedIndexPath = [NSIndexPath indexPathForRow: 5 inSection: 0];
        self.moodTypeLabel.text = @"Excited";
        
    } else if ([selectedDay.mood isEqualToString:@"frisky"]) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow: 6 inSection: 0];
        self.moodTypeLabel.text = @"Frisky";
        
    } else if ([selectedDay.mood isEqualToString:@"frustrated"]) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow: 7 inSection: 0];
        self.moodTypeLabel.text = @"Frustrated";
        
    } else if ([selectedDay.mood isEqualToString:@"good"] || [selectedDay.mood isEqual:@"happy"]) { // happy
        self.selectedIndexPath = [NSIndexPath indexPathForRow: 8 inSection: 0];
        self.moodTypeLabel.text = @"Happy";
        
    } else if ([selectedDay.mood isEqualToString:@"in love"]) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow: 9 inSection: 0];
        self.moodTypeLabel.text = @"In Love";
        
    } else if ([selectedDay.mood isEqualToString:@"motivated"]) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow: 10 inSection: 0];
        self.moodTypeLabel.text = @"Motivated";
        
    } else if ([selectedDay.mood isEqualToString:@"neutral"]) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow: 11 inSection: 0];
        self.moodTypeLabel.text = @"Neutral";
        
    } else if ([selectedDay.mood isEqualToString:@"sad"]) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow: 12 inSection: 0];
        self.moodTypeLabel.text = @"Sad";
        
    } else if ([selectedDay.mood isEqualToString:@"worried"]) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow: 13 inSection: 0];
        self.moodTypeLabel.text = @"Worried";
        
    }else{
        self.moodTypeLabel.text = @"";
    }
    
    [self.moodTableView reloadData];
}

- (void)setMinimized
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    self.moodTableView.hidden = YES;
    
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
    self.moodTableView.hidden = NO;
    
    self.moodPlaceholderLabel.hidden = YES;
    self.moodCollapsedLabel.hidden = NO;
    self.moodTypeLabel.hidden = NO;
}


@end
