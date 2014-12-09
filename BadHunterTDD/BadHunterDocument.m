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



@implementation BadHunterDocument

- (void) importData:(NSDictionary *)dictionary {
    [self importFreakTypes:dictionary[freakTypesKey]];
    [self importDomains:dictionary[domainsKey]];
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


    @end
