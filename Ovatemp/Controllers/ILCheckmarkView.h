//
//  ILCheckmarkView.h
//  Ovatemp
//
//  Created by Daniel Lozano on 6/15/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface ILCheckmarkView : UIView

@property (nonatomic) IBInspectable BOOL isChecked;
@property (nonatomic) IBInspectable BOOL largeSize;

@end
