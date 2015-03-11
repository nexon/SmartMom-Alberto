//
//  ViewController+Tests.h
//  SmartMom-Alberto
//
//  Created by Alberto Lagos on 11-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (Tests)
@property (weak, nonatomic) IBOutlet UISegmentedControl *layoutSelectorView;
@property (weak, nonatomic) IBOutlet UIButton *sendInvitationButton;
@property (strong, nonatomic) SMAAddressBookManager       *abManager;
@property (strong, nonatomic) NSMutableArray              *invitationArray;
@property (strong, nonatomic) NSMutableArray              *filterArray;
@property (strong, nonatomic) NSMutableArray              *followMoms;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint   *verticalSpaceTableViewContraint;
@property (weak, nonatomic) IBOutlet SMAGrantAccessView   *grantAccessView;
@property (nonatomic)           SMASegment                selectedSegment;

- (IBAction)changeViewDidChange:(id)sender;
- (IBAction)sendInvitationButtonDidPress:(id)send;
- (void)showSendInvitationButtonIfNeeded;
- (void)invitationButtonDidPress:(id)sender;
- (void)hideButtonDidPress:(id)sender;
- (void)followButtonDidPress:(id)sender;
- (void)setContentFor:(UITableViewCell *)cell inTableView:(UITableView*)tableView atIndexPath:(NSIndexPath *)indexPath;
- (void)setUIContentFor:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;
- (NSMutableArray *)filterContentIn:(SMASegment)aSegment withText:(NSString *)aText;

@end
