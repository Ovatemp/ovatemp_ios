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

typedef enum {
    TableStateAllClosed,
    TableStateLastPeriodExpanded,
    TableStateCycleLengthExpanded,
    TableStateHeightExpanded,
    TableStateWeightExpanded,
} TableStateType;

@interface Welcome3ViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSIndexPath *selectedRowIndex;

// Cells
@property LastPeriodTableViewCell *lastPeriodCell;
@property CycleLengthTableViewCell *cycleLengthCell;

// Info
@property NSDate *lastPeriodDate;
@property int cycleLength;
@property int userHeightFeetComponent;
@property int userHeightInchesComponent;
@property int userWeight;

@end

@implementation Welcome3ViewController

NSArray *welcomeInfoArray;

TableStateType currentState;

BOOL expandLastPeriodCell;
BOOL expandCycleLengthCell;
BOOL expandHeightCell;
BOOL expandWeightCell;

BOOL firstOpenLastPeriod;
BOOL firstOpenCycleLengthCell;
BOOL firstOpenHeightCell;
BOOL firstOpenWeightCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    currentState = TableStateAllClosed;
    
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
            
            if (expandLastPeriodCell) {
                self.lastPeriodCell.datePicker.hidden = NO;
            }
            
            return self.lastPeriodCell;
             break;
        }
        case 1:
        {
            self.cycleLengthCell = [tableView dequeueReusableCellWithIdentifier:@"cycleCell" forIndexPath:indexPath];
            
            if (expandLastPeriodCell) {
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
        if (expandLastPeriodCell || expandCycleLengthCell || expandHeightCell || expandWeightCell) {
            return 200.0f;
        }
    }
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedRowIndex = indexPath;
    
    switch (indexPath.row) {
        case 0: // tapped first cell
        {
            
            if (currentState == TableStateAllClosed) { // open first cell
                [self setTableStateForState:TableStateCycleLengthExpanded];
            }
            
            expandLastPeriodCell = !expandLastPeriodCell;
            
            // first time the cell is opened we need to save the date
            if (firstOpenLastPeriod) {
                self.lastPeriodDate = self.lastPeriodCell.datePicker.date;
                firstOpenLastPeriod = NO;
            }
            
            // record date
            if (!expandLastPeriodCell) {
                self.lastPeriodDate = self.lastPeriodCell.datePicker.date;
            }
            
            // reset all other cells
            expandCycleLengthCell = NO;
            self.cycleLengthCell.cycleLengthPicker.hidden = !self.cycleLengthCell.cycleLengthPicker.hidden;
            expandHeightCell = NO;
            expandWeightCell = NO;
            break;
        }
            
        case 1:
        {
            expandCycleLengthCell = !expandCycleLengthCell;
            
            if (firstOpenCycleLengthCell) {
                
            }
            
            if (!expandCycleLengthCell) {
                
            }
            
            // reset all other cells
            expandLastPeriodCell = NO;
            self.lastPeriodCell.datePicker.hidden = !self.lastPeriodCell.datePicker.hidden;
            expandHeightCell = NO;
            expandWeightCell = NO;
            break;
        }
            
        case 2:
        {
            expandHeightCell = !expandWeightCell;
            
            if (firstOpenHeightCell) {
                
            }
            
            if (!expandWeightCell) {
                
            }
            
            // reset all other cells
            expandLastPeriodCell = NO;
            expandCycleLengthCell = NO;
            expandWeightCell = NO;
            break;
        }
            
        case 3:
        {
            expandWeightCell = !expandWeightCell;
            
            if (firstOpenWeightCell) {
                
            }
            
            if (!expandWeightCell) {
                
            }
            
            // reset all other cells
            expandLastPeriodCell = NO;
            expandCycleLengthCell = NO;
            expandHeightCell = NO;
            break;
        }
            
        default:
            break;
    }
    
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (int i = 0; i < 4; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
//    [tableView reloadData];
    
    
    
    
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

- (void)setTableStateForState:(TableStateType)state {
    
//    TableStateAllClosed,
//    TableStateLastPeriodExpanded,
//    TableStateCycleLengthExpanded,
//    TableStateHeightExpanded,
//    TableStateWeightExpanded,
    
    switch (state) {
        case TableStateAllClosed:
        {
            expandLastPeriodCell = NO;
            expandCycleLengthCell = NO;
            expandHeightCell = NO;
            expandWeightCell = NO;
            
            currentState = TableStateAllClosed;
            break;
        }
            
        case TableStateLastPeriodExpanded:
        {
            expandLastPeriodCell = YES;
            expandCycleLengthCell = NO;
            expandHeightCell = NO;
            expandWeightCell = NO;
            
            currentState = TableStateLastPeriodExpanded;
            break;
        }
            
        case TableStateCycleLengthExpanded:
        {
            expandLastPeriodCell = NO;
            expandCycleLengthCell = YES;
            expandHeightCell = NO;
            expandWeightCell = NO;
            
            currentState = TableStateCycleLengthExpanded;
            break;
        }
            
        case TableStateHeightExpanded:
        {
            expandLastPeriodCell = NO;
            expandCycleLengthCell = NO;
            expandHeightCell = YES;
            expandWeightCell = NO;
            
            currentState = TableStateHeightExpanded;
            break;
        }
            
        case TableStateWeightExpanded:
        {
            expandLastPeriodCell = NO;
            expandCycleLengthCell = NO;
            expandHeightCell = NO;
            expandWeightCell = YES;
            
            currentState = TableStateWeightExpanded;
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
