//
//  TableMorse.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 30/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MorseTable.h"
#import "MorseModel.h"

@interface MorseTable (){
    NSMutableDictionary* _map;
    MorseDot* _morseDot;
    MorseDash* _morseDash;
}

@end

@implementation MorseTable

-(instancetype)init{
    self = [super init];
    if(self){
        _map = [NSMutableDictionary new];
        _morseDot = [MorseDot new];
        _morseDash = [MorseDash new];
    
    }
    
    return self;
}

-(NSUInteger)count{
    return [_map count];
}

-(NSString*)keys{
    NSMutableString* keys = [NSMutableString new];
    for (NSString * key in [_map allKeys]) {
        [keys appendString:key];
    }
    return [keys copy];
}

-(void)addCode:(NSArray *)dotArray forKey:(NSString *)key{
    NSMutableArray* charsArray = [NSMutableArray new];

    [dotArray enumerateObjectsUsingBlock:^(NSNumber* obj, NSUInteger idx, BOOL *stop) {
        MorseSoundChar* sChar = [obj boolValue] ? _morseDot : _morseDash;
        [charsArray addObject:sChar];
        
    }];
    
    [_map setValue:[charsArray copy] forKey:key];
}

-(NSString*)keyForCode:(NSArray*)code
{
    for (NSString* key in _map) {
        if([_map[key] isEqualToArray:code])
            return key;
    }
    return nil;
}


-(NSArray*)codeForKey:(NSString *)key{
    return _map[key];
}

@end
