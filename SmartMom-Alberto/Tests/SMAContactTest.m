//
//  SMAContactTest.m
//  SmartMom-Alberto
//
//  Created by Alberto Lagos on 09-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SMAContact.h"

@interface SMAContactTest : XCTestCase
@property (strong,nonatomic) SMAContact *contact;
@end

@implementation SMAContactTest

- (void)setUp {
    [super setUp];
    
    NSString *firstName = @"John";
    NSString *lastName  = @"Doe";
    
    self.contact = [[SMAContact alloc] init];
    
    self.contact.firstName = firstName;
    self.contact.lastName  = lastName;
    self.contact.phoneNumber = @"(773) 570-6321";
    self.contact.email       = @"john@doe.com";

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testThatItReturnFullName
{
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", @"John", @"Doe"];
    
    XCTAssertTrue([self.contact.fullName isEqualToString:fullName]);
}

- (void)testThatItContactWithOutContactInfo
{
    self.contact.email          = nil;
    self.contact.phoneNumber   = nil;
    XCTAssertEqual(self.contact.type, SMAContactTypeNone);
}

- (void)testThatItContactWithOnlyPhoneNumber
{
    self.contact.email       = nil;
    self.contact.phoneNumber = @"(773) 570-6321";
    
    XCTAssertEqual(self.contact.type, SMAContactTypePhone);
}

- (void)testThatItContactWithOnlyMail
{
    self.contact.phoneNumber = nil;
    self.contact.email       = @"john@doe.com";
    
    XCTAssertEqual(self.contact.type, SMAContactTypeMail);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
