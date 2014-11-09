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

@implementation TrackingMoodTableViewCell

NSArray *moodDataSource;

NSIndexPath *selectedIndexPath;

- (void)awakeFromNib {
    // Initialization code
    
    [self resetSelectedMood];
    
    self.selectedDate = [[NSDate alloc] init];
    
    moodDataSource = [[NSArray alloc] initWithObjects:@"Angry", @"Anxious", @"Calm", @"Depressed", @"Emotional", @"Excited", @"Frisky", @"Frustrated", @"Happy", @"In Love", @"Motivated", @"Neutral", @"Sad", @"Worried", nil];
    
    self.moodTableView.delegate = self;
    self.moodTableView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didSelectInfoButton:(id)sender {
    [self.delegate pushInfoAlertWithTitle:@"Mood" AndMessage:@"Taking note of your mood throughout your cycle can help you identify patterns and understand both your cycles and your mood swings better.\n\nDid you know you feel your best when ovulating?" AndURL:@"http://google.com"];
}

- (void)resetSelectedMood {
    // reset selection
    self.angryMoodSelected = NO;
    self.anxiousMoodSelected = NO;
    self.calmMoodSelected = NO;
    self.depressedMoodSelected = NO;
    self.emotionalModdSelected = NO;
    self.excitedMoodSelected = NO;
    self.friskyMoodSelected = NO;
    self.frustratedMoodSelected = NO;
    self.happyMoodSelected = NO;
    self.inLoveMoodSelected = NO;
    self.motivatedMoodSelected = NO;
    self.neutralMoodSelected = NO;
    self.sadMoodSelected = NO;
    self.worriedMoodSelected = NO;
}

- (void)hitBackendWithMoodType:(id)moodType {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setObject:moodType forKey:@"mood"];
    [attributes setObject:self.selectedDate forKey:@"date"];
    
    [ConnectionManager put:@"/days/"
                    params:@{
                             @"day": attributes,
                             }
                   success:^(NSDictionary *response) {
                       [Cycle cycleFromResponse:response];
                       [Calendar setDate:self.selectedDate];
                       //                       if (onSuccess) onSuccess(response);
                   }
                   failure:^(NSError *error) {
                       [Alert presentError:error];
                   }];
    
}

- (void)selectMoodAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            self.angryMoodSelected = YES;
            break;
        }
            
        case 1:
        {
            self.anxiousMoodSelected = YES;
            break;
        }
            
        case 2:
        {
            self.calmMoodSelected = YES;
            break;
        }
            
        case 3:
        {
            self.depressedMoodSelected = YES;
            break;
        }
            
        case 4:
        {
            self.emotionalModdSelected = YES;
            break;
        }
            
        case 5:
        {
            self.excitedMoodSelected = YES;
            break;
        }
            
        case 6:
        {
            self.friskyMoodSelected = YES;
            break;
        }
            
        case 7:
        {
            self.frustratedMoodSelected = YES;
            break;
        }
            
        case 8:
        {
            self.happyMoodSelected = YES;
            break;
        }
            
        case 9:
        {
            self.inLoveMoodSelected = YES;
            break;
        }
            
        case 10:
        {
            self.motivatedMoodSelected = YES;
            break;
        }
            
        case 11:
        {
            self.neutralMoodSelected = YES;
            break;
        }
            
        case 12:
        {
            self.sadMoodSelected = YES;
            break;
        }
            
        case 13:
        {
            self.worriedMoodSelected = YES;
            break;
        }
        
        default:
            break;
    }
}

