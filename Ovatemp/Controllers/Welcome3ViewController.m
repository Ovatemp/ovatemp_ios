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
#import "HeightTableViewCell.h"
#import "WeightTableViewCell.h"

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
@property HeightTableViewCell *heightCell;
@property WeightTableViewCell *weightCell;

// Info
@property NSDate *lastPeriodDate;
@property NSInteger cycleLength;
@property NSInteger userHeightFeetComponent;
@property NSInteger userHeightInchesComponent;
@property NSInteger userWeight;

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
    
    expandLastPeriodCell = NO;
    expandCycleLengthCell = NO;
    expandHeightCell = NO;
    expandWeightCell = NO;
    
    firstOpenLastPeriod = YES;
    firstOpenCycleLengthCell = YES;
    firstOpenHeightCell = YES;
    firstOpenWeightCell = YES;
    
    currentState = TableStateAllClosed;
    
    self.tableView.delegate = self;
    
    welcomeInfoArray = [NSArray arrayWithObjects:@"Last Period", @"Cycle Length", @"Height", @"Weight", nil];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"LastPeriodTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"lastPeriodCell"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"CycleLengthTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cycleCell"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"HeightTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"heightCell"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"WeightTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"weightCell"];
}

- (void)viewDidAppear:(BOOL)animated {
    expandLastPeriodCell = NO;
    expandCycleLengthCell = NO;
    expandHeightCell = NO;
    expandWeightCell = NO;
    
    firstOpenLastPeriod = YES;
    firstOpenCycleLengthCell = YES;
    firstOpenHeightCell = YES;
    firstOpenWeightCell = YES;
    
    currentState = TableStateAllClosed;
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
            
            if (expandCycleLengthCell) {
                self.cycleLengthCell.cycleLengthPicker.hidden = NO;
//                self.cycleLengthCell.cycleLengthValueLabel.text = @"26";
            }
            
            return self.cycleLengthCell;
             break;
        }
        case 2:
        {
            self.heightCell = [tableView dequeueReusableCellWithIdentifier:@"heightCell" forIndexPath:indexPath];
            
            if (expandWeightCell) {
                self.heightCell.heightPicker.hidden = NO;
//                self.heightCell.heightValueLabel.text = @"100";
            }
            
            return self.heightCell;
            break;
        }
        case 3:
        {
            self.weightCell = [tableView dequeueReusableCellWithIdentifier:@"weightCell" forIndexPath:indexPath];
            
            if (expandWeightCell) {
                self.weightCell.weightPicker.hidden = NO;
//                self.weightCell.weightValueLabel.text = @"3' 1\"";
            }
            
            return self.weightCell;
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
            
            if (currentState == TableStateLastPeriodExpanded) {
                [self setTableStateForState:TableStateAllClosed];
            } else {
                [self setTableStateForState:TableStateLastPeriodExpanded];
            }
            
//            expandLastPeriodCell = !expandLastPeriodCell;
            
            // first time the cell is opened we need to save the date
            if (firstOpenLastPeriod) {
                self.lastPeriodDate = self.lastPeriodCell.datePicker.date;
                firstOpenLastPeriod = NO;
            }
            
            // record date
            if (!expandLastPeriodCell) {
                self.lastPeriodDate = self.lastPeriodCell.datePicker.date;
            }
            break;
        }
            
        case 1:
        {
//            expandCycleLengthCell = !expandCycleLengthCell;
            
            if (currentState == TableStateCycleLengthExpanded) {
                [self setTableStateForState:TableStateAllClosed];
            } else {
                [self setTableStateForState:TableStateCycleLengthExpanded];
            }
            
            if (firstOpenCycleLengthCell) {
                self.cycleLength = 26;
                firstOpenCycleLengthCell = NO;
            }
            
            if (!expandCycleLengthCell) {
                // safe picker info
                // TODO: FIXME, just read lable contents
                self.cycleLength = [self.cycleLengthCell.cycleLengthPicker selectedRowInComponent:0];
                
            }
            break;
        }
            
        case 2:
        {
//            expandHeightCell = !expandHeightCell;
            
            if (currentState == TableStateHeightExpanded) {
                [self setTableStateForState:TableStateAllClosed];
            } else {
                [self setTableStateForState:TableStateHeightExpanded];
            }
            
            if (firstOpenHeightCell) {
                
            }
            
            if (!expandWeightCell) {
                
            }
            break;
        }
            
        case 3:
        {
//            expandWeightCell = !expandWeightCell;
            
            if (currentState == TableStateWeightExpanded) {
                [self setTableStateForState:TableStateAllClosed];
            } else {
                [self setTableStateForState:TableStateWeightExpanded];
            }
            
            if (firstOpenWeightCell) {
                
            }
            
            if (!expandWeightCell) {
                
            }
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
            self.cycleLengthCell.cycleLengthValueLabel.text = [NSString stringWithFormat:@"%ld", (long)self.cycleLength];
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
    
    [self setTableStateForState:currentState];
    
    [tableView setNeedsDisplay];
    [tableView setNeedsLayout];
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
            self.lastPeriodCell.datePicker.hidden = YES;
            expandCycleLengthCell = NO;
            self.cycleLengthCell.cycleLengthPicker.hidden = YES;
            expandHeightCell = NO;
            self.heightCell.heightPicker.hidden = YES;
            expandWeightCell = NO;
            self.weightCell.weightPicker.hidden = YES;
            
            currentState = TableStateAllClosed;
            break;
        }
            
        case TableStateLastPeriodExpanded:
        {
            expandLastPeriodCell = YES;
            self.lastPeriodCell.datePicker.hidden = NO;
            expandCycleLengthCell = NO;
            self.cycleLengthCell.cycleLengthPicker.hidden = YES;
            expandHeightCell = NO;
            self.heightCell.heightPicker.hidden = YES;
            expandWeightCell = NO;
            self.weightCell.weightPicker.hidden = YES;
            
            currentState = TableStateLastPeriodExpanded;
            break;
        }
            
        case TableStateCycleLengthExpanded:
        {
            expandLastPeriodCell = NO;
            self.lastPeriodCell.datePicker.hidden = YES;
            expandCycleLengthCell = YES;
            self.cycleLengthCell.cycleLengthPicker.hidden = NO;
            expandHeightCell = NO;
            self.heightCell.heightPicker.hidden = YES;
            expandWeightCell = NO;
            self.weightCell.weightPicker.hidden = YES;
            
            currentState = TableStateCycleLengthExpanded;
            break;
        }
            
        case TableStateHeightExpanded:
        {
            expandLastPeriodCell = NO;
            self.lastPeriodCell.datePicker.hidden = YES;
            expandCycleLengthCell = NO;
            self.cycleLengthCell.cycleLengthPicker.hidden = YES;
            expandHeightCell = YES;
            self.heightCell.heightPicker.hidden = NO;
            expandWeightCell = NO;
            self.weightCell.weightPicker.hidden = YES;
            
            currentState = TableStateHeightExpanded;
            break;
        }
            
        case TableStateWeightExpanded:
        {
            expandLastPeriodCell = NO;
            self.lastPeriodCell.datePicker.hidden = YES;
            expandCycleLengthCell = NO;
            self.cycleLengthCell.cycleLengthPicker.hidden = YES;
            expandHeightCell = NO;
            self.heightCell.heightPicker.hidden = YES;
            expandWeightCell = YES;
            self.weightCell.weightPicker.hidden = NO;
            
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
