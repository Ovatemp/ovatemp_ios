//
//  ConnectionManager.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "ConnectionManager.h"

static ConnectionManager *kSharedConnectionManager;
static const NSString *kConnectionKey = @"Connection";
static const NSString *kDataKey = @"Data";
static const NSString *kFailureBlockKey = @"FailureBlock";
static const NSString *kFailureSelectorKey = @"FailureSelector";
static const NSString *kFormatKey = @"Format";
static const NSString *kSuccessBlockKey = @"SuccessBlock";
static const NSString *kSuccessSelectorKey = @"SuccessSelector";
static const NSString *kTargetKey = @"Target";

@interface ConnectionManager () {
  NSMutableDictionary *_requests;
}

- (NSMutableDictionary *)configForRequest:(NSURLRequest *)request;
- (void)endRequest:(NSURLRequest *)request;
- (void)endRequestsFrom:(id)target;
- (NSString *)identifierForRequest:(NSURLRequest *)request;

- (NSMutableURLRequest *)getRequestForURL:(NSString *)url params:(NSDictionary *)params;
- (NSMutableURLRequest *)postRequestForURL:(NSString *)url params:(NSDictionary *)params;

@end

@implementation ConnectionManager

# pragma mark - Class Methods

+ (ConnectionManager *)sharedConnectionManager {
  if (!kSharedConnectionManager) {
    kSharedConnectionManager = [[self alloc] init];
  }
  return kSharedConnectionManager;
}

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure {

}

+ (void)get:(NSString *)url params:(NSDictionary *)params target:(id)target success:(SEL)onSuccess failure:(SEL)onFailure {

}

+ (void)get:(NSString *)url success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure {

}

+ (void)get:(NSString *)url target:(id)target success:(SEL)onSuccess failure:(SEL)onFailure {

}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure {

}

+ (void)post:(NSString *)url params:(NSDictionary *)params target:(id)target success:(SEL)onSuccess failure:(SEL)onFailure {

}

# pragma mark - Request management

- (NSMutableDictionary *)configForRequest:(NSURLRequest *)request {
  if (!_requests) {
    _requests = [NSMutableDictionary dictionary];
  }

  NSString *identifier = [self identifierForRequest:request];
  NSMutableDictionary *config = [_requests objectForKey:identifier];
  if (!config) {
    config = [NSMutableDictionary dictionaryWithCapacity:6];
    [_requests setObject:config forKey:identifier];
  }
  return config;
}

- (NSString *)identifierForRequest:(NSURLRequest *)request {
  return [NSString stringWithFormat:@"%@:%@", request.URL.absoluteString, request.HTTPMethod];
}

- (void)endRequest:(NSURLRequest *)request {
  NSString *identifier = [self identifierForRequest:request];
  [_requests removeObjectForKey:identifier];
}

- (void)endRequestsFrom:(id)target {
  for (NSString *key in _requests) {
    NSMutableDictionary *config = [_requests objectForKey:key];
    if ([[config objectForKey:kTargetKey] isEqual:target]) {
      NSURLConnection *connection = [config objectForKey:kConnectionKey];
      [connection cancel];
      [self endRequest:connection.originalRequest];
    }
  }
}

# pragma mark - Building requests

- (NSMutableURLRequest *)getRequestForURL:(NSString *)url params:(NSDictionary *)params {
  if (params) {
    NSString *queryString = [self queryStringForDictionary:params];
    NSRange queryStringRange = [url rangeOfString:@"?"];
    if (queryStringRange.location == NSNotFound) {
      url = [url stringByAppendingFormat:@"?%@", queryString];
    } else {
      url = [url stringByAppendingFormat:@"&%@", queryString];
    }
  }

  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
  request.HTTPMethod = @"GET";
  return request;
}

