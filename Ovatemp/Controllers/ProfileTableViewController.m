//
//  ProfileTableViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/16/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "Form.h"
#import "User.h"

@interface ProfileTableViewController ()

@property Form *form;

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.form = [Form withViewController:self];
    self.form.representedObject = [UserProfile current];
    self.form.onChange = ^(Form *form, FormRow *row, id value) {
        [[UserProfile current] save];
    };
    
    // Set up radio buttons
    FormRow *conceive = [self.form addKeyPath:@"tryingToConceive"
                                    withLabel:@"Trying to conceive:"
                                     andImage:@"MoreTryingToConceive.png"
                                    toSection:@"Goal"];
    FormRow *avoid = [self.form addKeyPath:@"tryingToConceive"
                                 withLabel:@"Trying to avoid:"
                                  andImage:@"MoreTryingToAvoid.png"
                                 toSection:@"Goal"];
    avoid.valueTransformer = [NSValueTransformer valueTransformerForName:NSNegateBooleanTransformerName];
    
    conceive.onChange = ^ (FormRow *row, id value) {
        UISwitch *avoidSwitch = (UISwitch *)avoid.control;
        UISwitch *conceiveSwitch = (UISwitch *)row.control;
        [avoidSwitch setOn:!conceiveSwitch.on animated:YES];
    };
    
    avoid.onChange = ^ (FormRow *row, id value) {
        UISwitch *avoidSwitch = (UISwitch *)row.control;
        UISwitch *conceiveSwitch = (UISwitch *)conceive.control;
        [conceiveSwitch setOn:!avoidSwitch.on animated:YES];
    };
    
    // name and birthday
    // If fullName is nil, initialize the form with a dummy name.
    if (![UserProfile current].fullName) {
        [UserProfile current].fullName = @"Jane Doe";
    }
    // dateOfBirth cannot be nil.  If for some reason it is nil, set the birthday to 12 years ago today (youngest age to use app).
    if (![UserProfile current].dateOfBirth) {
        NSDate *today = [[NSDate alloc] init];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents *addComponents = [[NSDateComponents alloc] init];
        addComponents.year = -12;
        
        
        [UserProfile current].dateOfBirth = [calendar dateByAddingComponents:addComponents toDate:today options:0];
    }
    self.form.representedObject = [UserProfile current];
    self.form.onChange = ^(Form *form, FormRow *row, id value) {
        [[UserProfile current] save];
    };
    
    [self.form addKeyPath:@"fullName" withLabel:@"Full Name:" toSection:@"Profile Settings"];
    
    NSInteger minAgeInYears = 12;
    NSInteger day = 60 * 60 * 24;
    NSInteger year = day * 365;
    NSDate *maximumDate = [NSDate dateWithTimeIntervalSinceNow:-minAgeInYears * year];
    NSDate *minimumDate = [NSDate dateWithTimeIntervalSinceNow:-50 * year];
    
    FormRow *birthDate = [self.form addKeyPath:@"dateOfBirth"
                                     withLabel:@"Date of Birth:"
                                      andImage:@"MoreBirthday.png"
                                     toSection:@"Profile Settings"];
    birthDate.datePicker.datePickerMode = UIDatePickerModeDate;
    birthDate.datePicker.minimumDate = minimumDate;
    birthDate.datePicker.maximumDate = maximumDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
