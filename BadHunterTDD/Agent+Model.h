//
//  Agent+Model.h
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 5/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "Agent.h"

extern NSString *const agentEntityName;
extern NSString *const agentPropertyName;
extern NSString *const agentPropertyAppraisal;
extern NSString *const agentPropertyDestructionPower;
extern NSString *const agentPropertyMotivation;


@interface Agent (Model)

+ (NSSet *) keyPathsForValuesAffectingAppraisal;
+ (instancetype) agentInMOC:(NSManagedObjectContext *)moc;

- (NSString *) generatePictureUUID;
+ (NSFetchRequest *) fetchForAllAgents;
+ (NSFetchRequest *) fetchForAllAgentsWithSortDescriptors:(NSArray *)sortDescriptors;
+ (NSFetchRequest *) fetchForAllAgentsWithPredicate:(NSPredicate *)predicate;
- (BOOL) validateName:(NSString **)name error:(NSError *__autoreleasing *)error;

@end
