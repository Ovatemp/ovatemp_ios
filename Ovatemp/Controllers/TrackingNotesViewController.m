//
//  TrackingNotesViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/30/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingNotesViewController.h"

@interface TrackingNotesViewController () <UITextViewDelegate>

@end

@implementation TrackingNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveNoteAndGoBack)]];
    
    [self.notesTextView setTintColor:[UIColor ovatempAquaColor]];
    [self.notesTextView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    // title
    CGRect headerTitleSubtitleFrame = CGRectMake(0, -15, 200, 44);
    UIView *_headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
    _headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    _headerTitleSubtitleView.autoresizesSubviews = NO;
    
    CGRect titleFrame = CGRectMake(0, 0, 200, 24);
    UILabel *titleView = [[UILabel alloc] initWithFrame:titleFrame];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:17];
    titleView.textAlignment = NSTextAlignmentCenter;
    
    titleView.text = @"Notes";
    titleView.textColor = [UIColor ovatempDarkGreyTitleColor];
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    
    CGRect subtitleFrame = CGRectMake(0, 22, 200, 44-24);
    UILabel *subtitleView = [[UILabel alloc] initWithFrame:subtitleFrame];
    subtitleView.backgroundColor = [UIColor clearColor];
    subtitleView.font = [UIFont boldSystemFontOfSize:13];
    subtitleView.textAlignment = NSTextAlignmentCenter;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *dateString = [df stringFromDate:date];
    
    subtitleView.text = dateString;
    subtitleView.textColor = [UIColor ovatempDarkGreyTitleColor];
    subtitleView.adjustsFontSizeToFitWidth = YES;
    
    [_headerTitleSubtitleView addSubview:subtitleView];
    
    self.navigationItem.titleView = _headerTitleSubtitleView;
    
    self.notesTextView.delegate = self;
    
    // set text
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateKeyString = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@",dateKeyString);
    NSString *keyString = [NSString stringWithFormat:@"note_%@", dateKeyString];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:keyString]) {
        self.notesTextView.text = [defaults objectForKey:keyString];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.notesTextView.text length] == 0) {
        [self.notesTextView becomeFirstResponder];
    }
    
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 320, 64)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 320, 90)];
}

- (void)saveNoteAndGoBack {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@",dateString);
    NSString *keyString = [NSString stringWithFormat:@"note_%@", dateString];
    
    if ([self.notesTextView.text length] > 0) { // user entered a note
        [defaults setObject:self.notesTextView.text forKey:keyString];
    } else { // no note or user deleted all text
        [defaults removeObjectForKey:keyString];
    }
    
    [defaults synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self.notesTextView resignFirstResponder];
    return YES;
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
