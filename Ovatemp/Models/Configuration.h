//
//  Configuration.h
//  Ovatemp
//
//  Created by Flip Sasser on 1/29/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject

@property NSString *token;

+ (Configuration *)sharedConfiguration;

@end
