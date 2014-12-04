//
//  MorseTransmitter.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 03/12/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MorseBroadcaster.h"
#import "MorseChar.h"

@interface MorseBroadcaster (){
    NSArray* _code;
    NSEnumerator* _enumerator;
    NSTimer* _timer;
}

@end

@implementation MorseBroadcaster

#pragma mark - Creation

-(instancetype)initWithTranslator:(MorseTranslator *)translator{
    self = [super init];
    if(self){
        self.translator = translator;
    }
    
    return self;
}

+(instancetype)broadcasterWithTranslator:(MorseTranslator *)translator{
    return [[self alloc] initWithTranslator:translator];
}

#pragma mark - Transmittion

-(void)sendMessage:(NSString *)message{
    _message = message;
    _code = [_translator translate:message];
    _enumerator = [_code objectEnumerator];
    [self transmitNextSignal];
}

-(void)transmitNextSignal{
    MorseChar* morse = [_enumerator nextObject];
    
    if(!morse){
        [self transmitionEnded];
        return;
    }
    
    if(morse.emmitSound){
        NSLog(@"bzz przez %f", morse.time);
        [self.transmitter transmit:morse.time];
    } else{
        NSLog(@"przerwa przez %f", morse.time);
    }
    
    NSMethodSignature* signature = [self methodSignatureForSelector:@selector(transmitNextSignal)];
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:morse.time invocation:invocation repeats:NO];
}

-(void)transmitionEnded{
    NSLog(@"Transmisja zakonczona!");
    [self.delegate morseBroadcasterDidEndTransmition:self];
}

@end
