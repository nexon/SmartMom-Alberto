//
//  ViewControllerTests.m
//  SmartMom-Alberto
//
//  Created by Alberto Lagos on 11-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "SMAContact.h"
#import "ViewController.h"
#import "ViewController+Tests.h"
#define MAX_CONTACT 10;

@interface ViewControllerTests : XCTestCase

@property (strong, nonatomic) ViewController *controller;
@property (strong, nonatomic) NSMutableArray *mockContacts;
@property (strong, nonatomic) NSMutableArray *mockSmartMoms;

@end

@implementation ViewControllerTests

- (void)setupContacts
{
    int max = MAX_CONTACT;
    self.mockContacts = [NSMutableArray array];
    NSArray *names = @[@"John", @"Laurel", @"Bass", @"Brad", @"Jose", @"Mike", @"Madonna", @"Courtney", @"Jack", @"Jack Bauer", @"Sif",
                       @"Rand", @"Raphael", @"Jess", @"Emmett", @"Martin", @"Flav", @"Jack Bauer"];
    
    for (int i = 0; i<max; i++) {
        id mockContact = [OCMockObject mockForClass:[SMAContact class]];
        
        NSString *fullName = names[i];
        NSString *phone = [NSString stringWithFormat:@"333-444-555"];
        NSString *email = [NSString stringWithFormat:@"email_%i@test.com", i];
        
        if(i%2 == 0) {
           [[[mockContact stub] andReturnValue:OCMOCK_VALUE(email)] email];
            [((SMAContact *)[[mockContact stub] andReturnValue:OCMOCK_VALUE(SMAContactTypeMail)]) type];
        } else {
            [[[mockContact stub] andReturnValue:OCMOCK_VALUE(phone)] phoneNumber];
            [((SMAContact *)[[mockContact stub] andReturnValue:OCMOCK_VALUE(SMAContactTypePhone)]) type];
        }
        
        [[[mockContact stub] andReturnValue:OCMOCK_VALUE(fullName)] valueForKey:@"fullName"];
        [[[mockContact stub] andReturnValue:OCMOCK_VALUE(fullName)] fullName];
        
        [self.mockContacts addObject:mockContact];
    }
    
}

