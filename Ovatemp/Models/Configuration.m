//
//  Configuration.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/29/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Configuration.h"

static Configuration *_sharedConfiguration;

@implementation Configuration

# pragma mark - Setup

+ (Configuration *)sharedConfiguration {
  if (!_sharedConfiguration) {
    _sharedConfiguration = [[self alloc] init];
    [_sharedConfiguration observeKeys:@[@"token"]];
  }
  return _sharedConfiguration;
}

- (void)observeKeys:(NSArray *)keys {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  for (NSString *key in keys) {
    id value = [userDefaults objectForKey:key];
    [self setValue:value forKey:key];
    [self addObserver:self forKeyPath:key options:0 context:nil];
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  id value = [self valueForKey:keyPath];
  [userDefaults setObject:value forKey:keyPath];
  [userDefaults synchronize];
}

@end
