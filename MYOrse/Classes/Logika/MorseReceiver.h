//
//  MorseReceiver.h
//  MYOrse
//
//  Created by Marcin Stepnowski on 30/12/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MorseTable.h"

@interface MorseReceiver : NSObject

@property (nonatomic, strong, readonly) NSString* message;
@property (nonatomic, strong, readonly) NSString* stringCode;
@property (nonatomic, strong) MorseTable* morseTable;

-(instancetype)initWithMorseTable:(MorseTable*)table;
+(instancetype)receiverWithMorseTable:(MorseTable*)table;

-(void)putDot;
-(void)putDash;
-(BOOL)putDelay;
-(void)clear;

@end