- (NSMutableURLRequest *)postRequestForURL:(NSString *)url params:(NSDictionary *)params {
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
  request.HTTPMethod = @"POST";
  [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

  if (params) {
    NSString *queryString = [self queryStringForDictionary:params];
    NSData *data = [queryString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
  }
  return request;
}

# pragma mark - Building query strings

- (NSString *)arrayParamForKey:(NSString *)key value:(NSArray *)value {
  NSMutableString *keyValuePairs = [NSMutableString string];

  for (id subvalue in value) {
    if (keyValuePairs.length) {
      [keyValuePairs appendString:@"&"];
    }

    NSString *nestedKey = [key stringByAppendingString:@"[]"];
    NSString *nestedKeyValue = [self paramForKey:nestedKey value:subvalue];
    [keyValuePairs appendString:nestedKeyValue];
  }
  return keyValuePairs;
}

- (NSString *)dictionaryParamForKey:(NSString *)key value:(NSDictionary *)value {
  NSMutableString *keyValuePairs = [NSMutableString string];

  for (NSString *subkey in value) {
    if (keyValuePairs.length) {
      [keyValuePairs appendString:@"&"];
    }

    id subvalue = value[subkey];
    NSString *nestedKey = [NSString stringWithFormat:@"%@[%@]", key, subkey];
    NSString *nestedKeyValue = [self paramForKey:nestedKey value:subvalue];
    [keyValuePairs appendString:nestedKeyValue];
  }
  return keyValuePairs;
}

- (NSString *)paramForKey:(NSString *)key value:(id)value {
  if ([value isKindOfClass:[NSDictionary class]]) {
    return [self dictionaryParamForKey:key value:value];
  } else if ([value isKindOfClass:[NSArray class]]) {
    return [self arrayParamForKey:key value:value];
  }
  key = [key stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
  value = [value stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
  return [NSString stringWithFormat:@"%@=%@", key, value];
}

- (NSString *)queryStringForDictionary:(NSDictionary *)params {
  NSMutableString *queryString = [NSMutableString string];
  for (NSString *key in params) {
    if (queryString.length) {
      [queryString appendString:@"&"];
    }
    [queryString appendString:[self paramForKey:key value:params[key]]];
  }
  return queryString;
}

# pragma mark - Sending requests

- (void)get:(NSString *)url params:(NSDictionary *)params success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure {
  NSMutableURLRequest *request = [self getRequestForURL:url params:params];
  [self startRequest:request withOptions:@{kFailureBlockKey: onFailure, kSuccessBlockKey: onSuccess}];
}

- (void)get:(NSString *)url params:(NSDictionary *)params target:(id)target success:(SEL)onSuccess failure:(SEL)onFailure {
  NSMutableURLRequest *request = [self getRequestForURL:url params:params];
  NSString *onSuccessValue = NSStringFromSelector(onSuccess);
  NSString *onFailureValue = NSStringFromSelector(onFailure);
  [self startRequest:request withOptions:@{
                                           kFailureSelectorKey: onFailureValue,
                                           kSuccessSelectorKey: onSuccessValue,
                                           kTargetKey: target
                                           }];
}

- (void)post:(NSString *)url params:(NSDictionary *)params success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure {
  NSMutableURLRequest *request = [self postRequestForURL:url params:params];
  [self startRequest:request withOptions:@{kFailureBlockKey: onFailure, kSuccessBlockKey: onSuccess}];
}

- (void)post:(NSString *)url params:(NSDictionary *)params target:(id)target success:(SEL)onSuccess failure:(SEL)onFailure {
  NSMutableURLRequest *request = [self postRequestForURL:url params:params];
  NSString *onSuccessValue = NSStringFromSelector(onSuccess);
  NSString *onFailureValue = NSStringFromSelector(onFailure);
  [self startRequest:request withOptions:@{
                                           kFailureSelectorKey: onFailureValue,
                                           kSuccessSelectorKey: onSuccessValue,
                                           kTargetKey: target
                                           }];
}

- (void)startRequest:(NSMutableURLRequest *)request withOptions:(NSDictionary *)options {
  request.allowsCellularAccess = YES;

  NSMutableDictionary *config = [self configForRequest:request];
  [config addEntriesFromDictionary:options];

  // Cancel duplicate requests
  NSURLConnection *connection = [config objectForKey:kConnectionKey];
  if (connection) {
    [connection cancel];
  }

  connection = [NSURLConnection connectionWithRequest:request delegate:self];
  [config setObject:connection forKey:kConnectionKey];
}

# pragma mark - NSURLConnection delegate methods

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSDictionary *config = [self configForRequest:connection.originalRequest];
  NSData *data = [config objectForKey:kDataKey];
  NSString *format = [config objectForKey:kFormatKey];
  __strong NSError *parseError;
  id response;

  if ([format hasPrefix:@"application/json"]) {
    response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
  } else {
    response = data;
  }

  if (parseError) {
    [self connection:connection didFailWithError:parseError];
  } else {
    [self endRequest:connection.originalRequest];
    if ([config objectForKey:kSuccessBlockKey]) {
      ConnectionManagerSuccess onSuccess = [config objectForKey:kSuccessBlockKey];
      onSuccess(response);
    } else if ([config objectForKey:kTargetKey] && [config objectForKey:kSuccessSelectorKey]) {
      SEL onSuccess = NSSelectorFromString([config objectForKey:kSuccessSelectorKey]);
      [[config objectForKey:kTargetKey] performSelectorOnMainThread:onSuccess withObject:response waitUntilDone:NO];
    }
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  NSMutableDictionary *config = [self configForRequest:connection.originalRequest];
  NSMutableData *fullData = [config objectForKey:kDataKey];
  if (fullData) {
    [fullData appendData:data];
  } else {
    fullData = [NSMutableData dataWithData:data];
    [config setObject:fullData forKey:kDataKey];
  }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSMutableDictionary *config = [self configForRequest:connection.originalRequest];
  [self endRequest:connection.originalRequest];
  if ([config objectForKey:kFailureBlockKey]) {
    ConnectionManagerFailure onFailure = [config objectForKey:kFailureBlockKey];
    onFailure(error);
  } else if ([config objectForKey:kTargetKey] && [config objectForKey:kFailureSelectorKey]) {
    SEL onFailure = NSSelectorFromString([config objectForKey:kFailureSelectorKey]);
    [[config objectForKey:kTargetKey] performSelectorOnMainThread:onFailure withObject:error waitUntilDone:NO];
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  NSMutableDictionary *config = [self configForRequest:connection.originalRequest];
  if (![config objectForKey:kFormatKey]) {
    NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
    NSString *contentType = [headers objectForKey:@"Content-Type"];
    [config setObject:contentType forKey:kFormatKey];
  }
}


@end
