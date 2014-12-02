//
//  MorseMessagePreparation.h
//  MYOrse
//
//  Created by Marcin Stepnowski on 02/12/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableMorse.h"

/**
 *  Klasa funkcyjna przytowywująca ciąg znaków do tłumaczenia
 */
@interface MorseMessagePreparator : NSObject

@property (nonatomic, strong) TableMorse* tableMorse;

-(NSString*)prepareMessage:(NSString*)message;

@end
