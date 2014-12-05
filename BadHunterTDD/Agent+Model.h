//
//  Agent+Model.h
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 5/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "Agent.h"


@interface Agent (Model)

+ (instancetype) agentInMOC:(NSManagedObjectContext *)moc;

@end
