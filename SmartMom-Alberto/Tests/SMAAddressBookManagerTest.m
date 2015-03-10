//
//  SMAAddressBookManagerTest.m
//  SmartMom-Alberto
//
//  Created by Alberto Lagos on 09-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "SMAAddressBookManager.h"


@interface SMAAddressBookManagerTest : XCTestCase
@end

@implementation SMAAddressBookManagerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testThatItAskAuthorizationForAddressBook {
    id abManager = [OCMockObject mockForClass:[SMAAddressBookManager class]];
     XCTestExpectation *expectation = [self expectationWithDescription:@"Ask for access to Address Book and return Array of all contacts (ABPerson)"];
    
    void (^invocation_block)(NSInvocation *) = ^(NSInvocation *invocation) {
        void (^successBlock)(BOOL success, NSArray *contacts, NSError *error) = nil;
        
        [invocation getArgument:&successBlock atIndex:2];
        
        successBlock(true,  @[@"Contact 1", @"Contact 2"], nil);
    };
    
    [[[abManager expect] andDo:invocation_block] askForAuthorizationWithCompletionBlock:[OCMArg any]];
    
    [abManager askForAuthorizationWithCompletionBlock:^(BOOL success, NSArray *contacts, NSError *error) {
        XCTAssert(success);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        NSLog(@"Waiting...");
    }];
   
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
