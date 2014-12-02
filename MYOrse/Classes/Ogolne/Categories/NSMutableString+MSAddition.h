//
//  NSMutableString+Raplace.h
//  Kiwi
//
//  Created by Marcin Stepnowski on 04/11/14.
//  Copyright (c) 2014 weblify. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (MSAddition)

-(void)replaceString:(NSString*)toReplace withString:(NSString*)newString;
-(void)prependString:(NSString*)string;
-(void)replacePolishCharacters;

@end
