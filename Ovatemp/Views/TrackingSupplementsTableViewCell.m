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

- (void)setUpActivityView
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(startActivity)
                                                 name: @"supplements_start_activity"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(stopActivity)
                                                 name: @"supplements_stop_activity"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(reloadSupplements)
                                                 name: @"reload_supplements"
                                               object: nil];
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

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
                                                   [self postNewSupplementToBackendWithSupplement:supplement];
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

- (void)postNewSupplementToBackendWithSupplement:(NSString *)supplement
{
    NSString *className = @"supplement"; // supplement
    NSString *classNamePlural = [className stringByAppendingString:@"s"]; // supplements
    
    [self startActivity];
    
    [ConnectionManager post:[@"/" stringByAppendingString: classNamePlural]
                     params:@{
                              className: // supplement
                                  @{
                                      @"name":supplement // new supplement
                                      }
                              }
                    success:^(NSDictionary *response) {
                        
                        SimpleSupplement *newSupp = [[SimpleSupplement alloc] init];
                        newSupp.belongsToAllUsers = [[[response objectForKey:@"supplement"] objectForKey:@"belongs_to_all_users"] boolValue];
                        newSupp.createdAt = [[response objectForKey:@"supplement"] objectForKey:@"created_at"];
                        newSupp.idNumber = [NSNumber numberWithInt:[[[response objectForKey:@"supplement"] objectForKey:@"id"] intValue]];
                        newSupp.name = [[response objectForKey:@"supplement"] objectForKey:@"name"];
                        newSupp.updatedAt = [[response objectForKey:@"supplement"] objectForKey:@"updated_at"];
                        newSupp.userID = [[response objectForKey:@"supplement"] objectForKey:@"user_id"];
                        
                        // TO-DO: Check for duplicates so supplement doesn't appear twice
                        // De-select supplement if we want to uncheck it
                        if (self.selectedSupplementIDs == nil) {
                            self.selectedSupplementIDs = [[NSMutableArray alloc] init];
                        }
                        
                        if ([self.supplementsTableViewDataSource containsObject: newSupp]) {
                            //
                        } else {
                            [self.supplementsTableViewDataSource addObject: newSupp];
                        }
                        
                        [self.selectedSupplementIDs addObject: newSupp.idNumber];
                                                
                        if ([self.delegate respondsToSelector: @selector(didSelectSupplementsWithTypes:)]) {
                            [self.delegate didSelectSupplementsWithTypes: self.selectedSupplementIDs];
                        }
                        
                    }
                    failure:^(NSError *error) {
                        [self stopActivity];
                        [Alert presentError:error];
                    }
     ];
}

- (void)reloadSupplements
{
    [ConnectionManager put:@"/sessions/refresh"
                    params:nil
                   success:^(NSDictionary *response) {
                       [Configuration loggedInWithResponse:response];
                       
                       [self.supplementsTableView reloadData];
                       [self stopActivity];
                   }
                   failure:^(NSError *error) {
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
    
    SimpleSupplement *tempSupp = [self.supplementsTableViewDataSource objectAtIndex: indexPath.row];
    if ([self.selectedSupplementIDs containsObject: tempSupp.idNumber]) {
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
        
        if ([self.delegate respondsToSelector: @selector(didSelectSupplementsWithTypes:)]) {
            [self.delegate didSelectSupplementsWithTypes: self.selectedSupplementIDs];
        }
        
    } else {
        [self.supplementsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        
        SimpleSupplement *selectedSupp = [[SimpleSupplement alloc] init];
        selectedSupp = [self.supplementsTableViewDataSource objectAtIndex: indexPath.row];
        [self.selectedSupplementIDs addObject: selectedSupp.idNumber];
        
        if ([self.delegate respondsToSelector: @selector(didSelectSupplementsWithTypes:)]) {
            [self.delegate didSelectSupplementsWithTypes: self.selectedSupplementIDs];
        }
    }
}

#pragma mark - Appearance

- (void)updateCell
{
    Day *selectedDay = [self.delegate getSelectedDay];
    
    NSMutableArray *supplements = [[NSMutableArray alloc] init];
    NSMutableArray *supplementIDs = [[NSMutableArray alloc] initWithArray: selectedDay.supplementIds];
    
    if ([selectedDay.supplements count] > 0) {
        
        NSArray *suppArray = [[Supplement instances] allValues];
        
        for (Supplement *supp in suppArray) {
            SimpleSupplement *simpleSupp = [[SimpleSupplement alloc] init];
            simpleSupp.name = supp.name;
            simpleSupp.idNumber = supp.id;
            
            if (![supplementIDs containsObject:simpleSupp]) {
                [supplements addObject:simpleSupp];
            }
            
        }
        
        self.supplementsTableViewDataSource = supplements;
        self.selectedSupplementIDs = supplementIDs;
        
    } else {

        [self.supplementsTableViewDataSource removeAllObjects];
        [self.selectedSupplementIDs removeAllObjects];
        
        // add supplements to array, just don't mark them as selected
        NSArray *suppArray = [[Supplement instances] allValues];
        for (Supplement *supp in suppArray) {
            SimpleSupplement *simpleSupp = [[SimpleSupplement alloc] init];
            simpleSupp.name = supp.name;
            simpleSupp.idNumber = supp.id;
            
            if (![supplementIDs containsObject: simpleSupp]) {
                [supplements addObject: simpleSupp];
            }
        }
        
        self.supplementsTableViewDataSource = [[NSMutableArray alloc] initWithArray: supplements];
        self.selectedSupplementIDs = [[NSMutableArray alloc] initWithArray: supplementIDs];
    }
    
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
            // no selected supplements
            self.supplementsCollapsedLabel.hidden = YES;
            self.supplementsTypeCollapsedLabel.hidden = YES;
            self.placeholderLabel.hidden = NO;
        } else {
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
    self.infoButton.hidden = YES;
    self.addSupplementButton.hidden = NO;
    
    self.supplementsTableView.hidden = NO;
    self.supplementsCollapsedLabel.hidden = NO;
    
    self.supplementsTypeCollapsedLabel.hidden = YES;
    self.placeholderLabel.hidden = YES;
    
    [self.supplementsTableView flashScrollIndicators];
}

@end
