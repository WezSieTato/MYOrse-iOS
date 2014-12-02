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
#import "NSString+MSAddition.h"

@interface MorseTranslator (){
    MorseMessagePreparator* _preparator;
    MorseDelayAfterWord* _delayWord;
    MorseDelayAfterChar* _delayChar;
}

@end

@implementation MorseTranslator

-(instancetype)init{
    self = [super init];
    
    if(self){
        _preparator = [MorseMessagePreparator new];
        _delayChar = [MorseDelayAfterChar new];
        _delayWord = [MorseDelayAfterWord new];
    }
    
    return self;
}

-(void)setTableMorse:(TableMorse *)tableMorse{
    _preparator.tableMorse = tableMorse;
}

-(TableMorse*)tableMorse{
    return _preparator.tableMorse;
}

-(NSArray*)translate:(NSString *)message{
    NSMutableArray* code = [NSMutableArray new];

//    NSArray* words = [message wordsArray];
    NSString* preparedMessade = [_preparator prepareMessage:message];
    for (NSString* word in [preparedMessade wordsArray]) {
        NSArray* characters = [word charsArray];
        NSUInteger last = [characters count] - 1;
        [characters enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
            [code addObjectsFromArray:[self.tableMorse codeForKey:obj]];
            if (idx < last) {
                [code addObject:_delayChar];
            }
            NSLog(@"ch: %@ i: %i, l: %i", obj, idx, last);
        }];
        
        [code addObject:_delayWord];
    }
    
    if([code count])
       [code removeLastObject];
    
    return [code copy];
}

@end
