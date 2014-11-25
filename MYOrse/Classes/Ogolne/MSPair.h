//
//  MSPair.h
//  MYOrse
//
//  Created by Marcin Stepnowski on 25/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSPair : NSObject

@property (strong) id first;
@property (strong) id second;

-(instancetype)initWithFirst:(id)first andSecond:(id)second;
+(instancetype)pairWithFirst:(id)first andSecond:(id)second;

@end
