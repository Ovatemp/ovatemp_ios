//
//  TrackingSupplementsTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/16/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingSupplementsTableViewCell.h"

#import "Alert.h"
#import "SharedRelation.h"
#import "SimpleSupplement.h"
#import "Cycle.h"
#import "Calendar.h"

@implementation TrackingSupplementsTableViewCell

- (void)awakeFromNib
{
    [self setUpActivityView];
    
    self.supplementsTableViewDataSource = [[NSMutableArray alloc] init];
    
    self.selectedSupplementIDs = [[NSMutableArray alloc] init];
    self.allSupplementIDs = [[NSMutableArray alloc] init];
    
    self.supplementsTableView.delegate = self;
    self.supplementsTableView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - UIActivityIndicatorView

- (void)setUpActivityView
{
    self.activityView.hidden = YES;
    self.activityView.hidesWhenStopped = YES;
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

#pragma mark - IBAction's

- (IBAction)didSelectInfoButton:(id)sender
{
    [self.delegate pushInfoAlertWithTitle:@"Supplements" AndMessage:@"Keeping track of medication and any kind of supplements you take can help you detect improvement or changes in your cycles and talk to your doctor about it.\nAlways consult your physician before taking any medication." AndURL:@"http://ovatemp.helpshift.com/a/ovatemp/?s=fertility-faqs&f=learn-more-about-supplements"];
}

- (IBAction)didSelectAddSupplementButton:(id)sender
{
    UIAlertController *alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Add New Supplement"
                                     preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   UITextField *alertField = [[alert textFields] firstObject];
                                                   NSString *supplement = alertField.text;
                                                   if ([supplement length] == 0) {
                                                       return;
                                                   }
                                                   [self postNewSupplementToBackendWithSupplement: supplement];
                                               }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                               handler:nil];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self.delegate presentViewControllerWithViewController: alert];
}

#pragma mark - Network

- (void)postNewSupplementToBackendWithSupplement:(NSString *)supplement
{
    [self startActivity];
    
    [ConnectionManager post: @"/supplements"
                     params: @{@"supplement" : @{@"name" : supplement}}
                    success: ^(NSDictionary *response) {
                        
                        [self reloadSupplements];
                        
                    }
                    failure:^(NSError *error) {
                        [Alert presentError:error];
                        [self stopActivity];
                    }
     ];
}

- (void)reloadSupplements
{
    [ConnectionManager put:@"/sessions/refresh"
                    params:nil
                   success:^(NSDictionary *response) {
                       
                       [Configuration loggedInWithResponse:response];
                       [self.delegate reloadTrackingView];
                       [self stopActivity];
                       
                   }
                   failure:^(NSError *error) {
                       [Alert presentError:error];
                       [self stopActivity];
                   }
     ];
}

