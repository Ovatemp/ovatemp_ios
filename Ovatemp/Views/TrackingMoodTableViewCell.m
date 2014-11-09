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

@implementation TrackingMoodTableViewCell

NSArray *moodDataSource;

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
    // TODO: Present UIAlertController
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

- (void)hitBackendWithMoodType:(NSString *)moodType {
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
    
    [self resetSelectedMood];
    [self.moodTableView reloadData];
    
    [self.moodTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    switch (indexPath.row) {
        case 0:
            self.angryMoodSelected = YES;
            [self hitBackendWithMoodType:@"angry"];
            break;
            
        case 1:
            self.anxiousMoodSelected = YES;
            [self hitBackendWithMoodType:@"anxious"];
            break;
            
        case 2:
            self.calmMoodSelected = YES;
            [self hitBackendWithMoodType:@"calm"];
            break;
            
        case 3:
            self.depressedMoodSelected = YES;
            [self hitBackendWithMoodType:@"depressed"];
            break;
            
        case 4:
            self.emotionalModdSelected = YES;
            [self hitBackendWithMoodType:@"emotional"];
            break;
            
        case 5:
            self.excitedMoodSelected = YES;
            [self hitBackendWithMoodType:@"excited"];
            break;
            
        case 6:
            self.friskyMoodSelected = YES;
            [self hitBackendWithMoodType:@"frisky"];
            break;
            
        case 7:
            self.frustratedMoodSelected = YES;
            [self hitBackendWithMoodType:@"frustrated"];
            break;
            
        case 8:
            self.happyMoodSelected = YES;
            [self hitBackendWithMoodType:@"happy"];
            break;
            
        case 9:
            self.inLoveMoodSelected = YES;
            [self hitBackendWithMoodType:@"inLove"];
            break;
            
        case 10:
            self.motivatedMoodSelected = YES;
            [self hitBackendWithMoodType:@"motivated"];
            break;
            
        case 11:
            self.neutralMoodSelected = YES;
            [self hitBackendWithMoodType:@"neutral"];
            break;
            
        case 12:
            self.sadMoodSelected = YES;
            [self hitBackendWithMoodType:@"sad"];
            break;
            
        case 13:
            self.worriedMoodSelected = YES;
            [self hitBackendWithMoodType:@"worried"];
            break;
            
        default:
            break;
    }
}




@end
