//
//  MorseDelayAfterChar.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 26/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MorseDelayAfterChar.h"

@implementation MorseDelayAfterChar

-(instancetype)init{
    self = [super initWithTime:kMorseCharDotTime * 3];
    return self;
}

@end
