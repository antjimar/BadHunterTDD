//
//  Agent+Model.m
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 5/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "Agent+Model.h"

NSString *const agentEntityName = @"Agent";


@implementation Agent (Model)

#pragma mark - Convenience constructor

+ (instancetype) agentInMOC:(NSManagedObjectContext *)moc {
    Agent *agent = [NSEntityDescription insertNewObjectForEntityForName:agentEntityName
                                                 inManagedObjectContext:moc];
    return agent;
}


#pragma mark - Custom getters & setters

- (NSNumber *) appraisal {
    NSUInteger destrPowerValue = [self.destructionPower unsignedIntegerValue];
    NSUInteger motivationValue = [self.motivation unsignedIntegerValue];
    NSUInteger appraisalValue = (destrPowerValue + motivationValue) / 2;
    return @(appraisalValue);
}

@end
