//
//  MorseChar.h
//  MYOrse
//
//  Created by Marcin Stepnowski on 26/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMorseCharDotTime 0.5f

@interface MorseChar : NSObject

@property (readonly) BOOL emmitSound;
@property (readonly) NSTimeInterval time;

-(instancetype)initWithTime:(NSTimeInterval)time emmitSound:(BOOL)emmitSound;

@end
