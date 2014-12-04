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

@interface MYOrseTests : XCTestCase{
}

@end

@implementation MYOrseTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

-(void)testTableMorse{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"morse_table" ofType:@"txt"];
    MorseTable* tableMorse = [[MorseTableReader new] readFile:path];
    XCTAssertEqual(36, [tableMorse count]);
    XCTAssertEqualObjects(@"b3zc4d5e6f7g8h9ijklmnopqrstuvw01xa2y", [tableMorse keys]);
    NSArray* cCode = [tableMorse codeForKey:@"c"];
    XCTAssertTrue([cCode[0] isKindOfClass:[MorseDash class]]);
    XCTAssertTrue([cCode[1] isKindOfClass:[MorseDelayAfterMorseChar class]]);
    XCTAssertTrue([cCode[2] isKindOfClass:[MorseDot class]]);
    XCTAssertTrue([cCode[3] isKindOfClass:[MorseDelayAfterMorseChar class]]);
    XCTAssertTrue([cCode[4] isKindOfClass:[MorseDash class]]);
    XCTAssertTrue([cCode[5] isKindOfClass:[MorseDelayAfterMorseChar class]]);
    XCTAssertTrue([cCode[6] isKindOfClass:[MorseDot class]]);
    XCTAssertEqual(7, [cCode count]);
}

-(void)testMorseMessagePreparator{
    NSString* message;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"morse_table" ofType:@"txt"];
    MorseTable* tableMorse = [[MorseTableReader new] readFile:path];
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
    NSString* path = [[NSBundle mainBundle] pathForResource:@"morse_table" ofType:@"txt"];
    MorseTable* tableMorse = [[MorseTableReader new] readFile:path];
    NSString* message = @"a, bo!";
    MorseTranslator* translator = [MorseTranslator new];
    [translator setTableMorse:tableMorse];
    
    NSArray* code = [translator translate:message];
    
    //a
    XCTAssertTrue([code[0] isKindOfClass:[MorseDot class]]);
    XCTAssertTrue([code[1] isKindOfClass:[MorseDelayAfterMorseChar class]]);
    XCTAssertTrue([code[2] isKindOfClass:[MorseDash class]]);
    XCTAssertTrue([code[3] isKindOfClass:[MorseDelayAfterWord class]]);
    
    //b
    XCTAssertTrue([code[4] isKindOfClass:[MorseDash class]]);
    XCTAssertTrue([code[5] isKindOfClass:[MorseDelayAfterChar class]]);
    
    //o
    XCTAssertTrue([code[6] isKindOfClass:[MorseDash class]]);
    XCTAssertTrue([code[7] isKindOfClass:[MorseDelayAfterMorseChar class]]);
    XCTAssertTrue([code[8] isKindOfClass:[MorseDash class]]);
    XCTAssertTrue([code[9] isKindOfClass:[MorseDelayAfterMorseChar class]]);
    XCTAssertTrue([code[10] isKindOfClass:[MorseDash class]]);

    XCTAssertEqual(11, [code count]);

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
