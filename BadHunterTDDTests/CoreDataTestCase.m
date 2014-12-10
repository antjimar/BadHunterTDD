//
//  CoreDataTestCase.m
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 7/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "CoreDataTestCase.h"



@implementation CoreDataTestCase

#pragma mark - Set up and tear down

- (void) setUp {
    [super setUp];
    
    [self createCoreDataStack];
    [self createFixture];
}


- (void) createCoreDataStack {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    model = [NSManagedObjectModel mergedModelFromBundles:@[bundle]];
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    store = [coordinator addPersistentStoreWithType: NSInMemoryStoreType
                                      configuration: nil
                                                URL: nil
                                            options: nil
                                              error: NULL];
    context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = coordinator;
}


- (void) createFixture {
    // Test data
}


- (void) tearDown {
    [self releaseFixture];
    [self releaseCoreDataStack];
    
    [super tearDown];
}


- (void) releaseFixture {
    
}


- (void) releaseCoreDataStack {
    context = nil;
    store = nil;
    coordinator = nil;
    model = nil;
}

@end
