//
//  UINavigationController+Orientation.h
//  Ovatemp
//
//  Created by Daniel Lozano on 5/13/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Orientation)

-(NSUInteger)supportedInterfaceOrientations;
-(BOOL)shouldAutorotate;

@end
