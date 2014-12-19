//
//  MYOTransmitter.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 19/12/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MYOTransmitter.h"
#import <MyoKit/MyoKit.h>

@implementation MYOTransmitter

-(void)transmitShort{
    TLMHub* hub = [TLMHub sharedHub];
    for (TLMMyo *myo in [hub myoDevices]) {
        [myo vibrateWithLength:TLMVibrationLengthShort];
    }
}

-(void)transmitLong{
    TLMHub* hub = [TLMHub sharedHub];
    for (TLMMyo *myo in [hub myoDevices]) {
        [myo vibrateWithLength:TLMVibrationLengthLong];
    }
}

@end
