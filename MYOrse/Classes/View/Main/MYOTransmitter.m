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
    [self transmitSignalShort:YES];
}

-(void)transmitLong{
    [self transmitSignalShort:NO];
}

-(void)transmitSignalShort:(BOOL)isShort{
    TLMHub* hub = [TLMHub sharedHub];
    for(TLMMyo *myo  in hub.myoDevices)
//    TLMMyo *myo = (TLMMyo*)[hub.myoDevices objectAtIndex:0];
    [myo vibrateWithLength: isShort ? TLMVibrationLengthShort : TLMVibrationLengthLong];
}

@end
