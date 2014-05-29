//
//  ONDODevice.h
//  Ovatemp
//
//  Created by Flip Sasser on 9/10/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CBUUID;

@interface ONDODevice : NSManagedObject

+ (NSArray *)all;
+ (ONDODevice *)findOrCreate:(NSString *)uuidString;
+ (ONDODevice *)create:(NSString *)uuidString;
+ (ONDODevice *)find:(NSString *)uuidString;

@property NSDate *createdAt;
@property NSString *name;
@property NSString *uuidString;
@property (readonly) CBUUID *uuid;

- (void)delete;
- (void)save;

@end
