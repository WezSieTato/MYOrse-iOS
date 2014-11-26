//
//  MorseDelayAfterWord.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 26/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MorseDelayAfterWord.h"

@implementation MorseDelayAfterWord

-(instancetype)init{
    self = [super initWithTime:kMorseCharDotTime * 3 * 3];
    return self;
}

@end
