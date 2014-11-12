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

- (void)awakeFromNib {
    // Initialization code
    
    [self resetSelectedSymptoms];
    
    self.selectedDate = [[NSDate alloc] init];
    
    symptomsDataSource = [NSArray arrayWithObjects:@"Breast tenderness", @"Headaches", @"Nausea", @"Irritability/Mood swings", @"Bloating", @"PMS", @"Stress", @"Travel", @"Fever", nil];
    
    self.symptomsTableView.delegate = self;
    self.symptomsTableView.dataSource = self;
    
    self.selectedSymptoms = [[NSMutableArray alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetSelectedSymptoms {
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

- (IBAction)didSelectInfoButton:(id)sender {
    [self.delegate pushInfoAlertWithTitle:@"Symptoms" AndMessage:@"In addition to the main fertility signs, our bodies have several ways of letting us know what is going on. Hormones are a very powerful thing and they can sometimes trigger specific symptoms to each woman.\n\nTake note of these symptoms and learn your patterns for better understanding of your body." AndURL:@"http://ovatemp.helpshift.com/a/ovatemp/?s=fertility-faqs&f=learn-more-about-tracking-additional-symptoms"];
}

#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [symptomsDataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.textLabel.text = [symptomsDataSource objectAtIndex:indexPath.row];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //    symptomsDataSource = [NSArray arrayWithObjects:@"Breast tenderness", @"Headaches", @"Nausea", @"Irritability/Mood swings", @"Bloating", @"PMS", @"Stress", @"Travel", @"Fever", nil];
    
    // set accessory
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
    
    [cell setTintColor:[UIColor blackColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
//    
//    // check if selectedIndex is included in self.selectedSymptoms
//    // if it is, remove it, hit backend with contents of array
//    // if it is not, add it, hit backend
//    
//    if ([self.selectedSymptoms containsObject:selectedIndex]) {
//        [self.selectedSymptoms removeObject:selectedIndex];
//        [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
//    } else {
//        // add object
//        [self.selectedSymptoms addObject:selectedIndex];
//        [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
//    }
//    // Hit backend with changes
//    [self hitBackendWithSymptomIDs:self.selectedSymptoms];
    
    switch (indexPath.row) {
        case 0:
        {
            if (self.breastTendernessSelected) { // if cell is already selected
                // deselect
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
//                [self hitBackendWithSymptomIDs:[NSNull null]];
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms removeObject:selectedIndex];
                [self hitBackendWithSymptomIDs:self.selectedSymptoms];
                self.breastTendernessSelected = NO;
            } else {
                self.breastTendernessSelected = YES;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms addObject:selectedIndex];
                [self hitBackendWithSymptomIDs:self.selectedSymptoms];
            }
            break;
        }
            
        case 1:
        {
            if (self.headachesSelected) {
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
//                [self hitBackendWithSymptomIDs:[NSNull null]];
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms removeObject:selectedIndex];
                [self hitBackendWithSymptomIDs:self.selectedSymptoms];
                self.headachesSelected = NO;
            } else {
                self.headachesSelected = YES;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms addObject:selectedIndex];
                [self hitBackendWithSymptomIDs:self.selectedSymptoms];
            }
            break;
        }
            
        case 2:
        {
            if (self.nauseaSeleted) {
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms removeObject:selectedIndex];
                [self hitBackendWithSymptomIDs:self.selectedSymptoms];
                self.nauseaSeleted = NO;
            } else {
                self.nauseaSeleted = YES;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms addObject:selectedIndex];
                [self hitBackendWithSymptomIDs:self.selectedSymptoms];
            }
            break;
        }
            
        case 3:
        {
            if (self.irritabilityMoodSwingsSelected) {
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms removeObject:selectedIndex];
                [self hitBackendWithSymptomIDs:self.selectedSymptoms];
                self.irritabilityMoodSwingsSelected = NO;
            } else {
                self.irritabilityMoodSwingsSelected = YES;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms addObject:selectedIndex];
                [self hitBackendWithSymptomIDs:self.selectedSymptoms];
            }
            break;
        }
            
        case 4:
        {
            if (self.bloatingSelected) {
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms removeObject:selectedIndex];
                [self hitBackendWithSymptomIDs:self.selectedSymptoms];
                self.bloatingSelected = NO;
            } else {
                self.bloatingSelected = YES;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms addObject:selectedIndex];
                [self hitBackendWithSymptomIDs:self.selectedSymptoms];
            }
            break;
        }
            
        case 5:
        {
            if (self.pmsSelected) {
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms removeObject:selectedIndex];
                [self hitBackendWithSymptomIDs:self.selectedSymptoms];
                self.pmsSelected = NO;
            } else {
                self.pmsSelected = YES;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms addObject:selectedIndex];
                [self hitBackendWithSymptomIDs:self.selectedSymptoms];
            }
            break;
        }
            
        case 6:
        {
            if (self.stressSelected) {
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms removeObject:selectedIndex];
                [self hitBackendWithSymptomIDs:self.selectedSymptoms];
                self.stressSelected = NO;
            } else {
                self.stressSelected = YES;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms addObject:selectedIndex];
                [self hitBackendWithSymptomIDs:self.selectedSymptoms];
            }
            break;
        }
            
        case 7:
        {
            if (self.travelSelected) {
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms removeObject:selectedIndex];
                [self hitBackendWithSymptomIDs:self.selectedSymptoms];
                self.travelSelected = NO;
            } else {
                self.travelSelected = YES;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms addObject:selectedIndex];
                [self hitBackendWithSymptomIDs:self.selectedSymptoms];
            }
            break;
        }
            
        case 8:
        {
            if (self.feverSelected) {
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms removeObject:selectedIndex];
                [self hitBackendWithSymptomIDs:self.selectedSymptoms];
                self.feverSelected = NO;
            } else {
                self.feverSelected = YES;
                [self.symptomsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                NSNumber *selectedIndex = [[NSNumber alloc] initWithInteger:(indexPath.row + 1)]; // +1 to match backend list
                [self.selectedSymptoms addObject:selectedIndex];
                [self hitBackendWithSymptomIDs:self.selectedSymptoms];
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)hitBackendWithSymptomIDs:(id)symptom_ids {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setObject:symptom_ids forKey:@"symptom_ids"];
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

//- (int)indexPathToSymptomValueWithIndexPathWithValue:(int)value {
//    
//    // @"Breast tenderness", @"Headaches", @"Nausea", @"Irritability/Mood swings", @"Bloating", @"PMS", @"Stress", @"Travel", @"Fever"
//    
////    "Breast tenderness",
////    "Headaches",
////    "Nausea",
////    "Irritability/Mood swings",
////    "Bloating",
////    "PMS",
////    "Stress",
////    "Travel",
////    "Fever"
//    
//    switch (value) {
//        case 0:
//            return <#expression#>
//            break;
//            
//        default:
//            break;
//    }
//    
//}

@end
