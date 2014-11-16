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

@implementation TrackingSupplementsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectedDate = [[NSDate alloc] init];
    
    self.supplementsTableViewDataSource = [[NSMutableArray alloc] init];
    
    [self.supplementsTableViewDataSource addObject:@"One"];
    [self.supplementsTableViewDataSource addObject:@"Two"];
    [self.supplementsTableViewDataSource addObject:@"Three"];
    
    self.supplementsTableView.delegate = self;
    self.supplementsTableView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didSelectInfoButton:(id)sender {
    
}
- (IBAction)didSelectAddSupplementButton:(id)sender {

    // set up alert
    UIAlertController *alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Add new supplement"
                                     preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   UITextField *alertField = [[alert textFields] firstObject];
                                                   NSString *supplement = alertField.text;
                                                   [self postNewSupplementToBackendWithSupplement:supplement];
                                               }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                               handler:nil];
    
    [alert addTextFieldWithConfigurationHandler:nil];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self.delegate presentViewControllerWithViewController:alert];
}

//- (void)createWithName:(NSString *)name success:(ConnectionManagerSuccess)onSuccess
//{
//    NSString *className = [[self description] lowercaseString];
//    NSString *classNamePlural = [className stringByAppendingString:@"s"];
//    
//    [ConnectionManager post:[@"/" stringByAppendingString:classNamePlural]
//                     params:@{
//                              className:
//                                  @{
//                                      @"name":name
//                                      }
//                              }
//                    success:^(NSDictionary *response) {
//                        SharedRelation *newInstance = [self.class withAttributes:response[className]];
//                        if(onSuccess) {
//                            onSuccess(newInstance);
//                        }
//                    }
//                    failure:^(NSError *error) {
//                        [Alert presentError:error];
//                    }
//     ];
//}

//- (void)attributeSelectionChanged:(DayAttribute *)attribute selected:(NSArray *)selection {
//    DayCellStaticView *staticView = [self staticViewForAttribute:attribute];
//    staticView.selectedChoices = selection;
//    
//    NSString *key = [attribute.name substringWithRange:NSMakeRange(0, attribute.name.length - 1)];
//    key = [key stringByAppendingString:@"Ids"];
//    NSArray *selectedIDs = [selection valueForKey:@"id"];
//    
//    [self.day updateProperty:key withValue:selectedIDs.copy]; // post
//    [self trackAttributeChange:attribute]; // analytics
//}

///
- (void)postNewSupplementToBackendWithSupplement:(NSString *)supplement {
    NSString *className = @"supplement"; // supplement
    NSString *classNamePlural = [className stringByAppendingString:@"s"]; // supplements
    
    [ConnectionManager post:[@"/" stringByAppendingString:classNamePlural]
                     params:@{
                              className: // supplement
                                  @{
                                      @"name":supplement // new supplement
                                      }
                              }
                    success:^(NSDictionary *response) {
//                        {
//                            success = "Successfully created Supplement";
//                            supplement =     {
//                                "belongs_to_all_users" = 0;
//                                "created_at" = "2014-11-16T17:23:06.661Z";
//                                id = 13;
//                                name = "some tea";
//                                "updated_at" = "2014-11-16T17:23:06.661Z";
//                                "user_id" = 66;
//                            };
//                        }
//                        SharedRelation *newInstance = [self.class withAttributes:response[className]];
//                        if(onSuccess) {
//                            onSuccess(newInstance);
                            // shared relation looks like this:
                            // Supplement (13): some tea [doesn't belong to all users]
//                        }
                    }
                    failure:^(NSError *error) {
                        [Alert presentError:error];
                    }
     ];
}

- (void)hitBackendWithPregnancyTestType:(id)ptType {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setObject:ptType forKey:@"ferning"];
    [attributes setObject:self.selectedDate forKey:@"date"];
    
    [ConnectionManager put:@"/days/"
                    params:@{
                             @"day": attributes,
                             }
                   success:^(NSDictionary *response) {
//                       [Cycle cycleFromResponse:response];
//                       [Calendar setDate:self.selectedDate];
                       //                       if (onSuccess) onSuccess(response);
                   }
                   failure:^(NSError *error) {
                       [Alert presentError:error];
                   }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.supplementsTableViewDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.textLabel.text = [self.supplementsTableViewDataSource objectAtIndex:indexPath.row];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell setTintColor:[UIColor blackColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.supplementsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

@end
