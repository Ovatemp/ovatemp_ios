//
//  CoachingDataStore.m
//  Ovatemp
//
//  Created by Daniel Lozano on 6/4/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "CoachingDataStore.h"

@interface CoachingDataStore ()

@property (nonatomic) NSMutableDictionary *dataStore;
@property (nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation CoachingDataStore

+ (id)sharedSession
{
    static CoachingDataStore *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[CoachingDataStore alloc] init];
        //_instance.dataStore = [[NSMutableDictionary alloc] init];
    });
    return _instance;
}

#pragma mark - Public Methods

- (void)getStatusForDate:(NSDate *)date withCompletion:(CoachingCompletionBlock)completion;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dateString = [self.dateFormatter stringFromDate: date];
        NSMutableDictionary *selectedDate = self.dataStore[dateString];
        if (!selectedDate) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NO);
            });
        }
        
        for (int i = 0; i < 4; i++) {
            NSNumber *typeNumber = [NSNumber numberWithInt: i];
            NSString *typeString = [NSString stringWithFormat: @"%@", typeNumber];
            NSNumber *boolNumber = selectedDate[typeString];
            if (!boolNumber) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(NO);
                });
                return;
            }
            BOOL status = [boolNumber boolValue];
            if (!status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(NO);
                });
                return;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(YES);
        });
        
    });
    
}

- (void)getStatusForActivityType:(ILActivityType)type forDate:(NSDate *)date withCompletion:(CoachingCompletionBlock)completion
{
//    DDLogError(@"DATA STORE: %@", self.dataStore);
//    DDLogWarn(@"GET STATUS FOR ACTIVITY TYPE: %ld", (long)type);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dateString = [self.dateFormatter stringFromDate: date];
        NSMutableDictionary *selectedDate = self.dataStore[dateString];
        if (!selectedDate) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NO);
            });
        }
        
        NSNumber *typeNumber = [NSNumber numberWithInt: type];
        NSString *typeString = [NSString stringWithFormat: @"%@", typeNumber];
        NSNumber *boolNumber = selectedDate[typeString];
        if (!boolNumber) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NO);
            });
        }
        
        BOOL status = [boolNumber boolValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(status);
        });
        
    });
    
}

- (void)setStatus:(BOOL)status forActivityType:(ILActivityType)type forDate:(NSDate *)date withCompletion:(CoachingErrorCompletionBlock)completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSString *dateString = [self.dateFormatter stringFromDate: date];
        NSMutableDictionary *selectedDate = self.dataStore[dateString];
        if (!selectedDate) {
            selectedDate = [[NSMutableDictionary alloc] init];
            self.dataStore[dateString] = selectedDate;
        }
        
        NSNumber *typeNumber = [NSNumber numberWithInt: type];
        NSString *typeString = [NSString stringWithFormat: @"%@", typeNumber];
        NSNumber *boolNumber = [NSNumber numberWithBool: status];
        
        selectedDate[typeString] = boolNumber;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil);
        });
        
        [self saveDataStore];
        
    });
    
}

#pragma mark - Set/Get

- (NSMutableDictionary *)dataStore
{
    if (!_dataStore) {
        _dataStore = [self getDataStoreFromDisk];
    }
    return _dataStore;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

#pragma mark - Persistance

- (void)reloadDataStore
{
    self.dataStore = [self getDataStoreFromDisk];
}

- (void)saveDataStore
{
    [self saveDataStoreToDisk: self.dataStore];
}

- (NSMutableDictionary *)getDataStoreFromDisk
{
    DDLogInfo(@"COACHING DATA STORE : GETTING DATA FROM DISK");

    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSString *path = [rootPath stringByAppendingPathComponent: @"CoachingDataStore.plist"];
    
    NSData *plistData = [NSData dataWithContentsOfFile: path];
    
    if (!plistData) {
        return [[NSMutableDictionary alloc] init];
    }
    
    NSError *error;
    NSPropertyListFormat format;
    id plist;
    
    plist = [NSPropertyListSerialization propertyListWithData: plistData
                                                      options: NSPropertyListMutableContainers
                                                       format: &format
                                                        error: &error];
    
    if (!plist) {
        DDLogError(@"ERROR : %@", error);
    }
    
    return plist;
}

- (void)saveDataStoreToDisk:(NSDictionary *)dataStore
{
    DDLogInfo(@"COACHING DATA STORE : SAVING DATA TO DISK");
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSString *path = [rootPath stringByAppendingPathComponent: @"CoachingDataStore.plist"];
    
    NSData *xmlData;
    NSError *error;
    
    xmlData = [NSPropertyListSerialization dataWithPropertyList: dataStore
                                                         format: NSPropertyListXMLFormat_v1_0
                                                        options: 0
                                                          error: &error];
    
    if (xmlData) {
        [xmlData writeToFile: path atomically: YES];
    }else{
        DDLogError(@"ERROR : %@", error);
    }
}

@end
