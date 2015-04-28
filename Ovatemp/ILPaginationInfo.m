//
//  ILPaginationInfo.m
//  Ovatemp
//
//  Created by Daniel Lozano on 4/27/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILPaginationInfo.h"

@implementation ILPaginationInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init]; if(!self) return nil;
    
    self.perPage = dictionary[@"per_page"];
    self.totalPages = dictionary[@"total_pages"];
    self.totalObjects = dictionary[@"total_objects"];
    
    return self;
}

@end
