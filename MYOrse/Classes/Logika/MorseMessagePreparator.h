//
//  MorseMessagePreparation.h
//  MYOrse
//
//  Created by Marcin Stepnowski on 02/12/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MorseTable.h"

/**
 *  Klasa funkcyjna przytowywująca ciąg znaków do tłumaczenia
 */
@interface MorseMessagePreparator : NSObject

@property (nonatomic, strong) MorseTable* tableMorse;

-(instancetype)initWithTable:(MorseTable*)table;
+(instancetype)messagePreparatorWithTable:(MorseTable*)table;

-(NSString*)prepareMessage:(NSString*)message;

@end
