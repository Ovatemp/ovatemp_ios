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
#import "User.h"

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

BOOL lastPeriodHasData;
BOOL cycleLengthHasData;
BOOL heightHasData;
BOOL weightHasData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeAppearance];
    // Do any additional setup after loading the view.
    
    expandLastPeriodCell = NO;
    expandCycleLengthCell = NO;
    expandHeightCell = NO;
    expandWeightCell = NO;
    
    firstOpenLastPeriod = YES;
    firstOpenCycleLengthCell = YES;
    firstOpenHeightCell = YES;
    firstOpenWeightCell = YES;
    
    lastPeriodHasData = NO;
    cycleLengthHasData = NO;
    heightHasData = NO;
    weightHasData = NO;
    
    currentState = TableStateAllClosed;
    
    self.tableView.delegate = self;
    
    welcomeInfoArray = [NSArray arrayWithObjects:@"Last Period", @"Cycle Length", @"Height", @"Weight", nil];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"LastPeriodTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"lastPeriodCell"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"CycleLengthTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cycleCell"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"HeightTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"heightCell"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"WeightTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"weightCell"];
    
    self.tableView.bounces = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    expandLastPeriodCell = NO;
    expandCycleLengthCell = NO;
    expandHeightCell = NO;
    expandWeightCell = NO;
    
    firstOpenLastPeriod = YES;
    firstOpenCycleLengthCell = YES;
    firstOpenHeightCell = YES;
    firstOpenWeightCell = YES;
    
    lastPeriodHasData = NO;
    cycleLengthHasData = NO;
    heightHasData = NO;
    weightHasData = NO;
    
    currentState = TableStateAllClosed;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Appearance

- (void)customizeAppearance
{
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject: [UIColor ovatempDarkGreyTitleColor]
                                                                                              forKey: NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor ovatempAquaColor];
}

