//
//  ILPaginationInfo.h
//  Ovatemp
//
//  Created by Daniel Lozano on 4/27/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILPaginationInfo : NSObject

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic) NSNumber *perPage;
@property (nonatomic) NSNumber *totalPages;
@property (nonatomic) NSNumber *totalObjects;

@end
