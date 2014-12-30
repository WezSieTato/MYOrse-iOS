//
//  MYOrseTests.m
//  MYOrseTests
//
//  Created by Marcin Stepnowski on 26/10/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GTalkLoginKeeper.h"
#import "MorseTableReader.h"
#import "MorseModel.h"
#import "MorseMessagePreparator.h"
#import "MorseTranslator.h"
#import "MorseReceiver.h"

@interface MYOrseTests : XCTestCase{
    MorseTable* tableMorse;
}

@end

@implementation MYOrseTests

- (void)setUp {
    [super setUp];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"morse_table" ofType:@"txt"];
    tableMorse = [[MorseTableReader new] readFile:path];
}

-(void)testTableMorse{

    XCTAssertEqual(36, [tableMorse count]);
    XCTAssertEqualObjects(@"b3zc4d5e6f7g8h9ijklmnopqrstuvw01xa2y", [tableMorse keys]);
    NSArray* cCode = [tableMorse codeForKey:@"c"];
    
    XCTAssertTrue([cCode[0] isKindOfClass:[MorseDash class]]);
//    XCTAssertTrue([cCode[1] isKindOfClass:[MorseDelayAfterMorseChar class]]);
    XCTAssertTrue([cCode[1] isKindOfClass:[MorseDot class]]);
//    XCTAssertTrue([cCode[3] isKindOfClass:[MorseDelayAfterMorseChar class]]);
    XCTAssertTrue([cCode[2] isKindOfClass:[MorseDash class]]);
//    XCTAssertTrue([cCode[5] isKindOfClass:[MorseDelayAfterMorseChar class]]);
    XCTAssertTrue([cCode[3] isKindOfClass:[MorseDot class]]);
    XCTAssertEqual(4, [cCode count]);
}

-(void)testCharacterForCode{

    NSMutableArray* code = [NSMutableArray new];
    [code addObject:[MorseDot new]];
    [code addObject:[MorseDash new]];
    [code addObject:[MorseDash new]];
    [code addObject:[MorseDash new]];
    
    NSString* key = [tableMorse keyForCode:code];
    NSString* expected = @"j";
    XCTAssertEqualObjects(key, expected);

}

-(void)testMorseMessagePreparator{
    NSString* message;
    MorseMessagePreparator* preparator = [MorseMessagePreparator new];
    [preparator setTableMorse:tableMorse];
    
    message = @"ABCD efgh IjKm";
    message = [preparator prepareMessage:message];
    XCTAssertEqualObjects(message, @"abcd efgh ijkm", @"Wielkie -> male litery test case");
    
    message = @"zazółć gęślą jaźń";
    message = [preparator prepareMessage:message];
    XCTAssertEqualObjects(message, @"zazolc gesla jazn", @"Wymiana polskich znakow test case");
    
    message = @"uwaga! kropka. przecinek, wszystko naraz !@#!@$$%^$#%^!$^%$^";
    message = [preparator prepareMessage:message];
    XCTAssertEqualObjects(message, @"uwaga kropka przecinek wszystko naraz ", @"Usuniecie znakow z poza tablicy");
    
    message = @"siem\ta teraz\nbedzie ty";
    message = [preparator prepareMessage:message];
    XCTAssertEqualObjects(message, @"siem a teraz bedzie ty", @"Białe znaki -> spacje test case");
    
}

-(void)testMorseTranslation{
    NSString* message = @"a, bo!";
    MorseTranslator* translator = [MorseTranslator new];
    [translator setTableMorse:tableMorse];
    
    NSArray* code = [translator translate:message];
    
    //a
    XCTAssertTrue([code[0] isKindOfClass:[MorseDot class]]);
//    XCTAssertTrue([code[1] isKindOfClass:[MorseDelayAfterMorseChar class]]);
    XCTAssertTrue([code[1] isKindOfClass:[MorseDash class]]);
    XCTAssertTrue([code[2] isKindOfClass:[MorseDelayAfterWord class]]);
    
    //b
    XCTAssertTrue([code[3] isKindOfClass:[MorseDash class]]);
    XCTAssertTrue([code[4] isKindOfClass:[MorseDot class]]);
    XCTAssertTrue([code[5] isKindOfClass:[MorseDot class]]);
    XCTAssertTrue([code[6] isKindOfClass:[MorseDot class]]);
    XCTAssertTrue([code[7] isKindOfClass:[MorseDelayAfterChar class]]);
    
    //o
    XCTAssertTrue([code[8] isKindOfClass:[MorseDash class]]);
//    XCTAssertTrue([code[7] isKindOfClass:[MorseDelayAfterMorseChar class]]);
    XCTAssertTrue([code[9] isKindOfClass:[MorseDash class]]);
//    XCTAssertTrue([code[9] isKindOfClass:[MorseDelayAfterMorseChar class]]);
    XCTAssertTrue([code[10] isKindOfClass:[MorseDash class]]);

    XCTAssertEqual(11, [code count]);

}

-(void)testMorseReceiver{
    MorseReceiver* receiver = [MorseReceiver receiverWithMorseTable:tableMorse];
    
    [receiver putDash];
    [receiver putDot];
    [receiver putDot];
    XCTAssertFalse([receiver putDelay]);
    
    [receiver putDot];
    [receiver putDot];
    XCTAssertFalse([receiver putDelay]);
    
    [receiver putDot];
    [receiver putDot];
    [receiver putDot];
    XCTAssertFalse([receiver putDelay]);
    
    [receiver putDash];
    [receiver putDot];
    [receiver putDash];
    [receiver putDot];
    XCTAssertFalse([receiver putDelay]);

    [receiver putDash];
    [receiver putDash];
    [receiver putDash];
    XCTAssertFalse([receiver putDelay]);
    XCTAssertFalse([receiver putDelay]);
   
    [receiver putDot];
    [receiver putDash];
    [receiver putDash];
    [receiver putDot];
    XCTAssertFalse([receiver putDelay]);
    
    [receiver putDash];
    [receiver putDash];
    [receiver putDash];
    XCTAssertFalse([receiver putDelay]);
    
    [receiver putDot];
    [receiver putDash];
    [receiver putDot];
    [receiver putDot];
    XCTAssertFalse([receiver putDelay]);
    
    [receiver putDash];
    [receiver putDash];
    [receiver putDash];
    XCTAssertFalse([receiver putDelay]);
    XCTAssertFalse([receiver putDelay]);
    XCTAssertTrue([receiver putDelay]);
    
    XCTAssertEqualObjects(receiver.message, @"disco polo");
    [receiver clear];
    
    XCTAssertEqualObjects(receiver.message, @"");
   
    [receiver putDot];
    [receiver putDash];
    XCTAssertFalse([receiver putDelay]);
    XCTAssertFalse([receiver putDelay]);
    
    [receiver putDash];
    [receiver putDot];
    [receiver putDot];
    [receiver putDot];
    XCTAssertFalse([receiver putDelay]);
    
    [receiver putDash];
    [receiver putDash];
    [receiver putDash];
    XCTAssertFalse([receiver putDelay]);
    XCTAssertFalse([receiver putDelay]);
    XCTAssertTrue([receiver putDelay]);

    XCTAssertEqualObjects(receiver.message, @"a bo");
}

@end
