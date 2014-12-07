//
//  CoreDataTestCase.h
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 7/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>


@interface CoreDataTestCase : XCTestCase {
    // Core Data stack objects.
    NSManagedObjectModel *model;
    NSPersistentStoreCoordinator *coordinator;
    NSPersistentStore *store;
    NSManagedObjectContext *context;
}

- (void) createCoreDataStack;
- (void) createFixture;
- (void) releaseCoreDataStack;
- (void) releaseFixture;

@end
