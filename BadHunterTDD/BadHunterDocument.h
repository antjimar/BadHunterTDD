//
//  BadHunterDocument.h
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 9/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FreakType+Model.h"

extern NSString *const freakTypesKey;



@interface BadHunterDocument : UIManagedDocument

- (void) importData:(NSDictionary *)dictionary;

@end
