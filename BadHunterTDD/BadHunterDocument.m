//
//  BadHunterDocument.m
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 9/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "BadHunterDocument.h"

NSString *const freakTypesKey = @"FreakTypes";
NSString *const domainsKey = @"Domains";
NSString *const agentsKey = @"Agents";
NSString *const initialDataResource = @"initialAgentData";
NSString *const initialDataExtension = @"sqlite";



@implementation BadHunterDocument

- (void) importData:(NSDictionary *)dictionary {
    [self importFreakTypes:dictionary[freakTypesKey]];
    [self importDomains:dictionary[domainsKey]];
    [self importAgents:dictionary[agentsKey]];
}

    
- (void) importFreakTypes:(NSArray *)freakTypesDictionaries {
    for (NSDictionary *freakTypeDict in freakTypesDictionaries) {
        [FreakType freakTypeInMOC:self.managedObjectContext withDictionary:freakTypeDict];
    }
}

    
- (void) importDomains:(NSArray *)domainsDictionaries {
    for (NSDictionary *domainDict in domainsDictionaries) {
        [Domain domainInMOC:self.managedObjectContext withDictionary:domainDict];
    }
}


- (void) importAgents:(NSArray *)agentsDictionaries {
    for (NSDictionary *agentDict in agentsDictionaries) {
        [Agent agentInMOC:self.managedObjectContext withDictionary:agentDict];
    }
}


#pragma mark - Preload data

- (BOOL) configurePersistentStoreCoordinatorForURL:(NSURL *)storeURL ofType:(NSString *)fileType
                                modelConfiguration:(NSString *)configuration
                                      storeOptions:(NSDictionary *)storeOptions
                                             error:(NSError *__autoreleasing *)error {
    if (![self.fileManager fileExistsAtPath:[storeURL path]]) {
        NSError *error;
        [self.fileManager copyItemAtURL:self.initialDataURL
                                  toURL:storeURL error:&error];
    }
    return [super configurePersistentStoreCoordinatorForURL:storeURL ofType:fileType
                                         modelConfiguration:configuration storeOptions:storeOptions
                                                      error:error];
}


#pragma mark - Lazy loaded properties for dependency injection

- (NSFileManager *) fileManager {
    if (_fileManager == nil) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}


- (NSURL *) initialDataURL {
    if (_initialDataURL == nil) {
        _initialDataURL = [[NSBundle mainBundle] URLForResource:initialDataResource
                                                  withExtension:initialDataExtension];
    }
    return _initialDataURL;
}

@end
