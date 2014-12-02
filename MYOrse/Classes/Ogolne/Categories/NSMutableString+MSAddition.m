//
//  NSMutableString+Raplace.m
//  Kiwi
//
//  Created by Marcin Stepnowski on 04/11/14.
//  Copyright (c) 2014 weblify. All rights reserved.
//

#import "NSMutableString+MSAddition.h"

@implementation NSMutableString (MSAddition)

-(void)replaceString:(NSString *)toReplace withString:(NSString *)newString{
    NSRange range = NSMakeRange(0, [self length]);
    [self replaceOccurrencesOfString:toReplace withString:newString options:0 range:range];
}

-(void)prependString:(NSString *)string{
    [self insertString:string atIndex:0];
}

-(void)replacePolishCharacters{
    [self replaceString:@"ą" withString:@"a"];
    [self replaceString:@"ć" withString:@"c"];
    [self replaceString:@"ę" withString:@"e"];
    [self replaceString:@"ł" withString:@"l"];
    [self replaceString:@"ń" withString:@"n"];
    [self replaceString:@"ó" withString:@"o"];
    [self replaceString:@"ś" withString:@"s"];
    [self replaceString:@"ź" withString:@"z"];
    [self replaceString:@"ż" withString:@"z"];

    [self replaceString:@"Ą" withString:@"A"];
    [self replaceString:@"Ć" withString:@"C"];
    [self replaceString:@"Ę" withString:@"E"];
    [self replaceString:@"Ł" withString:@"L"];
    [self replaceString:@"Ń" withString:@"N"];
    [self replaceString:@"Ó" withString:@"O"];
    [self replaceString:@"Ś" withString:@"S"];
    [self replaceString:@"Ź" withString:@"Z"];
    [self replaceString:@"Ź" withString:@"Z"];
}

@end
