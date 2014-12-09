//
//  BadHunterDocument.h
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 9/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FreakType+Model.h"
#import "Domain+Model.h"
#import "Agent+Model.h"


extern NSString *const freakTypesKey;
extern NSString *const domainsKey;
extern NSString *const agentsKey;



@interface BadHunterDocument : UIManagedDocument

- (void) importData:(NSDictionary *)dictionary;

@end
