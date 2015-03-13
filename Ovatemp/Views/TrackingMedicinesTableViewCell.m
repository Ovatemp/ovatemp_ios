//
//  TrackingMedicinesTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/17/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingMedicinesTableViewCell.h"
#import "SimpleSupplement.h"
#import "Alert.h"

@implementation TrackingMedicinesTableViewCell

- (void)awakeFromNib
{
//    self.selectedDate = [[NSDate alloc] init];
    
    self.medicinesTableViewDataSource = [[NSMutableArray alloc] init];
    
    self.selectedMedicineIDs = [[NSMutableArray alloc] init];
    self.allMedicineIDs = [[NSMutableArray alloc] init];
    
    self.medicinesTableView.delegate = self;
    self.medicinesTableView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)doAddMedicine:(id)sender
{
    // set up alert
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@""
                                message:@"Add New Medicine"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   UITextField *alertField = [[alert textFields] firstObject];
                                                   NSString *medicine = alertField.text;
                                                   if ([medicine length] == 0) {
                                                       return;
                                                   }
                                                   [self postNewMedicineToBackendWithMedicine:medicine];
                                               }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:nil];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    // TO DO
//    [self.delegate presentViewControllerWithViewController:alert];
    
}
- (IBAction)doShowInfo:(id)sender
{
    [self.delegate pushInfoAlertWithTitle:@"Medicines" AndMessage:@"Keeping track of medication and any kind of supplements you take can help you detect improvement or changes in your cycles and talk to your doctor about it.\nAlways consult your physician before taking any medication." AndURL:@"http://ovatemp.helpshift.com/a/ovatemp/?s=fertility-faqs&f=learn-more-about-medicines"];
}

- (void)postNewMedicineToBackendWithMedicine:(NSString *)medicine
{
    NSString *className = @"medicine"; // supplement
    NSString *classNamePlural = [className stringByAppendingString:@"s"]; // supplements
    
    [ConnectionManager post:[@"/" stringByAppendingString:classNamePlural]
                     params:@{
                              className: // supplement
                              @{
                                  @"name":medicine // new supplement
                                  }
                              }
                    success:^(NSDictionary *response) {
                        
                        SimpleSupplement *newMed = [[SimpleSupplement alloc] init];
                        newMed.belongsToAllUsers = [[[response objectForKey:@"medicine"] objectForKey:@"belongs_to_all_users"] boolValue];
                        newMed.createdAt = [[response objectForKey:@"medicine"] objectForKey:@"created_at"];
                        newMed.idNumber = [NSNumber numberWithInt:[[[response objectForKey:@"medicine"] objectForKey:@"id"] intValue]];
                        newMed.name = [[response objectForKey:@"medicine"] objectForKey:@"name"];
                        newMed.updatedAt = [[response objectForKey:@"medicine"] objectForKey:@"updated_at"];
                        newMed.userID = [[response objectForKey:@"medicine"] objectForKey:@"user_id"];
                        
                        // todo, check for duplicates so supplement doesn't appear twice
                        // de-select supplement if we want to uncheck it
                        
                        if (self.selectedMedicineIDs == nil) {
                            self.selectedMedicineIDs = [[NSMutableArray alloc] init];
                        }
                        if ([self.medicinesTableViewDataSource containsObject:newMed]) {
                            //
                        } else {
                            [self.medicinesTableViewDataSource addObject:newMed];
                        }
                        
                        //                        [self.allSupplementIDs addObject:newSupp.idNumber];
                        [self.selectedMedicineIDs addObject:newMed.idNumber];
                        
                        [self hitBackendWithMedicineType:self.selectedMedicineIDs];
                    }
                    failure:^(NSError *error) {
                        [Alert presentError:error];
                    }
     ];
}

- (void)hitBackendWithMedicineType:(id)medicineIds
{
    NSDate *selectedDate = [self.delegate getSelectedDate];
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setObject: medicineIds forKey: @"medicine_ids"];
    [attributes setObject: selectedDate forKey: @"date"];
    
    [ConnectionManager put:@"/days/"
                    params:@{
                             @"day": attributes,
                             }
                   success:^(NSDictionary *response) {
                       //                       [Cycle cycleFromResponse:response];
                       //                       [Calendar setDate:self.selectedDate];
                       //                       if (onSuccess) onSuccess(response);
                       // TODO: reload table?
                       // reload supplements
                       [self reloadMedicines];
                       [self.medicinesTableView reloadData];
                   }
                   failure:^(NSError *error) {
                       [Alert presentError:error];
                   }];
}

