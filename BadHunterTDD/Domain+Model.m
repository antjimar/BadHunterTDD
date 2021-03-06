//
//  Domain+Model.m
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 6/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "Domain+Model.h"
#import "Agent+Model.h"

NSString *const domainEntityName = @"Domain";
NSString *const domainPropertyName = @"name";


@implementation Domain (Model)

#pragma mark - Convenience constructors

+ (instancetype) domainInMOC:(NSManagedObjectContext *)moc {
    Domain *domain = [NSEntityDescription insertNewObjectForEntityForName:domainEntityName inManagedObjectContext:moc];
    
    return domain;
}


+ (instancetype) domainInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name {
    Domain *domain = [Domain domainInMOC:moc];
    domain.name = name;
    
    return domain;
}


+ (instancetype) domainInMOC:(NSManagedObjectContext *)moc withDictionary:(NSDictionary *)dict {
    Domain *domain = [NSEntityDescription insertNewObjectForEntityForName:domainEntityName inManagedObjectContext:moc];
    domain.name = dict[domainPropertyName];

    return domain;
}


#pragma mark - Fetches

+ (Domain *) fetchInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:domainEntityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", domainPropertyName, name];
    NSError *error;
    NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
    
    return [results lastObject];
}


+ (NSFetchRequest *) fetchForControlledDomains {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:domainEntityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(SUBQUERY(agents,$x,$x.%K >= 3)).@count > 1",
                              agentPropertyDestructionPower];
    return fetchRequest;
}

@end
