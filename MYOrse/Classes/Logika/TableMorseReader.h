//
//  TableMorseParser.h
//  MYOrse
//
//  Created by Marcin Stepnowski on 30/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableMorse.h"

@interface TableMorseReader : NSObject

-(TableMorse*)readFile:(NSString*)path;

@end
