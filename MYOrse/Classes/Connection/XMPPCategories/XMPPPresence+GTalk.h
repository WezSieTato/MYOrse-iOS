//
//  XMPPPresence+GTalk.h
//  MYOrse
//
//  Created by Marcin Stepnowski on 25/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "XMPPPresence.h"

@interface XMPPPresence (GTalk)

@property (getter=isVisible, readonly, nonatomic) BOOL visible;
@property (getter=isAvailable, readonly, nonatomic) BOOL available;
@property (getter=isUnavailable, readonly, nonatomic) BOOL unavailable;

+(instancetype)unavailablePresence;
+(instancetype)invisiblePresence;

@end