- (void)hitBackendWithSupplementType:(id)supplementIds
{
    NSDate *selectedDate = [self.delegate getSelectedDate];
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setObject: supplementIds forKey: @"supplement_ids"];
    [attributes setObject: selectedDate forKey: @"date"];
    
    [self startActivity];
    
    [ConnectionManager put:@"/days/"
                    params:@{@"day": attributes,}
                   success:^(NSDictionary *response) {
                      
                       [Cycle cycleFromResponse: response];
                       [Calendar setDate: selectedDate];
                       
                       [self updateCell];
                       [self stopActivity];
                   }
                   failure:^(NSError *error) {
                       [Alert presentError:error];
                       [self stopActivity];
                   }];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.supplementsTableViewDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    SimpleSupplement *cellSupp = [[SimpleSupplement alloc] init];
    cellSupp = [self.supplementsTableViewDataSource objectAtIndex: indexPath.row];
    
    cell.textLabel.text = cellSupp.name;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setTintColor: [UIColor ovatempAquaColor]];
    
    if ([self.selectedSupplementIDs containsObject: cellSupp.idNumber]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.supplementsTableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
        [self.supplementsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;

        SimpleSupplement *selectedSupp = [[SimpleSupplement alloc] init];
        selectedSupp = [self.supplementsTableViewDataSource objectAtIndex: indexPath.row];
        [self.selectedSupplementIDs removeObject: selectedSupp.idNumber];
        
    } else {
        [self.supplementsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        
        SimpleSupplement *selectedSupp = [[SimpleSupplement alloc] init];
        selectedSupp = [self.supplementsTableViewDataSource objectAtIndex: indexPath.row];
        [self.selectedSupplementIDs addObject: selectedSupp.idNumber];
        
    }
    
    [self hitBackendWithSupplementType: self.selectedSupplementIDs];
}

#pragma mark - Appearance

- (void)updateCell
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    NSMutableArray *supplements = [[NSMutableArray alloc] init];
    NSMutableArray *supplementIDs = [[NSMutableArray alloc] initWithArray: selectedDay.supplementIds];
    NSMutableString *supplementsString = [[NSMutableString alloc] init];
    
    if ([selectedDay.supplements count] > 0) {
        
        NSArray *suppArray = [[Supplement instances] allValues];
        
        for (Supplement *supp in suppArray) {
            SimpleSupplement *simpleSupp = [[SimpleSupplement alloc] init];
            simpleSupp.name = supp.name;
            simpleSupp.idNumber = supp.id;
            
            [supplements addObject: simpleSupp];
            
            if ([supplementIDs containsObject: simpleSupp.idNumber]) {
                [supplementsString appendFormat: @"%@, ", simpleSupp.name];
            }
        }
        
        if (supplementsString.length > 2) {
            [supplementsString replaceCharactersInRange: NSMakeRange(supplementsString.length - 2, 2) withString: @""];
        }
        
        self.supplementsTypeCollapsedLabel.text = supplementsString;
        
    } else {

        [self.supplementsTableViewDataSource removeAllObjects];
        [self.selectedSupplementIDs removeAllObjects];
        
        NSArray *suppArray = [[Supplement instances] allValues];
        for (Supplement *supp in suppArray) {
            SimpleSupplement *simpleSupp = [[SimpleSupplement alloc] init];
            simpleSupp.name = supp.name;
            simpleSupp.idNumber = supp.id;
            
            [supplements addObject: simpleSupp];
        }
        
    }
    
    self.supplementsTableViewDataSource = [[NSMutableArray alloc] initWithArray: supplements];
    self.selectedSupplementIDs = [[NSMutableArray alloc] initWithArray: supplementIDs];
    
    [self.supplementsTableView reloadData];
}

- (void)setMinimized
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    self.supplementsTableView.hidden = YES;
    
    self.infoButton.hidden = NO;
    self.addSupplementButton.hidden = YES;
    
    if ([selectedDay.supplements count] > 0) {
        
        if ([selectedDay.supplementIds count] == 0) {
            // Minimized, Without Data
            self.supplementsCollapsedLabel.hidden = YES;
            self.supplementsTypeCollapsedLabel.hidden = YES;
            self.placeholderLabel.hidden = NO;
        } else {
            // Minimized, With Data
            self.supplementsCollapsedLabel.hidden = NO;
            self.supplementsTypeCollapsedLabel.hidden = NO;
            self.placeholderLabel.hidden = YES;
        }
        
    } else {
        self.supplementsCollapsedLabel.hidden = YES;
        self.supplementsTypeCollapsedLabel.hidden = YES;
        self.placeholderLabel.hidden = NO;
    }
}

- (void)setExpanded
{
    [self.supplementsTableView flashScrollIndicators];
    
    self.infoButton.hidden = YES;
    self.addSupplementButton.hidden = NO;
    
    self.supplementsTableView.hidden = NO;
    self.supplementsCollapsedLabel.hidden = NO;
    
    self.supplementsTypeCollapsedLabel.hidden = YES;
    self.placeholderLabel.hidden = YES;
    
}

@end
