//
//  BadHunterDocumentTests.m
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 9/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "CoreDataTestCase.h"
#import "BadHunterDocument.h"



@interface BadHunterDocumentTests : CoreDataTestCase {
    BadHunterDocument *sut;
}

@end



@implementation BadHunterDocumentTests

#pragma mark - Constants & Parameters

static NSString *const freakTypeMainName = @"Category0";
static NSString *const freakTypeAltName = @"Category1";
static NSString *const domainMainName = @"Domain0";
static NSString *const domainAltName = @"Domain1";
static NSString *const agentMainName = @"Agent0";
static const NSUInteger agentMainDestructPower = 2;
static const NSUInteger agentMainMotivation = 4;
static NSString *const agentAltName = @"Agent1";
static const NSUInteger agentAltDestructPower = 3;
static const NSUInteger agentAltMotivation = 5;


#pragma mark - Set up and tear down

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
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
    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = coordinator;
}


- (void) createSut {
    NSURL *docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                             inDomains:NSUserDomainMask] lastObject];
    NSURL *fakeURL = [docsURL URLByAppendingPathComponent:@"nofile"];
    sut = [[BadHunterDocument alloc] initWithFileURL:fakeURL];
    [sut setValue:context forKey:@"managedObjectContext"];
}


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void) releaseSut {
    
}

#pragma mark - Basic test 

- (void) testSutIsNotNil {
    XCTAssertNotNil(sut, @"The object to test must be created in setUp.");
}


#pragma mark - Fake environment

- (void) testMOCAssignment {
    XCTAssertEqualObjects(sut.managedObjectContext, context,
                          @"Managed object context must be injected for other tests to work.");
}


#pragma mark - Import data

- (void) testImportDataCreatesOneFreakTypeWhenDataContainsOne {
    NSDictionary *data = @{freakTypesKey: @[@{freakTypePropertyName: freakTypeMainName}]};
    
    [sut importData:data];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:freakTypeEntityName]
                                              error:&error];
    XCTAssertEqual(results.count, (NSUInteger)1,
                   @"Import data must create one FreakType and only one when that is provided in the data.");
}


- (void) testImportDataCreatesTwoFreakTypesWhenDataContainsTwo {
    NSDictionary *data = @{freakTypesKey: @[@{freakTypePropertyName: freakTypeMainName},
                                            @{freakTypePropertyName: freakTypeAltName}]};
    
    [sut importData:data];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:freakTypeEntityName]
                                              error:&error];
    XCTAssertEqual(results.count, (NSUInteger)2,
                   @"Import data must create two FreakType and only two when that is provided in the data.");
}


- (void) testImportDataCreatesAFreakTypeWithDataInItsDictionary {
    NSDictionary *data = @{freakTypesKey: @[@{freakTypePropertyName: freakTypeMainName}]};
    
    [sut importData:data];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:freakTypeEntityName]
                                              error:&error];
    FreakType *freakType = [results lastObject];
    XCTAssertEqualObjects(freakType.name, freakTypeMainName,
                          @"Import data must create FreakTypes with the provided data.");
}


- (void) testImportDataCreatesOneDomainWhenDataContainsOne {
    NSDictionary *data = @{domainsKey: @[@{domainPropertyName: domainMainName}]};
    
    [sut importData:data];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:domainEntityName]
                                              error:&error];
    XCTAssertEqual(results.count, (NSUInteger)1,
                   @"Import data must create one Domain and only one when that is provided in the data.");
}


- (void) testImportDataCreatesTwoDomainsWhenDataContainsTwo {
    NSDictionary *data = @{domainsKey: @[@{domainPropertyName: domainMainName},
                                         @{domainPropertyName: domainAltName}]};
    
    [sut importData:data];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:domainEntityName]
                                              error:&error];
    XCTAssertEqual(results.count, (NSUInteger)2,
                   @"Import data must create two Domains and only two when that is provided in the data.");
}


- (void) testImportDataCreatesADomainWithDataInItsDictionary {
    NSDictionary *data = @{domainsKey: @[@{domainPropertyName: domainMainName}]};
    
    [sut importData:data];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:domainEntityName]
                                              error:&error];
    Domain *domain = [results lastObject];
    XCTAssertEqualObjects(domain.name, domainMainName,
                          @"Import data must create Domains with the provided data.");
}


- (void) testImportDataCreatesOneAgentWhenDataContainsOne {
    NSDictionary *data = @{agentsKey: @[@{agentPropertyName: agentMainName,
                                          agentPropertyDestructionPower: @(agentMainDestructPower),
                                          agentPropertyMotivation: @(agentMainMotivation)}]};
    
    [sut importData:data];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:agentEntityName]
                                              error:&error];
    XCTAssertEqual(results.count, (NSUInteger)1,
                   @"Import data must create one Agent and only one when that is provided in the data.");
}


- (void) testImportDataCreatesTwoAgentsWhenDataContainsTwo {
    NSDictionary *data = @{agentsKey: @[@{agentPropertyName: agentMainName,
                                          agentPropertyDestructionPower: @(agentMainDestructPower),
                                          agentPropertyMotivation: @(agentMainMotivation)},
                                        @{agentPropertyName: agentAltName,
                                          agentPropertyDestructionPower: @(agentAltDestructPower),
                                          agentPropertyMotivation: @(agentAltMotivation)}]};
    
    [sut importData:data];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:agentEntityName]
                                              error:&error];
    XCTAssertEqual(results.count, (NSUInteger)2,
                   @"Import data must create two Agents and only two when that is provided in the data.");
}


- (void) testImportDataCreatesAnAgentWithDataInItsDictionary {
    NSDictionary *data = @{freakTypesKey: @[@{freakTypePropertyName: freakTypeMainName}],
                           domainsKey: @[@{domainPropertyName: domainMainName},
                                         @{domainPropertyName: domainAltName}],
                           agentsKey: @[@{agentPropertyName: agentMainName,
                                          agentPropertyDestructionPower: @(agentMainDestructPower),
                                          agentPropertyMotivation: @(agentMainMotivation),
                                          agentImportPropertyCategory: freakTypeMainName,
                                          agentImportPropertyDomains: @[domainMainName, domainAltName]
                                          }]};
    
    [sut importData:data];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:agentEntityName]
                                              error:&error];
    Agent *agent = [results lastObject];
    XCTAssertEqualObjects(agent.name, agentMainName,
                          @"Import data must create Agents with the provided name.");
    XCTAssertEqual([agent.destructionPower unsignedIntegerValue], agentMainDestructPower,
                   @"Import data must create Agents with the provided destructionPower.");
    XCTAssertEqual([agent.motivation unsignedIntegerValue], agentMainMotivation,
                   @"Import data must create Agents with the provided motivation.");
    XCTAssertEqualObjects(agent.category.name, freakTypeMainName,
                          @"Import data must create Agents with the provided freak type.");
    XCTAssertEqual([agent.domains count], (NSUInteger)2,
                   @"Import data must create Agents with the provided domains.");
}

@end
