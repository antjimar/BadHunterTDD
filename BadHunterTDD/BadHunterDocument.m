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

@end
