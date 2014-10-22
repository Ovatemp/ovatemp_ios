//
//  Welcome3ViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/20/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Welcome3ViewController.h"
#import "LastPeriodTableViewCell.h"
#import "CycleLengthTableViewCell.h"

@interface Welcome3ViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSIndexPath *selectedRowIndex;

// Cells
@property LastPeriodTableViewCell *lastPeriodCell;
@property CycleLengthTableViewCell *cycleLengthCell;

// Info
@property NSDate *lastPeriodDate;

@end

@implementation Welcome3ViewController

NSArray *welcomeInfoArray;
BOOL expandCell;
BOOL firstOpenLastPeriod;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    expandCell = NO;
    
    firstOpenLastPeriod = YES;
    
    self.tableView.delegate = self;
    
    welcomeInfoArray = [NSArray arrayWithObjects:@"Last Period", @"Cycle Length", @"Height", @"Weight", nil];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"LastPeriodTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"lastPeriodCell"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"CycleLengthTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cycleCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doNextScreen:(id)sender {
    [self performSegueWithIdentifier:@"toOndoPairing" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [welcomeInfoArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
        {
            self.lastPeriodCell = [tableView dequeueReusableCellWithIdentifier:@"lastPeriodCell" forIndexPath:indexPath];
            
            if (expandCell) {
                self.lastPeriodCell.datePicker.hidden = NO;
            }
            
            return self.lastPeriodCell;
             break;
        }
        case 1:
        {
            self.cycleLengthCell = [tableView dequeueReusableCellWithIdentifier:@"cycleCell" forIndexPath:indexPath];
            
            if (expandCell) {
                self.cycleLengthCell.cycleLengthPicker.hidden = NO;
                self.cycleLengthCell.cycleLengthValueLabel.text = @"26";
            }
            
            return self.cycleLengthCell;
             break;
        }
        case 2:
        {
            cell = [[UITableViewCell alloc] init];
            [[cell textLabel] setText:[welcomeInfoArray objectAtIndex:indexPath.row]];
             break;
        }
        case 3:
        {
            cell = [[UITableViewCell alloc] init];
            [[cell textLabel] setText:[welcomeInfoArray objectAtIndex:indexPath.row]];
             break;
        }
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.selectedRowIndex && indexPath.row == self.selectedRowIndex.row) {
        if (expandCell) {
            return 200.0f;
        }
    }
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    expandCell = !expandCell;
    
    self.selectedRowIndex = indexPath;
    
    switch (indexPath.row) {
        case 0:
        {
            if (firstOpenLastPeriod) {
                self.lastPeriodDate = self.lastPeriodCell.datePicker.date;
                firstOpenLastPeriod = NO;
            }
            
            // record date
            if (!expandCell) {
                self.lastPeriodDate = self.lastPeriodCell.datePicker.date;
            }
            break;
        }
            
        case 1:
        {
            break;
        }
            
        case 2:
        {
            break;
        }
            
        case 3:
        {
            break;
        }
            
        default:
            break;
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // refreshed cells, set lables
    switch (indexPath.row) {
        case 0:
        {
            self.lastPeriodCell.dateLabel.text = [self.lastPeriodDate classicDate];
            break;
        }
            
        case 1:
        {
            break;
        }
            
        case 2:
        {
            break;
        }
            
        case 3:
        {
            break;
        }
            
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
