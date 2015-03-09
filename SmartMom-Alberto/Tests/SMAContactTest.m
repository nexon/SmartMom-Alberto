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
    self.contact.phoneNumbers = @[@"(773) 570-6321"];
    self.contact.emails       = @[@"john@doe.com"];

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

- (void)testThatItContactWithPhoneNumberAndMail
{
    XCTAssertEqual(self.contact.type, SMAContactTypeBoth);
}

- (void)testThatItContactWithOutContactInfo
{
    self.contact.emails         = nil;
    self.contact.phoneNumbers   = nil;
    XCTAssertEqual(self.contact.type, SMAContactTypeNone);
}

- (void)testThatItContactWithOnlyPhoneNumber
{
    self.contact.emails       = nil;
    self.contact.phoneNumbers = @[@"(773) 570-6321"];
    
    XCTAssertEqual(self.contact.type, SMAContactTypePhone);
}

- (void)testThatItContactWithOnlyMail
{
    self.contact.phoneNumbers = nil;
    self.contact.emails       = @[@"john@doe.com"];
    
    XCTAssertEqual(self.contact.type, SMAContactTypeMail);
}



//- (void)testThatItSucceedGrantAccessAddressBook {
//    SMAAddressBookManager *abManager = [[SMAAddressBookManager alloc] init];
//    
//    //Expectation
//    XCTestExpectation *expectation = [self expectationWithDescription:@"Ask for access to Address Book"];
//    
//    [abManager askForAuthorizationWithCompletionBlock:^(BOOL success, NSArray *contacts, NSError *error) {
//        
//    }];
//
////        if(error)
////        {
////            NSLog(@"error is: %@", error);
////        }else{
////            NSInteger statusCode = [httpResponse statusCode];
////            XCTAssertEqual(statusCode, 200);
////            [expectation fulfill];
////        }
////        
////    }];
//    
//    
//    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
//        
//        if(error)
//        {
//            XCTFail(@"Expectation Failed with error: %@", error);
//        }
//        
//    }];
//}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
