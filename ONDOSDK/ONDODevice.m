//
//  ONDODevice.m
//  Ovatemp
//
//  Created by Flip Sasser on 9/10/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "ONDODevice.h"
#import <CoreBluetooth/CBUUID.h>

static NSManagedObjectContext *kONDOManagedObjectContext;
static NSManagedObjectModel *kONDOManagedObjectModel;
static NSPersistentStoreCoordinator *kONDOPersistentStoreCoordinator;

@interface ONDODevice ()

@property (readonly, weak) NSManagedObjectContext *managedObjectContext;

+ (NSManagedObjectContext *)managedObjectContext;
+ (NSManagedObjectModel *)managedObjectModel;
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

@end

@implementation ONDODevice

@dynamic createdAt;
@dynamic name;
@dynamic uuidString;

# pragma mark - Find and create

+ (NSArray *)all {
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.description];
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
  request.sortDescriptors = @[sort];

  NSError *error = nil;
  NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];

  if (error) {
    NSLog(@"Couldn't fetch results: %@", error);
    return @[];
  }

  return results;
}

+ (ONDODevice *)findOrCreate:(NSString *)uuidString {
  ONDODevice *device = [self find:uuidString];
  if (!device) {
    device = [self create:uuidString];
  }
  return device;
}

+ (ONDODevice *)create:(NSString *)uuidString {
  NSManagedObjectContext *context = [self managedObjectContext];
  ONDODevice *device = [NSEntityDescription insertNewObjectForEntityForName:self.description
                                                     inManagedObjectContext:self.managedObjectContext];

  device.uuidString = uuidString;
  device.createdAt = [NSDate date];

  NSError *error;
  if (![context save:&error]) {
    NSLog(@"Couldn't save: %@", error);
    return nil;
  }

  return device;
}

+ (ONDODevice *)find:(NSString *)uuidString {
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.description];
  request.fetchLimit = 1;
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuidString == %@", uuidString];
  request.predicate = predicate;
  NSManagedObjectContext *context = self.managedObjectContext;
  NSError *error = nil;
  NSArray *results = [context executeFetchRequest:request error:&error];
  if (error) {
    NSLog(@"Cound't find a thing");
    return nil;
  } else {
    return results.firstObject;
  }
//  request.entity = resultEntity;
  //  request.

  //  NSArray *quizResults = [managedObjectContext executeFetchRequest:allQuizResultsRequest error:&error];
  return nil;
}

# pragma mark - Properties

- (CBUUID *)uuid {
  return [CBUUID UUIDWithString:self.uuidString];
}

# pragma mark - Core data

// Returns the URL to the application's Documents directory.
+ (NSURL *)applicationDocumentsDirectory {
  return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
}

+ (NSManagedObjectContext *)managedObjectContext {
  if (!kONDOManagedObjectContext) {
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator != nil) {
      kONDOManagedObjectContext = [[NSManagedObjectContext alloc] init];
      [kONDOManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
  }
  return kONDOManagedObjectContext;
}

+ (NSManagedObjectModel *)managedObjectModel {
  if (!kONDOManagedObjectModel) {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ONDO" withExtension:@"momd"];
    kONDOManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  }
  return kONDOManagedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (kONDOPersistentStoreCoordinator != nil) {
    return kONDOPersistentStoreCoordinator;
  }

  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ONDO.sqlite"];

  NSError *error = nil;
  kONDOPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  if (![kONDOPersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                     configuration:nil
                                                               URL:storeURL
                                                           options:nil
                                                             error:&error]) {
    /*
     Replace this implementation with code to handle the error appropriately.

     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

     Typical reasons for an error here include:
     * The persistent store is not accessible;
     * The schema for the persistent store is incompatible with current managed object model.
     Check the error message to determine what the actual problem was.


     If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.

     If you encounter schema incompatibility errors during development, you can reduce their frequency by:
     * Simply deleting the existing store:
     [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]

     * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
     @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}

     Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.

     */
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }

  return kONDOPersistentStoreCoordinator;
}

- (void)delete {
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext) {
    [managedObjectContext deleteObject:self];
    [self save];
  }
}

- (void)save {
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}

- (NSManagedObjectContext *)managedObjectContext {
  return [[self class] managedObjectContext];
}

@end
