//
//  MorseTransmitter.h
//  MYOrse
//
//  Created by Marcin Stepnowski on 03/12/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MorseTranslator.h"

@class MorseBroadcaster;

@protocol MorseBroadcasterDelegate <NSObject>

-(void)morseBroadcasterDidEndTransmition:(MorseBroadcaster*)morseTransmitter;

@end

@protocol MorseTransmitter <NSObject>

@optional
-(void)transmit:(NSTimeInterval)time;
-(void)transmitShort;
-(void)transmitLong;

@end

@interface MorseBroadcaster : NSObject

@property (atomic, readonly, strong) NSString* message;
@property (atomic, readonly, getter=isTransmitting) BOOL transmitting;
@property (strong) MorseTranslator* translator;

@property (nonatomic, weak) id < MorseBroadcasterDelegate > delegate;
@property (nonatomic, strong) id < MorseTransmitter > transmitter;

-(instancetype)initWithTranslator:(MorseTranslator*)translator;
+(instancetype)broadcasterWithTranslator:(MorseTranslator*)translator;

-(void)sendMessage:(NSString*)message;

@end
