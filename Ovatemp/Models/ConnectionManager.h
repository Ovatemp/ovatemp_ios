//
//  ConnectionManager.h
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ConnectionManagerFailure) (NSError *error);
typedef void (^ConnectionManagerSuccess) (id response);

@interface ConnectionManager : NSObject <NSURLConnectionDataDelegate>

# pragma mark - Class Methods
+ (ConnectionManager *)sharedConnectionManager;
+ (void)get:(NSString *)url success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure;
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure;
+ (void)get:(NSString *)url target:(id)target success:(SEL)onSuccess failure:(SEL)onFailure;
+ (void)get:(NSString *)url params:(NSDictionary *)params target:(id)target success:(SEL)onSuccess failure:(SEL)onFailure;

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure;
+ (void)post:(NSString *)url params:(NSDictionary *)params target:(id)target success:(SEL)onSuccess failure:(SEL)onFailure;

# pragma mark - Building query strings

- (NSString *)queryStringForDictionary:(NSDictionary *)params;

# pragma mark - Creating requests
- (void)get:(NSString *)url params:(NSDictionary *)params success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure;
- (void)get:(NSString *)url params:(NSDictionary *)params target:(id)target success:(SEL)onSuccess failure:(SEL)onFailure;
- (void)post:(NSString *)url params:(NSDictionary *)params success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure;
- (void)post:(NSString *)url params:(NSDictionary *)params target:(id)target success:(SEL)onSuccess failure:(SEL)onFailure;

@end