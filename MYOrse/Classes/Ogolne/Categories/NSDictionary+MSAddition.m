//
//  NSDictionary+NullRemover.m
//  Kiwi
//
//  Created by Marcin Stepnowski on 13/10/14.
//  Copyright (c) 2014 weblify. All rights reserved.
//

#import "NSDictionary+MSAddition.h"

@implementation NSDictionary (MSAddition)

-(NSDictionary*)dictionaryWithoutNull{
    NSMutableDictionary *dict = [self mutableCopy];
    NSArray *keysForNullValues = [dict allKeysForObject:[NSNull null]];
    [dict removeObjectsForKeys:keysForNullValues];
    return [dict copy];
}

@end
