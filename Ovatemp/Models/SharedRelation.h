//
//  SharedRelation.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/24/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "BaseModel.h"

@interface SharedRelation : BaseModel

@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) BOOL belongsToAllUsers;

@end
