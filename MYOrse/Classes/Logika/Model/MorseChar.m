//
//  MorseChar.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 26/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MorseChar.h"

@implementation MorseChar

-(instancetype)initWithTime:(float)time emmitSound:(BOOL)emmitSound{
    self = [super init];
    if(self){
        _time = time;
        _emmitSound = emmitSound;
    }
    
    return self;
}

@end
