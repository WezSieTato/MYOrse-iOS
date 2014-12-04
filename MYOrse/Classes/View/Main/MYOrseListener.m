//
//  MYOrseListener.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 04/12/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MYOrseListener.h"
#import "Constants.h"
#import <MSLittleMagic/MSPair.h>
#import "MorseBroadcaster.h"
#import "MorseTableReader.h"
#import "GTalkConnection.h"

@interface MYOrseListener () < MorseBroadcasterDelegate >{
    MorseBroadcaster* _broadcaster;
}

@end

@implementation MYOrseListener

#pragma mark - Creation

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"morse_table" ofType:@"txt"];
        MorseTable* tableMorse = [[MorseTableReader new] readFile:path];
        MorseTranslator* translator = [MorseTranslator translatorWithTable:tableMorse];
        _broadcaster = [MorseBroadcaster broadcasterWithTranslator:translator];
        _broadcaster.delegate = self;
    }
    return self;
}

#pragma mark - Public Methods

-(void)start{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageReceived:)
                                                 name:NOTIFICATION_MESSAGE_RECEIVED
                                               object:nil];
}

-(void)stop{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)isIsTransmitting{
    return _broadcaster.isTransmitting;
}

#pragma mark - Private Methods

-(void)messageReceived:(NSNotification*)notification{
    MSPair* pair = (MSPair*)notification.object;
    NSString* mail = pair.first;
    NSLog(@"Otrzymano wiadomość od: %@ \n treść: %@", pair.first, pair.second);
    if([mail isEqualToString:self.username] && !_broadcaster.isTransmitting){
        [self transmittMessage:pair.second];
        
    }
}

-(void)transmittMessage:(NSString*)message{
    [[GTalkConnection sharedInstance] sendMessageTo:_username
                                           withBody:NSLocalizedString(@"TRANSMITTION_MORSE_STARTED", nil)];
}

-(void)morseBroadcasterDidEndTransmition:(MorseBroadcaster *)morseTransmitter{
    [[GTalkConnection sharedInstance] sendMessageTo:_username
                                           withBody:NSLocalizedString(@"TRANSMITTION_MORSE_ENDED", nil)];
}

@end
