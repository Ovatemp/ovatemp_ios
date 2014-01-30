//
//  ConnectionManager.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "ConnectionManager.h"

static ConnectionManager *kSharedConnectionManager;
static NSString * const kConnectionKey = @"Connection";
static NSString * const kDataKey = @"Data";
static NSString * const kDeviceIDParam = @"device_id";
static NSString * const kErrorMessageKey = @"error";
static NSString * const kFailureBlockKey = @"FailureBlock";
static NSString * const kFailureSelectorKey = @"FailureSelector";
static NSString * const kFormatKey = @"Format";
static NSString * const kStatusKey = @"Status";
static NSString * const kSuccessBlockKey = @"SuccessBlock";
static NSString * const kSuccessSelectorKey = @"SuccessSelector";
static NSString * const kTargetKey = @"Target";
static NSString * const kTokenParam = @"token";

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
  [[self sharedConnectionManager] get:url
                               params:params
                              success:onSuccess
                              failure:onFailure];
}

+ (void)get:(NSString *)url params:(NSDictionary *)params target:(id)target success:(SEL)onSuccess failure:(SEL)onFailure {
  [[self sharedConnectionManager] get:url
                               params:params
                               target:target
                              success:onSuccess
                              failure:onFailure];
}

+ (void)get:(NSString *)url success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure {
  [self get:url params:nil success:onSuccess failure:onFailure];
}

+ (void)get:(NSString *)url target:(id)target success:(SEL)onSuccess failure:(SEL)onFailure {
  [self get:url params:nil target:target success:onSuccess failure:onFailure];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure {
  [[self sharedConnectionManager] post:url
                                params:params
                               success:onSuccess
                               failure:onFailure];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params target:(id)target success:(SEL)onSuccess failure:(SEL)onFailure {
  [[self sharedConnectionManager] post:url
                                params:params
                                target:target
                               success:onSuccess
                               failure:onFailure];
}

# pragma mark - Request management

- (NSMutableDictionary *)configForRequest:(NSURLRequest *)request {
  if (!_requests) {
    _requests = [NSMutableDictionary dictionary];
  }

  NSString *identifier = [self identifierForRequest:request];
  NSMutableDictionary *config = [_requests objectForKey:identifier];
  if (!config) {
    config = [NSMutableDictionary dictionaryWithCapacity:9];
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

- (NSMutableURLRequest *)buildRequestForURL:(NSString *)url {
  NSRange protocolRange = [url rangeOfString:@"http"];
  if (protocolRange.location != 0) {
    url = [API_URL stringByAppendingString:url];
  }
  return [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
}

- (NSMutableURLRequest *)getRequestForURL:(NSString *)url params:(NSDictionary *)params {
  NSString *queryString = [self queryStringForDictionary:params];
  NSRange queryStringRange = [url rangeOfString:@"?"];
  if (queryStringRange.location == NSNotFound) {
    url = [url stringByAppendingFormat:@"?%@", queryString];
  } else {
    url = [url stringByAppendingFormat:@"&%@", queryString];
  }

  NSMutableURLRequest *request = [self buildRequestForURL:url];
  request.HTTPMethod = @"GET";
  return request;
}

- (NSMutableURLRequest *)postRequestForURL:(NSString *)url params:(NSDictionary *)params {
  NSMutableURLRequest *request = [self buildRequestForURL:url];
  request.HTTPMethod = @"POST";
  [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

  NSString *queryString = [self queryStringForDictionary:params];
  NSData *data = [queryString dataUsingEncoding:NSUTF8StringEncoding];
  request.HTTPBody = data;

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
  NSMutableDictionary *extraParams = [@{kDeviceIDParam: DEVICE_ID} mutableCopy];
  NSString *token = [Configuration sharedConfiguration].token;
  if (token) {
    [extraParams setObject:token forKey:kTokenParam];
  }

  NSMutableDictionary *newParams;
  if (params) {
    newParams = [params mutableCopy];
    [newParams addEntriesFromDictionary:newParams];
  } else {
    newParams = extraParams;
  }

  NSMutableString *queryString = [NSMutableString string];
  for (NSString *key in newParams) {
    if (queryString.length) {
      [queryString appendString:@"&"];
    }
    [queryString appendString:[self paramForKey:key value:newParams[key]]];
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

  NSInteger status = [[config objectForKey:kStatusKey] integerValue];
  if (status >= 400 && !parseError) {
    if (response && ![response isKindOfClass:[NSDictionary class]]) {
      response = @{@"response": response};
    }
    parseError = [[NSError alloc] initWithDomain:@"OvatempAPIErrorDomain" code:status userInfo:response];
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
  if (![config objectForKey:kStatusKey]) {
    NSInteger status = ((NSHTTPURLResponse *)response).statusCode;
    [config setObject:@(status) forKey:kStatusKey];
  }
}


@end
