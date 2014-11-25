//
//  XMPPPresence+GTalk.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 25/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "XMPPPresence+GTalk.h"

@implementation XMPPPresence (GTalk)

-(BOOL)isAvailable{
    return [self.type isEqualToString:@"available"];
}

-(BOOL)isVisible{
    return [self isAvailable];
}


-(BOOL)isUnavailable{
    return [self.type isEqualToString:@"unavailable"];
}

+(instancetype)unavailablePresence{
    return [self presenceWithType:@"unavailable"];
}
+(instancetype)invisiblePresence{
    return [self presenceWithType:@"invisible"];
}

@end
