//
//  TableMorse.h
//  MYOrse
//
//  Created by Marcin Stepnowski on 30/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MorseTable : NSObject

@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) NSString* keys;

/**
 *  Dodaje kod Morse'a dla danego znaku
 *
 *  @param dotArray Tablica NSNumber z boolami, 
 *                  true dla kropki, false dla kreski
 *  @param key      Znak, dla ktorego ma być kod
 */
-(void)addCode:(NSArray*)dotArray forKey:(NSString*)key;

-(NSArray*)codeForKey:(NSString*)key;
-(NSString*)keyForCode:(NSArray*)code;

@end
