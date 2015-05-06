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

#import "Localytics.h"

@interface TrackingNotesViewController () <UITextViewDelegate>

@end

@implementation TrackingNotesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self customizeAppearance];
    [self setUpTitleView];
    
    self.notesTextView.delegate = self;
    self.notesTextView.text = self.notesText;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Localytics tagScreen: @"Tracking/Notes"];
    
    if ([self.notesTextView.text length] == 0) {
        [self.notesTextView becomeFirstResponder];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Appearance

- (void)customizeAppearance
{
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain
                                                                              target:self action:@selector(cancelSaveAndGoBack)]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone
                                                                               target:self action:@selector(saveNoteAndGoBack)]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.notesTextView setTintColor:[UIColor ovatempAquaColor]];
    //[self.notesTextView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)setUpTitleView
{
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
}

#pragma mark - IBAction's

- (void)saveNoteAndGoBack
{
    if ([self.delegate respondsToSelector: @selector(didAddNotes:)]) {
        [self.delegate didAddNotes: self.notesTextView.text];
    }
}

- (void)cancelSaveAndGoBack
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Network



#pragma mark - UITextView Delegate

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.notesTextView resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 1024;
}

@end
