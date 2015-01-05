//
//  MYOReceiver.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 30/12/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MYOReceiver.h"
#import "MorseReceiver.h"
#import <MyoKit/MyoKit.h>
#import "GTalkConnection.h"

@interface MYOReceiver (){
    MorseReceiver* _morseReceiver;
    NSString* _email;
}

@end

@implementation MYOReceiver

#pragma mark - Creation

-(instancetype)initWithMorseTable:(MorseTable*)morseTable
{
    self = [super init];
    if(self){
        _morseReceiver = [MorseReceiver receiverWithMorseTable:morseTable];
    }
    
    return self;
}

+(instancetype)receiverWithMorseTable:(MorseTable*)morseTable
{
    return [[self alloc] initWithMorseTable:morseTable];
}

#pragma mark - Public Methods

-(void)startWithEmail:(NSString*)email
{
    _email = email;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivePoseChange:)
                                                 name:TLMMyoDidReceivePoseChangedNotification
                                               object:nil];
    
    [[TLMHub sharedHub] setLockingPolicy:TLMLockingPolicyNone];
    for (TLMMyo *myo in [TLMHub sharedHub].myoDevices) {
        [myo unlockWithType:TLMUnlockTypeHold];
    }
 
}

-(void)stop
{
    [_morseReceiver clear];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for (TLMMyo *myo in [TLMHub sharedHub].myoDevices) {
        [myo lock];
    }
    
}

#pragma mark - MYO events

- (void)didReceivePoseChange:(NSNotification*)notification {
    TLMPose *pose = notification.userInfo[kTLMKeyPose];
    TLMMyo* myo = pose.myo;
    switch (pose.type) {
        case TLMPoseTypeFist:
            [_morseReceiver putDot];
            [myo vibrateWithLength:TLMVibrationLengthShort];
            break;
            
        case TLMPoseTypeFingersSpread:
            [_morseReceiver putDash];
            [myo vibrateWithLength:TLMVibrationLengthLong];
            break;
            
        case TLMPoseTypeWaveIn:
        case TLMPoseTypeWaveOut:
            if([_morseReceiver putDelay])
                [self sendMessage];
            [myo indicateUserAction];
            break;

        case TLMPoseTypeDoubleTap:
        case TLMPoseTypeRest:
        case TLMPoseTypeUnknown:
        default:
            break;
    }

}

#pragma mark - Private Methods

-(void)sendMessage{
    NSString* message = [_morseReceiver.message stringByAppendingFormat:@" S: %@", _morseReceiver.stringCode ];
    [[GTalkConnection sharedInstance] sendMessageTo:_email withBody:message];
    [_delegate messageSended:message];
    [self stop];
}

@end
