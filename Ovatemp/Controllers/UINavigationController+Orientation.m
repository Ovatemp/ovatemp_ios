//
//  UINavigationController+Orientation.m
//  Ovatemp
//
//  Created by Daniel Lozano on 5/13/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "UINavigationController+Orientation.h"

@implementation UINavigationController (Orientation)

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate
{
    return YES;
}

@end
