//
//  DomainTests.m
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 6/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "Domain+Model.h"
#import "Agent+Model.h"


@interface DomainTests : XCTestCase {
    // Core Data stack objects.
    NSManagedObjectModel *model;
    NSPersistentStoreCoordinator *coordinator;
    NSPersistentStore *store;
    NSManagedObjectContext *context;
    // Object to test.
    Domain *sut;
    // Other objects
    Domain *domain1;
}

@end


@implementation DomainTests

#pragma mark - Constants & Parameters

static NSString *const domainMainName = @"domain1";
static NSString *const domainAltName = @"domain2";


#pragma mark - Set up and tear down

- (void) setUp {
    [super setUp];

    [self createCoreDataStack];
    [self createFixture];
    [self createSut];
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
    domain1 = [Domain domainInMOC:context withName:domainAltName];
}


- (void) createSut {
    sut = [Domain domainInMOC:context withName:domainMainName];
}


- (void) tearDown {
    [self releaseSut];
    [self releaseFixture];
    [self releaseCoreDataStack];

    [super tearDown];
}


- (void) releaseSut {
    sut = nil;
}


- (void) releaseFixture {
    domain1 = nil;
}


- (void) releaseCoreDataStack {
    context = nil;
    store = nil;
    coordinator = nil;
    model = nil;
}


#pragma mark - Basic test

- (void) testObjectIsNotNil {
    XCTAssertNotNil(sut, @"The object to test must be created in setUp.");
}


#pragma mark - Data persistence

- (void) testConvenienceConstructorPreservesName {
    XCTAssertEqual(sut.name, domainMainName,
                   @"Domain convenience constructor must preserve name.");
}


- (void) testConvenienceConstructorPreservesAltName {
    Domain *altSut = [Domain domainInMOC:context withName:domainAltName];
    XCTAssertEqual(altSut.name, domainAltName,
                   @"Domain convenience constructor must preserve name.");
}


#pragma mark - Fetches

- (void) testFetchesDomainWithGivenName {
    XCTAssertEqual([Domain fetchInMOC:context withName:domainMainName], sut,
                   @"Fetch Domain with name must retrieve the right object.");
}


- (void) testFetchForControlledDomainsIsNotNil {
    XCTAssertNotNil([Domain fetchForControlledDomains],
                    @"Fetch request for controlled domains must not be nil.");
}


- (void) testFetchForControlledDomainsQueriesDomainEntity {
    NSFetchRequest *fetchRequest = [Domain fetchForControlledDomains];

    XCTAssertEqualObjects(fetchRequest.entityName, domainEntityName,
                          @"Fetch request for controlled domains must query domain entities.");
}


- (void) testFetchForControlledDomainsUsesProperPredicate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SUBQUERY(agents,$x,$x.%K >= 3)).@count > 1",
                              agentPropertyDestructionPower];
    NSFetchRequest *fetchRequest = [Domain fetchForControlledDomains];

    XCTAssertEqualObjects(fetchRequest.predicate, predicate,
                          @"Fetch request for controlled domains must use the proper predicate.");
}

@end
