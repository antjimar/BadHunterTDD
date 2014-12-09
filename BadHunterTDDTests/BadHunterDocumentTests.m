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

@end
