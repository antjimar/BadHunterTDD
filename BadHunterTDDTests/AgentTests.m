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


- (void) testGeneratedPictureUUIDIsLongerThanTen {
    XCTAssertTrue([[sut generatePictureUUID] length] > 10,
                  @"Generated picture UUID length must be longer than 10.");
}


- (void) testGeneratedPictureUUIDMustBeDifferentEachTime {
    NSString *uuid1 = [sut generatePictureUUID];
    NSString *uuid2 = [sut generatePictureUUID];
    XCTAssertNotEqualObjects(uuid1, uuid2, @"Generated picture UUID must be different each time.");
}


#pragma mark - Fetch requests

- (void) testFetchForAllAgentsIsNotNil {
    XCTAssertNotNil([Agent fetchForAllAgents], @"Fetch for all the agents must return a not nil request.");
}


- (void) testFetchForAllAgentsQueriesAgentEntity {
    NSFetchRequest *fetchRequest = [Agent fetchForAllAgents];
    XCTAssertEqualObjects(fetchRequest.entityName, agentEntityName,
                          @"Fetch for all the agents queries the agent entity.");
}


- (void) testFetchForAllAgentsBatchIsConfigured {
    NSFetchRequest *fetchRequest = [Agent fetchForAllAgents];
    XCTAssertEqual(fetchRequest.fetchBatchSize, 20,
                   @"Fetch for all the agents batch size must be configured.");
}


- (void) testFetchForAllAgentsSortsByName {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:agentPropertyName ascending:YES];
    
    NSFetchRequest *fetchRequest = [Agent fetchForAllAgents];
    XCTAssertEqualObjects(fetchRequest.sortDescriptors[0], sortDescriptor,
                          @"Fetch for all agents must be sorted by name first.");
}


- (void) testFetchForAllAgentsWithSortDescriptorsIsNotNil {
    XCTAssertNotNil([Agent fetchForAllAgentsWithSortDescriptors:nil]);
}


- (void) testFetchForAllAgentsWithSortDescriptorsQueriesAgentEntity {
    NSFetchRequest *fetchRequest = [Agent fetchForAllAgentsWithSortDescriptors:nil];
    XCTAssertEqualObjects(fetchRequest.entityName, agentEntityName,
                          @"Fetch for all the agents with sort descriptors queries the agent entity.");
}


- (void) testFetchForAllAgentsBatchWithSortDescriptorsIsConfigured {
    NSFetchRequest *fetchRequest = [Agent fetchForAllAgentsWithSortDescriptors:nil];
    XCTAssertEqual(fetchRequest.fetchBatchSize, 20,
                   @"Fetch for all the agents with sort descriptors batch size must be configured.");
}


- (void) testFetchForAllAgentsWithSortDescriptorsUsesProvidedSortDescriptors {
    NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:agentPropertyName ascending:YES];
    NSArray *sortDescriptors = @[nameSortDescriptor];
    NSFetchRequest *fetchRequest = [Agent fetchForAllAgentsWithSortDescriptors:sortDescriptors];
    XCTAssertEqualObjects(fetchRequest.sortDescriptors, sortDescriptors,
                          @"Fetch for all agents with sort descriptors must be sorted by name first.");
}


- (void) testFetchForAllAgentsWithPredicateIsNotNil {
    XCTAssertNotNil([Agent fetchForAllAgentsWithPredicate:nil],
                    @"Fetch for all the agents with predicate must return a not nil request.");
}


- (void) testFetchForAllAgentsWithPredicateQueriesAgentEntity {
    NSFetchRequest *fetchRequest = [Agent fetchForAllAgentsWithPredicate:nil];

    XCTAssertEqualObjects(fetchRequest.entityName, agentEntityName,
                          @"Fetch for all the agents with predicate queries the agent entity.");
}


- (void) testFetchForAllAgentsWithPredicateBatchIsConfigured {
    NSFetchRequest *fetchRequest = [Agent fetchForAllAgentsWithPredicate:nil];

    XCTAssertEqual(fetchRequest.fetchBatchSize, 20,
                   @"Fetch for all the agents with predicate batch size must be configured.");
}


- (void) testFetchForAllAgentsWithPredicateSortsByName {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:agentPropertyName ascending:YES];
    
    NSFetchRequest *fetchRequest = [Agent fetchForAllAgentsWithPredicate:nil];

    XCTAssertEqualObjects(fetchRequest.sortDescriptors[0], sortDescriptor,
                          @"Fetch for all agents with predicate  must be sorted by name first.");
}


- (void) testFetchForAllAgentsWithPredicateUsesProvidedPredicate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", agentPropertyDestructionPower, @2];
    
    NSFetchRequest *fetchRequest = [Agent fetchForAllAgentsWithPredicate:predicate];
    
    XCTAssertEqualObjects(fetchRequest.predicate, predicate,
                          @"Fetch for all agents with predicate must use the provided predicate.");
}


#pragma mark - Agent name validation

- (void) testEmptyAgentNameCannotBeSaved {
    sut.name = @"";
    
    XCTAssertFalse([context save:NULL], @"Empty agent name must not be allowed when saving");
}


- (void) testNonEmptyAgentNameCanBeSaved {
    sut.name = @"A";
    
    XCTAssertTrue([context save:NULL], @"Non empty agent name must be allowed when saving");
}


- (void) testAgentNameWithOnlySpacesCannotBeSaved {
    sut.name = @"  ";
    
    XCTAssertFalse([context save:NULL], @"Agent name with only spaces must not be allowed when saving");
}


- (void) testNonEmptyAgentNameReturnsNoError {
    NSError *error = nil;
    sut.name = @"A";

    [context save:&error];
    
    XCTAssertNil(error, @"Non empty agent name must return no error when saving");
    
}


- (void) testAgentNameWithOnlySpacesValidationReturnsAppropiateError {
    NSString *name = @" ";
    NSError *error;
    
    [sut validateName:&name error:&error];
    
    XCTAssertNotNil(error, @"An error must be returned when name is not validated.");
    XCTAssertEqual(error.code, AgentErrorCodeNameEmpty, @"Appropiate error code must be returned when name is not validated.");
}


- (void) testAgentNameNullPointertDoesntThrowException {
    XCTAssertNoThrow([sut validateName:NULL error:NULL],
                     @"Nil agent name must not be allowed when validating.");
}

@end
