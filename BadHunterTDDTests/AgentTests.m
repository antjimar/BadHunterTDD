//
//  AgentTests.m
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 5/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Agent+Model.h"


@interface AgentTests : XCTestCase {
    // Core Data stack objects.
    NSManagedObjectModel *model;
    NSPersistentStoreCoordinator *coordinator;
    NSPersistentStore *store;
    NSManagedObjectContext *context;
    // Object to test.
    Agent *sut;
}

@end


@implementation AgentTests

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
}


- (void) createSut {
    sut = [Agent agentInMOC:context];
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


#pragma mark - Appraisal

- (void) testAppraisalValueIsCalculatedFromDestPowerAndMotivation {
    sut.destructionPower = @3;
    sut.motivation = @4;
    
    XCTAssertEqual([sut.appraisal unsignedIntegerValue], (NSUInteger)3,
                   @"Appraisal should be calculated from destruction power and motivation.");
}


- (void) testAppraisalValueIsCalculatedFromOtherDestPowerAndMotivation {
    sut.destructionPower = @1;
    sut.motivation = @2;
    
    XCTAssertEqual([sut.appraisal unsignedIntegerValue], (NSUInteger)1,
                   @"Appraisal should be calculated from destruction power and motivation.");
}


- (void) testAppraisalAccessIsNotified {
    sut.destructionPower = @2;
    sut.motivation = @4;
    id sutMock = OCMPartialMock(sut);
    OCMExpect([sutMock willAccessValueForKey:agentPropertyAppraisal]);
    OCMExpect([sutMock didAccessValueForKey:agentPropertyAppraisal]);
    
    [sutMock appraisal];
    
    XCTAssertNoThrow(OCMVerifyAll(sutMock), @"Appraisal access must be notified.");
}


- (void) testAppraisalDependenciesAreDeclared {
    NSSet *dependencies = [Agent keyPathsForValuesAffectingAppraisal];

    XCTAssertNotNil(dependencies, @"Appraisal dependencies must be declared in the model.");
}


- (void) testAppraisalDependenciesIncludesDestructionPower {
    NSSet *dependencies = [Agent keyPathsForValuesAffectingAppraisal];
    
    XCTAssertTrue([dependencies containsObject:agentPropertyDestructionPower],
                  @"Appraisal dependencies must include destruction power.");
}


- (void) testAppraisalDependenciesIncludesMotivation {
    NSSet *dependencies = [Agent keyPathsForValuesAffectingAppraisal];
    
    XCTAssertTrue([dependencies containsObject:agentPropertyMotivation],
                  @"Appraisal dependencies must include motivation.");
}


#pragma mark - Picture logic

- (void) testGeneratedPictureUUIDIsNotNil {
    XCTAssertNotNil([sut generatePictureUUID], @"Generated picture UUID must not be nil.");
}

@end
