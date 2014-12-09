//
//  BadHunterDocument.m
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 9/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "BadHunterDocument.h"

NSString *const freakTypesKey = @"FreakTypes";



@implementation BadHunterDocument

- (void) importData:(NSDictionary *)dictionary {
    for (NSDictionary *freakTypeDict in dictionary[freakTypesKey]) {
        [FreakType freakTypeInMOC:self.managedObjectContext withDictionary:freakTypeDict];
    }
}

@end
