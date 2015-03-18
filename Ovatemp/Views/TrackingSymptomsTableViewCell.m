//
//  TrackingSymptomsTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/7/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingSymptomsTableViewCell.h"

#import "TrackingViewController.h"

#import "Calendar.h"
#import "Alert.h"

@implementation TrackingSymptomsTableViewCell

NSArray *symptomsDataSource;

- (void)awakeFromNib
{
    [self resetSelectedSymptoms];
    [self setUpActivityView];
    
    symptomsDataSource = [NSArray arrayWithObjects:@"Breast tenderness", @"Headaches", @"Nausea", @"Irritability/Mood swings", @"Bloating", @"PMS", @"Stress", @"Travel", @"Fever", nil];
    
    self.symptomsTableView.delegate = self;
    self.symptomsTableView.dataSource = self;
    
    self.selectedSymptoms = [[NSMutableArray alloc] init];
}

- (void)setUpActivityView
{
    self.activityView.hidden = YES;
    self.activityView.hidesWhenStopped = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(startActivity)
                                                 name: @"symptoms_start_activity"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(stopActivity)
                                                 name: @"symptoms_stop_activity"
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

- (void)resetSelectedSymptoms
{
    self.breastTendernessSelected = NO;
    self.headachesSelected = NO;
    self.nauseaSeleted = NO;
    self.irritabilityMoodSwingsSelected = NO;
    self.bloatingSelected = NO;
    self.pmsSelected = NO;
    self.stressSelected = NO;
    self.travelSelected = NO;
    self.feverSelected = NO;
}

- (IBAction)didSelectInfoButton:(id)sender
{
    [self.delegate pushInfoAlertWithTitle:@"Symptoms" AndMessage:@"In addition to the main fertility signs, our bodies have several ways of letting us know what is going on. Hormones are a very powerful thing and they can sometimes trigger specific symptoms to each woman.\n\nTake note of these symptoms and learn your patterns for better understanding of your body." AndURL:@"http://ovatemp.helpshift.com/a/ovatemp/?s=fertility-faqs&f=learn-more-about-tracking-additional-symptoms"];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [symptomsDataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.textLabel.text = [symptomsDataSource objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    switch (indexPath.row) {
        case 0:
        {
            if (self.breastTendernessSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
        
        case 1:
        {
            if (self.headachesSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
        
        case 2:
        {
            if (self.nauseaSeleted) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        case 3:
        {
            if (self.irritabilityMoodSwingsSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        case 4:
        {
            if (self.bloatingSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        case 5:
        {
            if (self.pmsSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        case 6:
        {
            if (self.stressSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        case 7:
        {
            if (self.travelSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        case 8:
        {
            if (self.feverSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
            
        default:
            break;
    }
    
    [cell setTintColor: [UIColor ovatempAquaColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            if (self.breastTendernessSelected) {
                self.breastTendernessSelected = NO;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms removeObject: selectedIndex];
                
            } else {
                self.breastTendernessSelected = YES;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms addObject: selectedIndex];
            }
            break;
        }
            
        case 1:
        {
            if (self.headachesSelected) {
                self.headachesSelected = NO;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;

                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms removeObject: selectedIndex];
                
            } else {
                self.headachesSelected = YES;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms addObject: selectedIndex];
            }
            break;
        }
            
        case 2:
        {
            if (self.nauseaSeleted) {
                self.nauseaSeleted = NO;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms removeObject: selectedIndex];
                
            } else {
                self.nauseaSeleted = YES;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms addObject: selectedIndex];
            }
            break;
        }
            
        case 3:
        {
            if (self.irritabilityMoodSwingsSelected) {
                self.irritabilityMoodSwingsSelected = NO;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms removeObject: selectedIndex];
                
            } else {
                self.irritabilityMoodSwingsSelected = YES;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms addObject: selectedIndex];
            }
            break;
        }
            
        case 4:
        {
            if (self.bloatingSelected) {
                self.bloatingSelected = NO;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms removeObject: selectedIndex];
                
            } else {
                self.bloatingSelected = YES;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms addObject: selectedIndex];
            }
            break;
        }
            
        case 5:
        {
            if (self.pmsSelected) {
                self.pmsSelected = NO;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms removeObject: selectedIndex];
                
            } else {
                self.pmsSelected = YES;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms addObject: selectedIndex];
            }
            break;
        }
            
        case 6:
        {
            if (self.stressSelected) {
                self.stressSelected = NO;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms removeObject: selectedIndex];
                
            } else {
                self.stressSelected = YES;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms addObject: selectedIndex];
            }
            break;
        }
            
        case 7:
        {
            if (self.travelSelected) {
                self.travelSelected = NO;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms removeObject: selectedIndex];
                
            } else {
                self.travelSelected = YES;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms addObject: selectedIndex];
            }
            break;
        }
            
        case 8:
        {
            if (self.feverSelected) {
                self.feverSelected = NO;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms removeObject: selectedIndex];
                
            } else {
                self.feverSelected = YES;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms addObject: selectedIndex];
            }
            break;
        }
            
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector: @selector(didSelectSymptomsWithTypes:)]) {
        [self.delegate didSelectSymptomsWithTypes: self.selectedSymptoms];
    }
}

- (void)setSymptomWithValue:(NSInteger)value
{
    value--;
    
    if (value == 0) {
        self.breastTendernessSelected = YES;
    } else if (value == 1) {
        self.headachesSelected = YES;
    } else if (value == 2) {
        self.nauseaSeleted = YES;
    } else if (value == 3) {
        self.irritabilityMoodSwingsSelected = YES;
    } else if (value == 4) {
        self.bloatingSelected = YES;
    } else if (value == 5) {
        self.pmsSelected = YES;
    } else if (value == 6) {
        self.stressSelected = YES;
    } else if (value == 7) {
        self.travelSelected = YES;
    } else { // fever
        self.feverSelected = YES;
    }
}

#pragma mark - Appearance

- (void)updateCell
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    if (selectedDay.symptomIds) {
        
        for (NSString *symptomID in selectedDay.symptomIds) {
            NSInteger symptomIntVal = [symptomID integerValue];
            
            [self setSymptomWithValue: symptomIntVal];
        }
        
        [self.symptomsTableView reloadData];
    } else {
        // TODO: No data
    }
}

- (void)setMinimized
{
    self.symptomsTableView.hidden = YES;
}

- (void)setExpanded
{
    self.symptomsTableView.hidden = NO;
    self.symptomsCollapsedLabel.hidden = NO;
    self.placeholderLabel.hidden = YES;
    
    [self.symptomsTableView flashScrollIndicators];
}

@end