- (void)reloadMedicines
{
    //    [Supplement resetInstancesWithArray:response[@"supplements"]];
    [ConnectionManager put:@"/sessions/refresh"
                    params:nil
                   success:^(NSDictionary *response) {
                       //                       [self stopLoading];
                       [Configuration loggedInWithResponse:response];
                       [self.medicinesTableView reloadData];
                       //                       [self launchAppropriateViewController];
                   }
                   failure:^(NSError *error) {
                       //                       [self stopLoading];
                       //                       [self logOutWithUnauthorized];
                       NSLog(@"Error: %@", [error localizedDescription]);
                   }
     ];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.medicinesTableViewDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    SimpleSupplement *cellSupp = [[SimpleSupplement alloc] init];
    cellSupp = [self.medicinesTableViewDataSource objectAtIndex:indexPath.row];
    
    cell.textLabel.text = cellSupp.name;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell setTintColor:[UIColor blackColor]];
    
    // if [supplementsTableViewDataSource objectAtIndex:indexPath.row] is contained in selectedIDs, mark it as checked, otherwise no check mark
    SimpleSupplement *tempSupp = [self.medicinesTableViewDataSource objectAtIndex:indexPath.row];
    if ([self.selectedMedicineIDs containsObject:tempSupp.idNumber]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.medicinesTableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
        [self.medicinesTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        // get id of object at selected index
        // remove it from selected ids array
        // hit backend
        SimpleSupplement *selectedMed = [[SimpleSupplement alloc] init];
        selectedMed = [self.medicinesTableViewDataSource objectAtIndex:indexPath.row];
        [self.selectedMedicineIDs removeObject:selectedMed.idNumber];
        [self hitBackendWithMedicineType:self.selectedMedicineIDs];
    } else {
        [self.medicinesTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        SimpleSupplement *selectedMed = [[SimpleSupplement alloc] init];
        selectedMed = [self.medicinesTableViewDataSource objectAtIndex:indexPath.row];
        [self.selectedMedicineIDs addObject:selectedMed.idNumber];
        [self hitBackendWithMedicineType:self.selectedMedicineIDs];
    }
}

#pragma mark - Appearance

- (void)updateCell
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    NSMutableArray *medicines = [[NSMutableArray alloc] init];
    NSMutableArray *medicineIDs = [[NSMutableArray alloc] initWithArray: selectedDay.medicineIds];
    
    if ([selectedDay.medicines count] > 0) {
        
        NSArray *medArray = [[Medicine instances] allValues];
        for (Medicine *med in medArray) {
            
            SimpleSupplement *simpleMed = [[SimpleSupplement alloc] init];
            simpleMed.name = med.name;
            simpleMed.idNumber = med.id;
            
            if (![medicineIDs containsObject: simpleMed]) {
                [medicines addObject: simpleMed];
            }
        }
        
        self.medicinesTableViewDataSource = medicines;
        self.selectedMedicineIDs = medicineIDs;
        
    } else {

        [self.medicinesTableViewDataSource removeAllObjects];
        [self.selectedMedicineIDs removeAllObjects];
        
        // add medicines to array, just don't mark them as selected
        NSArray *medArray = [[Medicine instances] allValues];
        for (Supplement *med in medArray) {
            
            SimpleSupplement *simpleMed = [[SimpleSupplement alloc] init];
            simpleMed.name = med.name;
            simpleMed.idNumber = med.id;
            
            if (![medicineIDs containsObject:simpleMed]) {
                [medicines addObject:simpleMed];
            }
        }
        
        self.medicinesTableViewDataSource = [[NSMutableArray alloc] initWithArray: medicines];
        self.selectedMedicineIDs = [[NSMutableArray alloc] initWithArray: medicineIDs];
        
        [self.medicinesTableView reloadData];
    }
}

- (void)setMinimized
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    self.medicinesTableView.hidden = YES;
    self.infoButton.hidden = NO;
    self.addMedicinesButton.hidden = YES;
    
    if ([selectedDay.medicines count] > 0) {
        
        if ([selectedDay.medicineIds count] == 0) {
            // no selected supplements
            self.medicinesCollapsedLabel.hidden = YES;
            self.medicinesTypeCollapsedLabel.hidden = YES;
            self.placeholderLabel.hidden = NO;
        } else {
            self.medicinesCollapsedLabel.hidden = NO;
            self.medicinesTypeCollapsedLabel.hidden = NO;
            self.placeholderLabel.hidden = YES;
        }
        
    } else {
        self.medicinesCollapsedLabel.hidden = YES;
        self.medicinesTypeCollapsedLabel.hidden = YES;
        self.placeholderLabel.hidden = NO;
    }
}

- (void)setExpanded
{
    self.medicinesTableView.hidden = NO;
    self.infoButton.hidden = YES;
    self.addMedicinesButton.hidden = NO;
    
    self.medicinesCollapsedLabel.hidden = NO;
    self.medicinesTypeCollapsedLabel.hidden = YES;
    self.placeholderLabel.hidden = YES;
}

@end
