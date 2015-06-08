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
    });
    return _instance;
}

#pragma mark - Public Methods

- (BOOL)getStatusForActivityType:(ILActivityType)type forDate:(NSDate *)date withCompletion:(CompletionBlock)completion
{
    NSString *dateString = [self.dateFormatter stringFromDate: date];
    NSMutableDictionary *selectedDate = self.dataStore[dateString];
    if (!selectedDate) {
        return NO;
    }
    
    NSNumber *typeNumber = [NSNumber numberWithInt: type];
    NSNumber *boolNumber = selectedDate[typeNumber];
    if (!boolNumber) {
        return NO;
    }
    
    BOOL status = [boolNumber boolValue];
    
    return status;
}

- (void)setStatus:(BOOL)status forActivityType:(ILActivityType)type forDate:(NSDate *)date withCompletion:(ErrorCompletionBlock)completion
{
    NSString *dateString = [self.dateFormatter stringFromDate: date];
    NSMutableDictionary *selectedDate = self.dataStore[dateString];
    if (!selectedDate) {
        selectedDate = [[NSMutableDictionary alloc] init];
    }
    
    NSNumber *typeNumber = [NSNumber numberWithInt: type];
    NSNumber *boolNumber = [NSNumber numberWithBool: status];
 
    selectedDate[typeNumber] = boolNumber;
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
    NSString *path = [[NSBundle mainBundle] pathForResource: @"CoachingDataStore" ofType: @"plist"];
    NSData *plistData = [NSData dataWithContentsOfFile: path];
    
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
    NSString *path = [[NSBundle mainBundle] pathForResource: @"CoachingDataStore" ofType: @"plist"];
    
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
