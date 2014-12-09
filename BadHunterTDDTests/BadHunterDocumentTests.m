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

@end
