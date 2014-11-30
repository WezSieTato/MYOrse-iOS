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
#import "TableMorseReader.h"
#import "MorseModel.h"

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
    TableMorse* tableMorse = [[TableMorseReader new] readFile:path];
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

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
