//
//  FreakType+Model.h
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 6/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "FreakType.h"

extern NSString *const freakTypeEntityName;
extern NSString *const freakTypePropertyName;


@interface FreakType (Model)

+ (instancetype) freakTypeInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name;
+ (instancetype) freakTypeInMOC:(NSManagedObjectContext *)moc withDictionary:(NSDictionary *)dict;
+ (FreakType *) fetchInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name;

@end
