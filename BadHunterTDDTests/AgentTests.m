//
//  AgentTests.m
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 5/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "CoreDataTestCase.h"
#import <OCMock/OCMock.h>
#import "Agent+Model.h"
#import "FreakType+Model.h"
#import "Domain+Model.h"



@interface AgentTests : CoreDataTestCase {
    // Object to test.
    Agent *sut;
    // Additional data.
    FreakType *freakTypeMain;
    Domain *domainMain;
    Domain *domainAlt;
}

@end


@implementation AgentTests

#pragma mark - Constants & Parameters

static NSString *const agentMainName = @"Agent0";
static const NSUInteger agentMainDestructPower = 2;
static const NSUInteger agentMainMotivation = 4;
static NSString *const freakTypeMainName = @"Category1";
static NSString *const domainMainName = @"Domain0";
static NSString *const domainAltName = @"Domain1";


#pragma mark - Set up and tear down

- (void) setUp {
    [super setUp];

    [self createSut];
}


- (void) createFixture {
    freakTypeMain = [FreakType freakTypeInMOC:context withName:freakTypeMainName];
    domainMain = [Domain domainInMOC:context withName:domainMainName];
    domainAlt = [Domain domainInMOC:context withName:domainAltName];
}


- (void) createSut {
    sut = [Agent agentInMOC:context];
}


- (void) tearDown {
    [self releaseSut];

    [super tearDown];
}


- (void) releaseSut {
    sut = nil;
}


- (void) releaseFixture {
    domainAlt = nil;
    domainMain = nil;
    freakTypeMain = nil;
}


#pragma mark - Basic test

- (void) testObjectIsNotNil {
    XCTAssertNotNil(sut, @"The object to test must be created in setUp.");
}


#pragma mark - Importing data

- (void) testNotNilAgentIsCreatedWithImportingInitializer {
    XCTAssertNotNil([Agent agentInMOC:context withDictionary:nil],
                    @"Agent created with importer constructor must not be nil.");
}


- (void) testImportingInitializerPreservesName {
    Agent *agent = [Agent agentInMOC:context withDictionary:@{agentPropertyName: agentMainName}];
    XCTAssertEqualObjects(agent.name, agentMainName,
                          @"Agent created with importer constructor must preserve name.");
}


- (void) testImportingInitializerPreservesDestructionPower {
    Agent *agent = [Agent agentInMOC:context withDictionary:@{agentPropertyDestructionPower: @(agentMainDestructPower)}];
    XCTAssertEqual([agent.destructionPower unsignedIntegerValue], agentMainDestructPower,
                   @"Agent created with importer constructor must preserve destruction power.");
}


- (void) testImportingInitializerPreservesMotivation {
    Agent *agent = [Agent agentInMOC:context withDictionary:@{agentPropertyMotivation: @(agentMainMotivation)}];
    XCTAssertEqual([agent.motivation unsignedIntegerValue], agentMainMotivation,
                   @"Agent created with importer constructor must preserve motivation.");
}


#pragma mark - Import relationships

- (void) testImportingInitializerEstablishesRelationshipWithFreakTypeWithName {
    Agent *agent = [Agent agentInMOC:context withDictionary:@{agentImportPropertyCategory: freakTypeMainName}];
    XCTAssertEqual(agent.category, freakTypeMain,
                   @"Agent created with imported must be related to the FreakType with the given name.");
}


- (void) testImportingInitializerEstablishesRelationshipWithDomainsWithNames {
    Agent *agent = [Agent agentInMOC:context withDictionary:@{agentImportPropertyDomains: @[domainMainName, domainAltName]}];
    XCTAssertTrue([agent.domains containsObject:domainMain],
                  @"Agent created with imported must be related to the Domains with the given names.");
    XCTAssertTrue([agent.domains containsObject:domainAlt],
                  @"Agent created with imported must be related to the Domains with the given names.");
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
    XCTAssertEqual(error.code, AgentErrorCodeNameEmpty,
                   @"Appropiate error code must be returned when name is not validated.");
}


- (void) testAgentNameNullPointertDoesntThrowException {
    NSError *error;

    XCTAssertNoThrow([sut validateName:NULL error:&error],
                     @"Nil agent name must not be allowed when validating.");
}


- (void) testAgentNameNullPointerValidationReturnsAppropiateError {
    NSError *error;
    
    [sut validateName:nil error:&error];
    
    XCTAssertNotNil(error, @"An error must be returned when name is not validated.");
    XCTAssertEqual(error.code, AgentErrorCodeNameNotDefined,
                   @"Appropiate error code must be returned when name pointer is NULL.");
}

@end
