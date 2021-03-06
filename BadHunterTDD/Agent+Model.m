//
//  Agent+Model.m
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 5/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "Agent+Model.h"
#import "FreakType+Model.h"
#import "Domain+Model.h"


NSString *const agentEntityName = @"Agent";
NSString *const agentPropertyName = @"name";
NSString *const agentPropertyAppraisal = @"appraisal";
NSString *const agentPropertyDestructionPower = @"destructionPower";
NSString *const agentPropertyMotivation = @"motivation";
NSString *const agentErrorDomain = @"AgentModelError";
NSString *const agentImportPropertyCategory = @"freakTypeName";
NSString *const agentImportPropertyDomains = @"domainNames";


@implementation Agent (Model)

#pragma mark - Convenience constructor

+ (instancetype) agentInMOC:(NSManagedObjectContext *)moc {
    Agent *agent = [NSEntityDescription insertNewObjectForEntityForName:agentEntityName
                                                 inManagedObjectContext:moc];
    return agent;
}


#pragma mark - Convenience constructor for importing 

+ (instancetype) agentInMOC:(NSManagedObjectContext *)moc withDictionary:(NSDictionary *)dict {
    Agent *agent = [NSEntityDescription insertNewObjectForEntityForName:agentEntityName
                                                 inManagedObjectContext:moc];
    agent.name = dict[agentPropertyName];
    agent.destructionPower = dict[agentPropertyDestructionPower];
    agent.motivation = dict[agentPropertyMotivation];
    agent.category = [FreakType fetchInMOC:agent.managedObjectContext
                                  withName:dict[agentImportPropertyCategory]];
    NSMutableSet *domains = [[NSMutableSet alloc] init];
    for (NSString *domainName in dict[agentImportPropertyDomains]) {
        [domains addObject:[Domain fetchInMOC:agent.managedObjectContext withName:domainName]];
    }
    agent.domains = domains;

    return agent;
}


#pragma mark - Dependencies

+ (NSSet *) keyPathsForValuesAffectingAppraisal {
    return [NSSet setWithArray:@[agentPropertyDestructionPower, agentPropertyMotivation]];
}


#pragma mark - Custom getters & setters

- (NSNumber *) appraisal {
    [self willAccessValueForKey:agentPropertyAppraisal];
//    NSUInteger destrPowerValue = [self.destructionPower unsignedIntegerValue];
    NSUInteger destrPowerValue = [[self valueForKey:agentPropertyDestructionPower] unsignedIntegerValue];
//    NSUInteger motivationValue = [self.motivation unsignedIntegerValue];
    NSUInteger motivationValue = [[self valueForKey:agentPropertyMotivation] unsignedIntegerValue];
    NSUInteger appraisalValue = (destrPowerValue + motivationValue) / 2;
    [self didAccessValueForKey:agentPropertyAppraisal];

    return @(appraisalValue);
}


#pragma mark - Picture logic

- (NSString *) generatePictureUUID {
    CFUUIDRef   fileUUID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef fileUUIDString = CFUUIDCreateString(kCFAllocatorDefault, fileUUID);
    CFRelease(fileUUID);

    return (__bridge_transfer NSString *)fileUUIDString;
}


#pragma mark - Validation

- (BOOL) validateName:(NSString **)name error:(NSError *__autoreleasing *)error {
    BOOL validated = NO;
    if (name != NULL) {
        NSString *nameWithoutSpace = [*name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (nameWithoutSpace.length > 0) {
            validated = YES;
        } else {
            *error = [NSError errorWithDomain:agentErrorDomain
                                         code:AgentErrorCodeNameEmpty userInfo:nil];
        }
    } else {
        *error = [NSError errorWithDomain:agentErrorDomain
                                     code:AgentErrorCodeNameNotDefined userInfo:nil];
    }

    return validated;
}


#pragma mark - Fetch requests

+ (NSFetchRequest *) fetchForAllAgents {
    NSFetchRequest *fetchRequest = [self baseFetchRequest];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:agentPropertyName ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];

    return fetchRequest;
}


+ (NSFetchRequest *) fetchForAllAgentsWithSortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *fetchRequest = [self baseFetchRequest];
    fetchRequest.sortDescriptors = sortDescriptors;
    
    return fetchRequest;
}


+ (NSFetchRequest *) baseFetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:agentEntityName];
    fetchRequest.fetchBatchSize = 20;

    return fetchRequest;
}


+ (NSFetchRequest *) fetchForAllAgentsWithPredicate:(NSPredicate *)predicate {
    NSFetchRequest *fetchRequest = [self fetchForAllAgents];
    fetchRequest.predicate = predicate;
    
    return fetchRequest;
}

@end
