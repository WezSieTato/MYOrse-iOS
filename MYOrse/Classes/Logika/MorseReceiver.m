//
//  MorseReceiver.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 30/12/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MorseReceiver.h"
#import "MorseDot.h"
#import "MorseDash.h"


@interface MorseReceiver (){
    NSMutableArray* _code;
    NSMutableArray* _lastInvalidCode;
    MorseDot* _dot;
    short _delay;
    NSString* _lastCharacter;
    NSMutableString* _message;
    NSMutableString* _stringCode;
    MorseDash* _dash;
}

@end


@implementation MorseReceiver

#pragma mark - Creation

-(instancetype)initWithMorseTable:(MorseTable*)table
{
    self = [super init];
    if(self){
        self.morseTable = table;
        _dot = [MorseDot new];
        _dash = [MorseDash new];
        _code = [NSMutableArray new];
        _message = [NSMutableString new];
        _stringCode = [NSMutableString new];
        
        [self clear];

    }
    
    return self;
}

+(instancetype)receiverWithMorseTable:(MorseTable*)table
{
    return [[self alloc] initWithMorseTable:table];
}

#pragma mark - Property

-(NSString*)message{
    if([_code count]){
        [self translateChar];
        [self putLast];
    }
    
    if([_message isEqualToString:@" "])
        return @"";
    
    if ([_message hasSuffix:@" "]) {
        return [_message substringToIndex:[_message length] -1];
    }
    
    return [_message copy];
}

-(NSString*)stringCode{
    return [_stringCode copy];
}

#pragma mark - Public Method

-(void)clear{
    _delay = 0;
    _lastCharacter = nil;
    [_message setString:@""];
    [_code removeAllObjects];
    _lastInvalidCode = nil;
    [_stringCode setString:@""];
}

-(void)putDot
{
    _delay = 0;
    [_code addObject:_dot];
    [_stringCode appendString:@"."];
}

-(void)putDash
{
    _delay = 0;
    [_code addObject:_dash];
    [_stringCode appendString:@"-"];
}

-(BOOL)putDelay
{
    [_stringCode appendString:@"/"];
    
    switch (_delay) {
        case 0:
            [self translateChar];
            [self putLast];
            break;
            
        case 1:
            _lastCharacter = @" ";
            [self putLast];
            break;
            
        case 2:
        default:
            return YES;
    }
    
    ++_delay;
    return NO;
}

#pragma mark - Private Method

-(void)translateChar{
    if(![_code count]){
        _lastCharacter = @" ";
        return;
    }
    
    _lastCharacter = [_morseTable keyForCode:_code];
    if(_lastCharacter == nil){
        _lastInvalidCode = [NSMutableArray new];
        [_lastInvalidCode addObjectsFromArray:_code];
    } else {
        _lastInvalidCode = nil;
    }
    [_code removeAllObjects];
}

-(void)putLast{
    if(_lastCharacter)
       [_message appendString:_lastCharacter];
    else if (_lastInvalidCode){
        [_message appendString:@"<"];
        for (MorseChar* mchar in _lastInvalidCode) {
            if([mchar isKindOfClass:[MorseDot class]])
               [_message appendString:@"."];
            else
                [_message appendString:@"-"];
        }
        [_message appendString:@">"];
    }
    
    _lastCharacter = nil;
    _lastInvalidCode = nil;
}

@end
