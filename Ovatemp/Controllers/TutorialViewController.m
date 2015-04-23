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
    
    return contentVC;
}

- (UIStoryboard *)storyboardForTutorial
{
    return [UIStoryboard storyboardWithName: @"Tutorials" bundle: nil];
}

@end
