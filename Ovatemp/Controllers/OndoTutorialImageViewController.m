//
//  OndoTutorialImageViewController.m
//  Ovatemp
//
//  Created by Daniel Lozano on 6/18/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "OndoTutorialImageViewController.h"

#import "OndoTutorialViewController.h"

@interface OndoTutorialImageViewController ()

@end

@implementation OndoTutorialImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customizeAppearance];
    
    self.ondoImageView.image = [self appropiateOndoTutorialImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customizeAppearance
{
    self.title = @"ONDO Setup";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor darkGrayColor]};
    self.navigationController.navigationBar.tintColor = [UIColor ovatempAquaColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                              UIBarButtonSystemItemDone target: self action: @selector(didSelectDone)];;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Back"
                                                                             style: UIBarButtonItemStyleDone
                                                                            target: nil
                                                                            action: nil];
    
    if (self.index == 5) {
        [self.nextButton setTitle: @"Done" forState: UIControlStateNormal];
    }
}

#pragma mark - IBAction's

- (void)didSelectDone
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction)didSelectNext:(id)sender
{
    if (self.index == 2) {
        // Go to test
        OndoTutorialViewController *tutorialVC = [self.storyboard instantiateViewControllerWithIdentifier: @"OndoTutorialViewController"];
        [self.navigationController pushViewController: tutorialVC animated: YES];
        return;
        
    }else if(self.index == 5){
        // Finish
        [self dismissViewControllerAnimated: YES completion: nil];
        return;
    }
    
    OndoTutorialImageViewController *tutorialVC = [self.storyboard instantiateViewControllerWithIdentifier: @"OndoTutorialImageViewController"];
    tutorialVC.index = self.index + 1;
    [self.navigationController pushViewController: tutorialVC animated: YES];
}

#pragma mark - Heleper's

- (UIImage *)appropiateOndoTutorialImage
{
    switch (self.index) {
        case 0:{
            return [UIImage imageNamed: @"OndoTutorial1"];
            break;
        }
        case 1:{
            return [UIImage imageNamed: @"OndoTutorial2"];
            break;
        }
        case 2:{
            return [UIImage imageNamed: @"OndoTutorial3"];
            break;
        }
        case 3:{
            return [UIImage imageNamed: @"OndoTutorial4"];
            break;
        }
        case 4:{
            return [UIImage imageNamed: @"OndoTutorial5"];
            break;
        }
        case 5:{
            return [UIImage imageNamed: @"OndoTutorial6"];
            break;
        }
        default:
            return nil;
            break;
    }
}

@end
