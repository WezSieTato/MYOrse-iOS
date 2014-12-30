//
//  MYOReceiver.h
//  MYOrse
//
//  Created by Marcin Stepnowski on 30/12/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MYOReceiverDelegate <NSObject>

-(void)messageSended:(NSString*)message;

@end

@class MorseTable;

@interface MYOReceiver : NSObject

@property (weak, nonatomic) id<MYOReceiverDelegate> delegate;

-(instancetype)initWithMorseTable:(MorseTable*)morseTable;
+(instancetype)receiverWithMorseTable:(MorseTable*)morseTable;

-(void)startWithEmail:(NSString*)email;
-(void)stop;

@end
