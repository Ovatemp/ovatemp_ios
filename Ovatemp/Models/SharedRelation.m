//
//  SharedRelation.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/24/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SharedRelation.h"

@implementation SharedRelation

- (id)init {
  self = [super init];
  if(!self) {
    return nil;
  }

  self.ignoredAttributes = [NSSet setWithArray:@[@"createdAt", @"updatedAt", @"userId"]];

  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ (%@): %@ [%@ to all users]", [self class], self.id, self.name, self.belongsToAllUsers ? @"belongs" : @"doesn't belong"];
}

+ (void)createWithName:(NSString *)name success:(ConnectionManagerSuccess)onSuccess
{
  NSString *className = [[self description] lowercaseString];
  NSString *classNamePlural = [className stringByAppendingString:@"s"];

  [ConnectionManager post:[@"/" stringByAppendingString:classNamePlural]
                   params:@{
                            className:
                              @{
                                @"name":name
                                }
                            }
                  success:^(NSDictionary *response) {
                    [self.class withAttributes:response[className]];
                    if(onSuccess) {
                      onSuccess(response);
                    }
                  }
                  failure:^(NSError *error) {
                    // HANDLEERROR
                    NSLog(@"failed to create %@", className);
                  }
   ];
}

@end