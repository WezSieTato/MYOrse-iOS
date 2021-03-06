//
//  MorseTranslator.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 02/12/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MorseTranslator.h"
#import "MorseMessagePreparator.h"
#import "MorseModel.h"
#import <MSAddition/MSAddition.h>
@interface MorseTranslator (){
    MorseMessagePreparator* _preparator;
    MorseDelayAfterWord* _delayWord;
    MorseDelayAfterChar* _delayChar;
}

@end

@implementation MorseTranslator

#pragma mark - Creation

-(instancetype)init{
    self = [super init];
    
    if(self){
        _preparator = [MorseMessagePreparator new];
        _delayChar = [MorseDelayAfterChar new];
        _delayWord = [MorseDelayAfterWord new];
    }
    
    return self;
}

-(instancetype)initWithTable:(MorseTable *)table{
    self = [super init];
    
    if(self){
        _preparator = [MorseMessagePreparator messagePreparatorWithTable:table];
        _delayChar = [MorseDelayAfterChar new];
        _delayWord = [MorseDelayAfterWord new];
    }
    
    return self;
}

+(instancetype)translatorWithTable:(MorseTable *)table{
    return [[self alloc] initWithTable:table];
}

#pragma mark - Properties

-(void)setTableMorse:(MorseTable *)tableMorse{
    _preparator.tableMorse = tableMorse;
}

-(MorseTable*)tableMorse{
    return _preparator.tableMorse;
}

#pragma mark - Translation

-(NSArray*)translate:(NSString *)message{
    NSMutableArray* code = [NSMutableArray new];

//    NSArray* words = [message wordsArray];
    NSString* preparedMessade = [_preparator prepareMessage:message];
    for (NSString* word in [preparedMessade ms_wordsArray]) {
        NSArray* characters = [word ms_charsArray];
        NSUInteger last = [characters count] - 1;
        [characters enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
            [code addObjectsFromArray:[self.tableMorse codeForKey:obj]];
            if (idx < last) {
                [code addObject:_delayChar];
            }
            NSLog(@"ch: %@ i: %lu, l: %lu", obj, (unsigned long)idx, (unsigned long)last);
        }];
        
        [code addObject:_delayWord];
    }
    
    if([code count])
       [code removeLastObject];
    
    return [code copy];
}

@end
