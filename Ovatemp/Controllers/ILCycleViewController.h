//
//  ILCycleViewController.h
//  Ovatemp
//
//  Created by Daniel Lozano on 3/25/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Cycle.h"

@interface ILCycleViewController : UIViewController

@property (nonatomic) Cycle *selectedCycle;

@property (weak, nonatomic) IBOutlet UICollectionView *periodCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *cfCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *cpCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *sexCollectionView;

@end
