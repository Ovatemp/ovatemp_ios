//
//  NSDateExtensions.swift
//  Ovatemp
//
//  Created by Arun Venkatesan on 1/27/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

import Foundation

extension NSDate {
    
    + (NSDate*)dateJSONTransformer:(NSString*)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZZZ"];
    return [dateFormatter dateFromString:dateString];
    }
    
    func dateJSON
}
