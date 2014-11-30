//
//  TableMorseParser.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 30/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "TableMorseReader.h"

@interface TableMorseReader () <NSStreamDelegate> {
    NSLock* _mutex;
    NSInputStream* _stream;
    TableMorse* _table;
}

@end

@implementation TableMorseReader

-(instancetype)init{
    self = [super init];
    if(self){
        _mutex = [NSLock new];
        
    }
    
    return self;
}

-(TableMorse*)readFile:(NSString *)path{
    
    _stream = stream;
    
    [_mutex lock];
    
    _table = [TableMorse new];
    
    NSInputStream* stream = [NSInputStream inputStreamWithFileAtPath:path];
    [stream setDelegate:self];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue, ^ {
        [_stream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
        [_stream open];
        
        // here: start the loop
        [[NSRunLoop currentRunLoop] run];
        // note: all code below this line won't be executed, because the above method NEVER returns.
    });
    
    [_mutex lock];
    [_mutex unlock];
    
    return _table;
}

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable:
            [self readFile];
            break;
            
        default:
            break;
    }
}

-(void)readFile{
    while ([self readLine]);
    [_mutex unlock];
}

-(BOOL)readLine{
    NSString* key = [self readChar];
    if(!key)
        return false;
    NSArray* array = [self readCode];
    [_table addCode:array forKey:key];
    return true;
}

-(NSString*)readChar{
    int len;
    uint8_t buf;
    len = [_stream read:&buf maxLength:1];
    if(len <= 0)
        return nil;
    NSString *s =
    [[NSString alloc] initWithBytes:&buf
                             length:1
                           encoding:NSUTF8StringEncoding];
    return s;
}

-(NSArray*)readCode{
    int len;
    uint8_t buf;
    len = [_stream read:&buf maxLength:1];
    NSMutableArray* arrayCode = [NSMutableArray new];
    NSNumber* yesNumber = @YES;
    NSNumber* noNumber = @NO;
    while (buf != '\n' && len == 1) {
        NSNumber* number = buf == '.' ? yesNumber : noNumber;
        [arrayCode addObject:number];
        len = [_stream read:&buf maxLength:1];
    }
    
    return [arrayCode copy];
}

@end
