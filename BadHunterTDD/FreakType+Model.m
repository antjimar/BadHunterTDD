//
//  FreakType+Model.m
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 6/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "FreakType+Model.h"

NSString *const freakTypeEntityName = @"FreakType";



@implementation FreakType (Model)

#pragma mark - Convenience constructor

+ (instancetype) freakTypeInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name {
    return [NSEntityDescription insertNewObjectForEntityForName:freakTypeEntityName
                                         inManagedObjectContext:moc];
}

@end
