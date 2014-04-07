//
//  Question.h
//  Ovatemp
//
//  Created by Chris Cahoon on 3/26/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "BaseModel.h"
#import "ConnectionManager.h"

@interface Question : BaseModel

@property BOOL answer;
@property BOOL answered;
@property (nonatomic, strong) NSString *text;

- (void)answer:(BOOL)yes success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure;

@end