#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [moodDataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.textLabel.text = [moodDataSource objectAtIndex:indexPath.row];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell setTintColor:[UIColor blackColor]];
    
    // set accessory
    switch (indexPath.row) {
        case 0:
        {
            if (self.angryMoodSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        case 1:
        {
            if (self.anxiousMoodSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        case 2:
        {
            if (self.calmMoodSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        case 3:
        {
            if (self.depressedMoodSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
        
        case 4:
        {
            if (self.emotionalModdSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        case 5:
        {
            if (self.excitedMoodSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        case 6:
        {
            if (self.friskyMoodSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        case 7:
        {
            if (self.frustratedMoodSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        case 8:
        {
            if (self.happyMoodSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        case 9:
        {
            if (self.inLoveMoodSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        case 10:
        {
            if (self.motivatedMoodSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        case 11:
        {
            if (self.neutralMoodSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        case 12:
        {
            if (self.sadMoodSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        case 13:
        {
            if (self.worriedMoodSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [self resetSelectedMood]; // clear all
//    [self.moodTableView reloadData];
    
    [self.moodTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
//    if (selectedIndexPath) { // we already have a saved path
//        if (selectedIndexPath == indexPath) {
//            // deselect
//            [self selectMoodAtIndexPath:indexPath]; // select what we need to remove
//        }
//    } else { // first time selecting anything
//        [self resetSelectedMood]; // clear all
//    }
    
    switch (indexPath.row) {
        case 0:
        {
            if (self.angryMoodSelected) { // if cell is already selected
                // deselect
                [self.moodTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [self hitBackendWithMoodType:@"<null>"];
                self.angryMoodSelected = NO;
                
            } else { // select cell
                self.angryMoodSelected = YES;
                [self hitBackendWithMoodType:@"angry"];
            }
            break;
        }
        case 1:
        {
            if (self.anxiousMoodSelected) {
                [self.moodTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [self hitBackendWithMoodType:@"<null>"];
                self.anxiousMoodSelected = NO;
            } else {
                self.anxiousMoodSelected = YES;
                [self hitBackendWithMoodType:@"anxious"];
            }
            break;
        }
        case 2:
        {
            if (self.calmMoodSelected) {
                [self.moodTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [self hitBackendWithMoodType:@"<null>"];
                self.calmMoodSelected = NO;
            } else {
                self.calmMoodSelected = YES;
                [self hitBackendWithMoodType:@"calm"];
            }
            break;
        }
        case 3:
        {
            if (self.depressedMoodSelected) {
                [self.moodTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [self hitBackendWithMoodType:@"<null>"];
                self.depressedMoodSelected = NO;
            } else {
                self.depressedMoodSelected = YES;
                [self hitBackendWithMoodType:@"depressed"];
            }
            break;
        }
        case 4:
        {
            if (self.emotionalModdSelected) {
                [self.moodTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [self hitBackendWithMoodType:@"<null>"];
                self.emotionalModdSelected = NO;
            } else {
                self.emotionalModdSelected = YES;
                [self hitBackendWithMoodType:@"emotional"];
            }
            break;
        }
        case 5:
        {
            if (self.excitedMoodSelected) {
                [self.moodTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [self hitBackendWithMoodType:@"<null>"];
                self.excitedMoodSelected = NO;
            } else {
                self.excitedMoodSelected = YES;
                [self hitBackendWithMoodType:@"excited"];
            }
            break;
        }
        case 6:
        {
            if (self.friskyMoodSelected) {
                [self.moodTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [self hitBackendWithMoodType:@"<null>"];
                self.friskyMoodSelected = NO;
            } else {
                self.friskyMoodSelected = YES;
                [self hitBackendWithMoodType:@"frisky"];
            }
            break;
        }
        case 7:
        {
            if (self.frustratedMoodSelected) {
                [self.moodTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [self hitBackendWithMoodType:@"<null>"];
                self.friskyMoodSelected = NO;
            } else {
                self.frustratedMoodSelected = YES;
                [self hitBackendWithMoodType:@"frustrated"];
            }
            break;
        }
        case 8:
        {
            if (self.happyMoodSelected) {
                [self.moodTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [self hitBackendWithMoodType:@"<null>"];
                self.happyMoodSelected = NO;
            } else {
                self.happyMoodSelected = YES;
                [self hitBackendWithMoodType:@"happy"];
            }
            break;
    }
        case 9:
        {
            if (self.inLoveMoodSelected) {
                [self.moodTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [self hitBackendWithMoodType:@"<null>"];
                self.inLoveMoodSelected = NO;
            } else {
                self.inLoveMoodSelected = YES;
                [self hitBackendWithMoodType:@"inLove"];
            }
            break;
        }
        case 10:
        {
            if (self.motivatedMoodSelected) {
                [self.moodTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [self hitBackendWithMoodType:@"<null>"];
                self.motivatedMoodSelected = NO;
            } else {
                self.motivatedMoodSelected = YES;
                [self hitBackendWithMoodType:@"motivated"];
            }
            break;
        }
        case 11:
        {
            if (self.neutralMoodSelected) {
                [self.moodTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [self hitBackendWithMoodType:@"<null>"];
                self.neutralMoodSelected = NO;
            } else {
                self.neutralMoodSelected = YES;
                [self hitBackendWithMoodType:@"neutral"];
            }
            break;
        }
        case 12:
        {
            if (self.sadMoodSelected) {
                [self.moodTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [self hitBackendWithMoodType:@"<null>"];
                self.sadMoodSelected = NO;
            } else {
                self.sadMoodSelected = YES;
                [self hitBackendWithMoodType:@"sad"];
            }
            break;
        }
        case 13:
        {
            if (self.worriedMoodSelected) {
                [self.moodTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [self hitBackendWithMoodType:@"<null>"];
                self.worriedMoodSelected = NO;
            } else {
                self.worriedMoodSelected = YES;
                [self hitBackendWithMoodType:@"worried"];
            }
            break;
        }
        default:
            break;
    }
    
    selectedIndexPath = indexPath;
}




@end