- (IBAction)doNextScreen:(id)sender {
    
    // save user data
    // we need to check if the labels on each cell have contents before saving, since we put placeholder data in the global variables
    // if the label is not empty, save data
    // else, ignore dummy data and don't save
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // no longer using user defaults, saving to user profile
    UserProfile *currentUserProfile = [UserProfile current];
    
    if ([self.lastPeriodCell.dateLabel.text length] > 0) {
        NSLog(@"User entered last perioid info");
        
        self.firstDay = [Day forDate:self.lastPeriodDate];
        if(!self.firstDay) {
            self.firstDay = [Day withAttributes:@{@"date": self.lastPeriodDate,
                                                 @"idate": [self.lastPeriodDate dateId],
                                                @"period": @""}];
        }
        [self.firstDay selectProperty:@"period" withindex:PERIOD_LIGHT];
        [self.firstDay save];
    }
    
    if ([self.cycleLengthCell.cycleLengthValueLabel.text length] > 0) {
        NSLog(@"user entered cycle length info");
        
//        [defaults setInteger:self.cycleLength forKey:@"cycleLength"];
        currentUserProfile.cycleLength = [NSNumber numberWithInteger:self.cycleLength];
    }
    
    if ([self.heightCell.heightValueLabel.text length] > 0) {
        NSLog(@"user entered height");
        
//        [defaults setInteger:self.userHeightFeetComponent forKey:@"userHeightFeetComponent"];
//        [defaults setInteger:self.userHeightInchesComponent forKey:@"userHeightInchesComponent"];
        currentUserProfile.heightInInches = [NSNumber numberWithInteger:((self.userHeightFeetComponent * 12) + self.userHeightInchesComponent)];
    }
    
    if ([self.weightCell.weightValueLabel.text length] > 0) {
        NSLog(@"user entered weight");
        
//        [defaults setInteger:self.userWeight forKey:@"userWeight"];
        currentUserProfile.weightInPounds = [NSNumber numberWithInteger:self.userWeight];
    }
    
//    [defaults synchronize];
    
    [self performSegueWithIdentifier:@"toOndoPairing" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [welcomeInfoArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
            }
            
            return self.cycleLengthCell;
             break;
        }
        case 2:
        {
            self.heightCell = [tableView dequeueReusableCellWithIdentifier:@"heightCell" forIndexPath:indexPath];
            
            if (expandHeightCell) {
                self.heightCell.heightPicker.hidden = NO;
            }
            
            return self.heightCell;
            break;
        }
        case 3:
        {
            self.weightCell = [tableView dequeueReusableCellWithIdentifier:@"weightCell" forIndexPath:indexPath];
            
            if (expandWeightCell) {
                self.weightCell.weightPicker.hidden = NO;
            }
            
            return self.weightCell;
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.selectedRowIndex && indexPath.row == self.selectedRowIndex.row) {
        if (expandLastPeriodCell || expandCycleLengthCell || expandHeightCell || expandWeightCell) {
            return 200.0f;
        }
    }
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.selectedRowIndex = indexPath;
    
    switch (indexPath.row) {
        case 0: // tapped first cell
        {
            
            if (currentState == TableStateLastPeriodExpanded) {
                [self setTableStateForState:TableStateAllClosed];
            } else {
                [self setTableStateForState:TableStateLastPeriodExpanded];
            }
            
            
            // first time the cell is opened we need to save the date
            if (firstOpenLastPeriod) {
                self.lastPeriodDate = self.lastPeriodCell.datePicker.date;
                firstOpenLastPeriod = NO;
                lastPeriodHasData = YES;
            }
            
            // record date
            if (!expandLastPeriodCell) {
                self.lastPeriodDate = self.lastPeriodCell.datePicker.date;
            }
            break;
        }
            
        case 1:
        {
            
            if (currentState == TableStateCycleLengthExpanded) {
                [self setTableStateForState:TableStateAllClosed];
            } else {
                [self setTableStateForState:TableStateCycleLengthExpanded];
            }
            
            if (firstOpenCycleLengthCell) {
                self.cycleLength = 28;
                firstOpenCycleLengthCell = NO;
                cycleLengthHasData = YES;
            }
            
            if (!expandCycleLengthCell) {
                // save picker info
                self.cycleLength = [self.cycleLengthCell.cycleLengthValueLabel.text integerValue];
                
            }
            break;
        }
            
        case 2:
        {
            
            if (currentState == TableStateHeightExpanded) {
                [self setTableStateForState:TableStateAllClosed];
            } else {
                [self setTableStateForState:TableStateHeightExpanded];
            }
            
            if (firstOpenHeightCell) {
                self.userHeightFeetComponent = 5;
                self.userHeightInchesComponent = 5;
                firstOpenHeightCell = NO;
                heightHasData = YES;
            }
            
            if (!expandHeightCell) {
                self.userHeightFeetComponent = ([self.heightCell.heightPicker selectedRowInComponent:0] + 3);
                self.userHeightInchesComponent = ([self.heightCell.heightPicker selectedRowInComponent:1]);
            }
            break;
        }
            
        case 3:
        {
            
            if (currentState == TableStateWeightExpanded) {
                [self setTableStateForState:TableStateAllClosed];
            } else {
                [self setTableStateForState:TableStateWeightExpanded];
            }
            
            if (firstOpenWeightCell) {
                self.userWeight = 130;
                firstOpenWeightCell = NO;
                weightHasData = YES;
            }
            
            if (!expandWeightCell) {
                self.userWeight = ([self.weightCell.weightPicker selectedRowInComponent:0] + 100);
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
    
    [tableView reloadRowsAtIndexPaths: indexPaths withRowAnimation: UITableViewRowAnimationAutomatic];

    // refreshed cells, set lables
    switch (indexPath.row) {
        case 0:
        {
            self.lastPeriodCell.dateLabel.text = [self.lastPeriodDate classicDate];
            break;
        }
            
        case 1:
        {
            self.cycleLengthCell.cycleLengthValueLabel.text = [NSString stringWithFormat:@"%ld days", (long)self.cycleLength];
            break;
        }
            
        case 2:
        {
            self.heightCell.heightValueLabel.text = [NSString stringWithFormat:@"%ld' %ld\"", (long)self.userHeightFeetComponent, (long)self.userHeightInchesComponent];
            break;
        }
            
        case 3:
        {
            self.weightCell.weightValueLabel.text = [NSString stringWithFormat:@"%ld lbs", (long)self.userWeight];
            
            break;
        }
            
        default:
            break;
    }
    
    // if we opened a cell earlier, set the data we have
    if (lastPeriodHasData) {
        self.lastPeriodCell.dateLabel.text = [self.lastPeriodDate classicDate];
    }
    
    if (cycleLengthHasData) {
        self.cycleLengthCell.cycleLengthValueLabel.text = [NSString stringWithFormat:@"%ld days", (long)self.cycleLength];
    }
    
    if (heightHasData) {
        self.heightCell.heightValueLabel.text = [NSString stringWithFormat:@"%ld' %ld\"", (long)self.userHeightFeetComponent, (long)self.userHeightInchesComponent];
    }
    
    if (weightHasData) {
        self.weightCell.weightValueLabel.text = [NSString stringWithFormat:@"%ld lbs", (long)self.userWeight];
    }
    
    // make sure cell can be displayed, even if out of view
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [self setTableStateForState:currentState]; // make sure current state is set
    
    [tableView setNeedsDisplay];
    [tableView setNeedsLayout];
}

- (void)setTableStateForState:(TableStateType)state
{
    
//    TableStateAllClosed
//    TableStateLastPeriodExpanded
//    TableStateCycleLengthExpanded
//    TableStateHeightExpanded
//    TableStateWeightExpanded
    
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 320, 200);
    
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}

@end
