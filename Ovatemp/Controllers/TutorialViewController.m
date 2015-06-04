//
//  TutorialViewController.m
//  Ovatemp
//
//  Created by Daniel Lozano on 4/22/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "TutorialViewController.h"

#import "TutorialContentViewController.h"

@interface TutorialViewController () <UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic) UIPageViewController *pageViewController;

@end

@implementation TutorialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setUpPageViewController];
    
    [self.view bringSubviewToFront: self.skipButton];
    [self.view bringSubviewToFront: self.pageControl];
    
    if (self.darkMode) {
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        [self.skipButton setTitleColor: [UIColor darkGrayColor] forState: UIControlStateNormal];
        UIColor *almostWhiteColor = [UIColor colorWithRed: 249.0/255.0 green: 249.0/255.0 blue: 249.0/255.0 alpha: 1];
        self.view.backgroundColor = almostWhiteColor;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden: YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden: NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - IBAction's

- (IBAction)didSelectSkipTutorial:(id)sender
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)setUpPageViewController
{
    TutorialContentViewController *initialVC = [self viewControllerAtIndex: 0];
    
    self.pageViewController = [[self storyboardForTutorial] instantiateViewControllerWithIdentifier: @"pageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    [self.pageViewController setViewControllers: @[initialVC] direction: UIPageViewControllerNavigationDirectionForward animated: YES completion: nil];
    
    self.pageControl.numberOfPages = [self.images count];
    
    [self addChildViewController: self.pageViewController];
    [self.view addSubview: self.pageViewController.view];
    
    [self.pageViewController didMoveToParentViewController: self];
}

#pragma mark - UIPageViewController Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    TutorialContentViewController *contentVC = (TutorialContentViewController *)viewController;
    NSUInteger index = contentVC.index;
        
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex: index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    TutorialContentViewController *contentVC = (TutorialContentViewController *)viewController;
    NSUInteger index = contentVC.index;
    
    index++;
    
    if (index == [self.images count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex: index];
    
}

#pragma mark - Delegate

- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if (!completed){
        return;
    }
    
    TutorialContentViewController *currentVC = (TutorialContentViewController *)[self.pageViewController.viewControllers lastObject];
    NSUInteger indexOfCurrentPage = currentVC.index;
    
    self.pageControl.currentPage = indexOfCurrentPage;
}

#pragma mark - Helper's

- (TutorialContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if ([self.images count] == 0 || index > [self.images count]) {
        return nil;
    }
    
    TutorialContentViewController *contentVC = [[self storyboardForTutorial] instantiateViewControllerWithIdentifier: @"tutorialContentViewController"];
    contentVC.index = index;
    contentVC.image = self.images[index];
    
    UIColor *almostWhiteColor = [UIColor colorWithRed: 249.0/255.0 green: 249.0/255.0 blue: 249.0/255.0 alpha: 1];
    UIColor *blueGrayColor = [UIColor colorWithRed: 118.0/255.0 green: 121.0/255.0 blue: 137.0/255.0 alpha: 1];
    contentVC.view.backgroundColor = self.darkMode ? almostWhiteColor : blueGrayColor;
    
    return contentVC;
}

- (UIStoryboard *)storyboardForTutorial
{
    return [UIStoryboard storyboardWithName: @"Tutorials" bundle: nil];
}

@end
