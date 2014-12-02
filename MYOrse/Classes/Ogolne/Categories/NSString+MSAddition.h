//
//  NSString+Addition.h
//  Kiwi
//
//  Created by Marcin Stepnowski on 04/11/14.
//  Copyright (c) 2014 weblify. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MSAddition)

-(NSNumber*)numberValue;

-(NSString*)stringByRemovingCharactersinString:(NSString*)characters;
-(NSString*)stringByRemovingEverythingWithoutCharactersInString:(NSString*)characters;
-(NSString*)stringByReplacingCharactersInSet:(NSCharacterSet*)set withString:(NSString*)newString;

-(NSArray*)charsArray;
-(NSArray*)wordsArray;
@end
