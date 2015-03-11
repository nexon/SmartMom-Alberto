//
//  SmartMom_AlbertoTests.m
//  SmartMom-AlbertoTests
//
//  Created by Alberto Lagos on 09-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface SmartMom_AlbertoTests : XCTestCase

@end

@implementation SmartMom_AlbertoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLowMemoryWarning {
    [[UIApplication sharedApplication] performSelector:@selector(_performMemoryWarning)];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
