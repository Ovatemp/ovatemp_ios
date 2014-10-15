//
//  Configuration.h
//  Ovatemp
//
//  Created by Flip Sasser on 1/29/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSNumber *hasSeenProfileIntroScreen;
@property (strong, nonatomic) NSDictionary *coachingContentUrls;

+ (Configuration *)sharedConfiguration;
+ (void)loggedInWithResponse:(NSDictionary *)response;
+ (BOOL)loggedIn;
+ (void)logOut;

@end
