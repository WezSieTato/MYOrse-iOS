//
//  NSString+Addition.m
//  Kiwi
//
//  Created by Marcin Stepnowski on 04/11/14.
//  Copyright (c) 2014 weblify. All rights reserved.
//

#import "NSString+MSAddition.h"

@implementation NSString (MSAddition)

-(NSNumber*)numberValue{
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber = [f numberFromString:self];
    return myNumber;
}

-(NSString*)stringByRemovingCharactersinString:(NSString *)characters{
    NSCharacterSet *notAllowedChars = [NSCharacterSet characterSetWithCharactersInString: characters];
    NSString *resultString = [[self componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    return resultString;
}

-(NSString*)stringByRemovingEverythingWithoutCharactersInString:(NSString *)characters{
    NSCharacterSet *allowedChars = [[NSCharacterSet characterSetWithCharactersInString: characters] invertedSet];
    NSString *resultString = [[self componentsSeparatedByCharactersInSet:allowedChars] componentsJoinedByString:@""];
    return resultString;
}

-(NSString*)stringByReplacingCharactersInSet:(NSCharacterSet *)set withString:(NSString *)newString{
    return [[self componentsSeparatedByCharactersInSet:set] componentsJoinedByString:newString];
}

-(NSArray*)charsArray{
    NSMutableArray  *chars = [NSMutableArray array];
    
    [self enumerateSubstringsInRange: NSMakeRange(0, [self length]) options: NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString *inSubstring, NSRange inSubstringRange, NSRange inEnclosingRange, BOOL *outStop) {
                              [chars addObject: inSubstring];
                          }];
    
    return chars;
}

-(NSArray*)wordsArray{
    NSMutableArray *parts = [NSMutableArray arrayWithArray:[self componentsSeparatedByCharactersInSet:[NSCharacterSet  whitespaceCharacterSet]]];
    [parts removeObjectIdenticalTo:@""];
    
    return [parts copy];
}

@end
