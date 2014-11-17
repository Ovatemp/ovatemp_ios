//
//  TrackingNotesViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/30/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingNotesViewController.h"
#import "ConnectionManager.h"
#import "Alert.h"

@interface TrackingNotesViewController () <UITextViewDelegate>

@end

@implementation TrackingNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSaveAndGoBack)]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveNoteAndGoBack)]];
    
    [self.notesTextView setTintColor:[UIColor ovatempAquaColor]];
    [self.notesTextView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    // title
    CGRect headerTitleSubtitleFrame = CGRectMake(0, -15, 200, 44);
    UIView *_headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
    _headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    _headerTitleSubtitleView.autoresizesSubviews = NO;
    
    CGRect titleFrame = CGRectMake(-8, 0, 200, 24);
    UILabel *titleView = [[UILabel alloc] initWithFrame:titleFrame];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:17];
    titleView.textAlignment = NSTextAlignmentCenter;
    
    titleView.text = @"Notes";
    titleView.textColor = [UIColor ovatempDarkGreyTitleColor];
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    
    CGRect subtitleFrame = CGRectMake(-8, 22, 200, 44-24);
    UILabel *subtitleView = [[UILabel alloc] initWithFrame:subtitleFrame];
    subtitleView.backgroundColor = [UIColor clearColor];
    subtitleView.font = [UIFont boldSystemFontOfSize:13];
    subtitleView.textAlignment = NSTextAlignmentCenter;
    
//    NSDate *date = [NSDate date];
    NSDate *date = self.selectedDate;
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
//    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *dateKeyString = [dateFormatter stringFromDate:self.selectedDate];
//    NSString *keyString = [NSString stringWithFormat:@"note_%@", dateKeyString];
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    if ([defaults objectForKey:keyString]) {
//        self.notesTextView.text = [defaults objectForKey:keyString];
//    }
    self.notesTextView.text = self.notesText;
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
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *dateString = [dateFormatter stringFromDate:self.selectedDate];
//    NSString *keyString = [NSString stringWithFormat:@"note_%@", dateString];
//    
//    if ([self.notesTextView.text length] > 0) { // user entered a note
//        [defaults setObject:self.notesTextView.text forKey:keyString];
//    } else { // no note or user deleted all text
//        [defaults removeObjectForKey:keyString];
//    }
//    
//    [defaults synchronize];
    
    // No longer using NSUserDefaults, hitting backend
    [self postNoteToBackend];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)postNoteToBackend {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setObject:self.notesTextView.text forKey:@"notes"];
    [attributes setObject:self.selectedDate forKey:@"date"];
    
    [ConnectionManager put:@"/days/"
                    params:@{
                             @"day": attributes,
                             }
                   success:^(NSDictionary *response) {
//                       [Cycle cycleFromResponse:response];
//                       [Calendar setDate:self.selectedDate];
                       //                       if (onSuccess) onSuccess(response);
                       NSLog(@"Posted note sucessfully");
                   }
                   failure:^(NSError *error) {
                       [Alert presentError:error];
                   }];
}

- (void)cancelSaveAndGoBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self.notesTextView resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 1024;
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
