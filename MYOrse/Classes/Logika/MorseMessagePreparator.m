//
//  MorseMessagePreparation.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 02/12/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MorseMessagePreparator.h"
#import "NSMutableString+MSAddition.h"
#import "NSString+MSAddition.h"

@implementation MorseMessagePreparator

-(NSString*)prepareMessage:(NSString *)message{
    NSMutableString* mutableMessage = [[message lowercaseString] mutableCopy];
    
    [mutableMessage replacePolishCharacters];
    NSMutableString* characters = [[_tableMorse keys] mutableCopy];
    [characters prependString:@" "];

    NSString* str = [mutableMessage stringByReplacingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet] withString:@" "];
    
    return [str stringByRemovingEverythingWithoutCharactersInString:characters];
}

@end