- (void)setupSmartMoms
{
    int max = MAX_CONTACT;
    self.mockSmartMoms = [NSMutableArray array];
    NSArray *names = @[@"Rand", @"Raphael", @"Jess", @"Emmett", @"Martin", @"Jack Bauer", @"Mike", @"Madonna", @"Courtney", @"Jack", @"Arnol", @"Sif",@"John", @"Laurel", @"Bass", @"Brad", @"Jose"];
    
    for(int i = 0; i<max; i++) {
        id mockMom = [OCMockObject mockForClass:[SMAOtherMom class]];
        
        NSString *name     = names[i];
        NSString *location = [NSString stringWithFormat:@"Chicago, IL"];

        
        [[[mockMom stub] andReturnValue:OCMOCK_VALUE(name)] name];
        [(SMAOtherMom *)[[mockMom stub] andReturnValue:OCMOCK_VALUE(location)] location];
        [[[mockMom stub] andReturnValue:@(NO)] isFollowedByMe];
        [[mockMom expect] setFollowing:@(YES)];
        
        [self.mockSmartMoms addObject:mockMom];
    }
    
}
- (void)setUp {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.controller = [storyboard instantiateViewControllerWithIdentifier:@"inviteFriends"];
    [self.controller performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    [self setupContacts];
    [self setupSmartMoms];
    
    self.controller.addressBook = self.mockContacts;
    self.controller.followMoms  = self.mockSmartMoms;
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testThatItStartWithInviteContactsView
{
    XCTAssertEqual(self.controller.selectedSegment, SMASegmentInviteContacts);
}

- (void)testThatItChangesView
{
    [self changeSegmentedControlTo:SMASegmentFollowMom];
    XCTAssertEqual(self.controller.selectedSegment, SMASegmentFollowMom);
    
}

#pragma mark - UITableView (Invite Contacts)

- (void)testThatViewConformsToUITableViewDataSource
{
    XCTAssertTrue([self.controller conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}

- (void)testThatTableViewHasDataSource
{
    XCTAssertNotNil(self.controller.tableView.dataSource, @"Table datasource cannot be nil");
}

- (void)testThatViewConformsToUITableViewDelegate
{
    XCTAssertTrue([self.controller conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}

- (void)testTableViewIsConnectedToDelegate
{
    XCTAssertNotNil(self.controller.tableView.delegate, @"Table delegate cannot be nil");
}

- (void)testTableViewNumberOfRowsInSection
{
    NSInteger expectedRows = self.controller.addressBook.count;
    XCTAssertTrue([self.controller tableView:self.controller.tableView numberOfRowsInSection:0] == expectedRows, @"Table has %ld rows but it should have %ld", (long)[self.controller tableView:self.controller.tableView numberOfRowsInSection:0], (long)expectedRows);
}

- (void)testInvitationButtonDidPress
{
    [self.controller.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    UITableViewCell *cell = [self.controller.tableView cellForRowAtIndexPath:indexPath];
    
    SMAButton *inviteButtonCell = (SMAButton*)[cell accessoryView];
    [self.controller invitationButtonDidPress:inviteButtonCell];
    
    XCTAssertEqual(self.controller.invitationArray.count, 1);
    
    [self.controller invitationButtonDidPress:inviteButtonCell];
    
    XCTAssertEqual(self.controller.invitationArray.count, 0);
}

#pragma mark - UITableView (Follow SmartMoms)

- (void)testTableViewNumberOfRowsInSectionForFollowSmartMoms
{
    [self changeSegmentedControlTo:SMASegmentFollowMom];
    
    NSInteger expectedRows = self.controller.followMoms.count;
    XCTAssertTrue([self.controller tableView:self.controller.tableView numberOfRowsInSection:0] == expectedRows, @"Table has %ld rows but it should have %ld", (long)[self.controller tableView:self.controller.tableView numberOfRowsInSection:0], (long)expectedRows);
}

- (void)testHideButtonOfFollowSmartMomsCell
{
    
    [self changeSegmentedControlTo:SMASegmentFollowMom];
    NSUInteger totalCount = self.controller.followMoms.count;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.controller.tableView cellForRowAtIndexPath:indexPath];
    
    SMAButton *hideButtonCell = (SMAButton*)[cell accessoryView].subviews[0];
    [self.controller hideButtonDidPress:hideButtonCell];
    
    XCTAssertEqual(self.controller.followMoms.count, totalCount - 1);

}

- (void)testFollowButton
{
    [self changeSegmentedControlTo:SMASegmentFollowMom];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.controller.tableView cellForRowAtIndexPath:indexPath];
    SMAButton *followButtonCell = (SMAButton*)[cell accessoryView].subviews[1];
    
    id mock = self.controller.followMoms[followButtonCell.tag];
    
    [self.controller followButtonDidPress:followButtonCell];
    
    [mock verify];
}

- (void)testSearchContacts
{
    [self activateSearchDisplayControllerWithText:@"John"];
    [self.controller.searchDisplayController.searchBar becomeFirstResponder];

    XCTAssertEqual(self.controller.filterArray.count, 1);
}

- (void)testSearchOtherMoms
{
   
    [self activateSearchDisplayControllerWithText:@"Jack"];
    XCTAssertEqual(self.controller.filterArray.count, 2);
}


#pragma mark - Reusable methods

- (void)changeSegmentedControlTo:(SMASegment)aSegment
{
    // Change the layout to smart moms
    NSInteger selectedSegment = aSegment;
    id segmentedControlMock = [OCMockObject mockForClass:[UISegmentedControl class]];
    [[[segmentedControlMock stub] andReturnValue:OCMOCK_VALUE(selectedSegment)] selectedSegmentIndex];
    
    [self.controller changeViewDidChange:segmentedControlMock];
}

- (void)activateSearchDisplayControllerWithText:(NSString *)aText
{
    [self.controller.searchDisplayController setActive: YES animated: YES];
    self.controller.searchDisplayController.searchBar.hidden = NO;
    self.controller.searchDisplayController.searchBar.text = aText;
    [self.controller.searchDisplayController.searchBar becomeFirstResponder];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
