//
//  MorseTranslator.h
//  MYOrse
//
//  Created by Marcin Stepnowski on 02/12/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MorseTable.h"

/**
 *  Klasa tłumacząca ciąg znaków na ciąg znaków Morse'a
 */
@interface MorseTranslator : NSObject

@property (nonatomic, strong) MorseTable*  tableMorse;

-(instancetype)initWithTable:(MorseTable*)table;
+(instancetype)translatorWithTable:(MorseTable*)table;

-(NSArray*)translate:(NSString*)message;

@end
