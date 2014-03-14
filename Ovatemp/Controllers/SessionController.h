//
//  SessionController.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionController : NSObject

+ (void)loggedInWithUser:(NSDictionary *)user andToken:(NSString *)token;
+ (void)loadSupplementsEtc:(NSDictionary *)response;
+ (void)refresh;
+ (void)logOut;
+ (BOOL)loggedIn;

@end
