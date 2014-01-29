//
//  User.h
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "BaseModel.h"

@interface User : BaseModel

+ (User *)current;

@property NSString *email;

@end
