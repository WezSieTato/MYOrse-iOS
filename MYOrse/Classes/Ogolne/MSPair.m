//
//  MSPair.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 25/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MSPair.h"

@implementation MSPair

-(instancetype)initWithFirst:(id)first andSecond:(id)second{
    self = [super init];
    if(self){
        self.first = first;
        self.second = second;
    }
    
    return self;
}

+(instancetype)pairWithFirst:(id)first andSecond:(id)second{
    return [[self alloc] initWithFirst:first andSecond:second];
}

@end
