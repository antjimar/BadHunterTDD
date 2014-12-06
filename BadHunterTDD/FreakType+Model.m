//
//  FreakType+Model.m
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 6/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "FreakType+Model.h"

NSString *const freakTypeEntityName = @"FreakType";
NSString *const freakTypePropertyName = @"name";



@implementation FreakType (Model)

#pragma mark - Convenience constructor

+ (instancetype) freakTypeInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name {
    FreakType *freakType = [NSEntityDescription insertNewObjectForEntityForName:freakTypeEntityName
                                                         inManagedObjectContext:moc];
    freakType.name = name;
    
    return freakType;
}


#pragma mark - Fetches

+ (FreakType *) fetchInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:freakTypeEntityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", freakTypePropertyName, name];
    NSArray *results = [moc executeFetchRequest:fetchRequest error:NULL];
    
    return [results lastObject];
}

@end
