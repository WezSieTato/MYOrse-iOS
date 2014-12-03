//
//  MorseMessagePreparation.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 02/12/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MorseMessagePreparator.h"
#import <MSAddition/MSAddition.h>

@implementation MorseMessagePreparator

-(NSString*)prepareMessage:(NSString *)message{
    NSMutableString* mutableMessage = [[message lowercaseString] mutableCopy];
    
    [mutableMessage ms_replacePolishCharacters];
    NSMutableString* characters = [[_tableMorse keys] mutableCopy];
    [characters ms_prependString:@" "];

    NSString* str = [mutableMessage ms_stringByReplacingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet] withString:@" "];
    
    return [str ms_stringByRemovingEverythingWithoutCharactersInString:characters];
}

@end
