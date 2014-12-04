//
//  MorseDelayChar.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 26/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MorseDelayChar.h"

@implementation MorseDelayChar

-(instancetype)initWithTime:(NSTimeInterval)time{
    self = [super initWithTime:time emmitSound:NO];
    return self;
}

@end
