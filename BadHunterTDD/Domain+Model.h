//
//  Domain+Model.h
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 6/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "Domain.h"

extern NSString *const domainEntityName;


@interface Domain (Model)

+ (instancetype) domainInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name;
+ (Domain *) fetchInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name;
+ (NSFetchRequest *) fetchForControlledDomains;

@end
