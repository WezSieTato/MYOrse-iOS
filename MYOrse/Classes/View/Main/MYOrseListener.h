//
//  MYOrseListener.h
//  MYOrse
//
//  Created by Marcin Stepnowski on 04/12/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYOrseListener : NSObject

@property (nonatomic, strong) NSString* username;
@property (readonly, getter=isTransmitting) BOOL transmitting;

-(void)start;
-(void)stop;

@end
