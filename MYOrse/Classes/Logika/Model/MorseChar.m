//
//  MorseChar.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 26/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MorseChar.h"

@implementation MorseChar

-(instancetype)initWithTime:(NSTimeInterval)time emmitSound:(BOOL)emmitSound{
    self = [super init];
    if(self){
        _time = time;
        _emmitSound = emmitSound;
    }
    
    return self;
}

- (BOOL)isEqual:(id)other
{
    if (other == self) return YES;
    if (other == nil) return NO;
    if(!([other isKindOfClass:[MorseChar class]])) return NO;
    MorseChar* mchar = (MorseChar*)other;
    return mchar.emmitSound == self.emmitSound && mchar.time == self.time;
    
}

- (NSUInteger)hash
{
    return _time * 43 + 2 * _emmitSound;
}

@end
