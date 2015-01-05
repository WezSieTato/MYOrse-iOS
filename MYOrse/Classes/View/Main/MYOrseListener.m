//
//  MYOrseListener.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 04/12/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MYOrseListener.h"
#import <MSLittleMagic/MSPair.h>
#import "MorseBroadcaster.h"
#import "MorseTableReader.h"
#import "GTalkConnection.h"
#import "MYOTransmitter.h"
#import "MYOReceiver.h"
#import <MyoKit/MyoKit.h>

@interface MYOrseListener () < MorseBroadcasterDelegate, MYOReceiverDelegate >{
    MorseBroadcaster* _broadcaster;
    MYOReceiver* _myoReceiver;
    NSTimer* _bzzTimer;
    short _bzzNumber;
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
        _broadcaster.transmitter = [MYOTransmitter new];
        _myoReceiver = [MYOReceiver receiverWithMorseTable:tableMorse];
        _myoReceiver.delegate = self;
        _transmitting = NO;
    }
    return self;
}

#pragma mark - Public Methods

-(void)start{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageReceived:)
                                                 name:NOTIFICATION_MESSAGE_RECEIVED
                                               object:nil];
    
    [self setEnabled:YES];
}

-(void)stop{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(_transmitting){
        [_broadcaster stopTransmission];
        [_myoReceiver stop];
    }
    
    self.enabled = NO;
}

#pragma mark - Delegate Methods

-(void)messageReceived:(NSNotification*)notification{
    MSPair* pair = (MSPair*)notification.object;
    NSString* mail = pair.first;
    NSLog(@"Otrzymano wiadomość od: %@ \n treść: %@", pair.first, pair.second);
    if([mail isEqualToString:self.username] && !_broadcaster.isTransmitting){
        [self transmittMessage:pair.second];
        
    }
}

-(void)morseBroadcasterDidEndTransmission:(MorseBroadcaster *)morseTransmitter{
    [self bzz];
}

-(void)morseBroadcasterDidInterruptTransmission:(MorseBroadcaster *)morseTransmitter{
    [[GTalkConnection sharedInstance] sendMessageTo:_username
                                           withBody:NSLocalizedString(@"INTERRUPT_MYORSE_MESSAGE", nil)];
    _transmitting = NO;
}

-(void)messageSended:(NSString *)message{
    if (!message || ![message length]) {
        [[GTalkConnection sharedInstance] sendMessageTo:_username
                                               withBody:NSLocalizedString(@"TRANSMITTION_MORSE_ENDED", nil)];
    }
    _transmitting = NO;
}

#pragma mark - Private Methods

-(void)transmittMessage:(NSString*)message{
    [[GTalkConnection sharedInstance] sendMessageTo:_username
                                           withBody:NSLocalizedString(@"TRANSMITTION_MORSE_STARTED", nil)];
    [_broadcaster sendMessage:message];
    _transmitting = YES;
}


-(void)dealloc{
    [self stop];
}

-(void)bzz{
    [[TLMHub sharedHub].myoDevices.firstObject indicateUserAction];
    ++_bzzNumber;
    if(_bzzNumber < 3)
        _bzzTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(bzz) userInfo:nil repeats:NO];
    else{
        _bzzNumber = 0;
        [_myoReceiver startWithEmail:_username];
    }
}

-(void)setEnabled:(BOOL)enabled{
    if (enabled == _enabled) {
        return;
    }
    NSString* siemaMsg = NSLocalizedString( !enabled ? @"STOP_MYORSE_MESSAGE" : @"START_MYORSE_MESSAGE", nil);
    [[GTalkConnection sharedInstance] sendMessageTo:_username withBody:siemaMsg];
    
    _enabled = enabled;
}

@end
