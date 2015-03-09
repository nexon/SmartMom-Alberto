//
//  ViewController.m
//  SmartMom-Alberto
//
//  Created by Alberto Lagos on 09-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) SMAAddressBookManager       *abManager;
@property (strong, nonatomic) NSMutableArray              *invitesArray;
@property (weak, nonatomic)   IBOutlet NSLayoutConstraint *verticalSpaceTableViewContraint;
@property (strong, nonatomic) IBOutlet SMAGrantAccessView *grantAccessInfo;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _abManager    = [[SMAAddressBookManager alloc] init];
    _invitesArray = [NSMutableArray array];
    self.grantAccessInfo.hidden = NO;
    self.grantAccessInfo.contactsViewController = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.invitesArray.count == 0) {
        self.verticalSpaceTableViewContraint.constant = 0;
    }
    
    if(self.abManager.accessGranted) {
        NSLog(@"%s: %@", __func__, self.grantAccessInfo);
        self.grantAccessInfo.hidden = YES;
        [self.abManager askForAuthorizationWithCompletionBlock:^(BOOL success, NSArray *contacts, NSError *error) {
            if(success) {
                self.addressBook = [NSArray arrayWithArray:[SMAContact contactsFor:contacts]];
                [self.tableView reloadData];
            } else {
                NSLog(@"%s: %@", __func__, error);
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMAContact *contact = self.addressBook[indexPath.row];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressBook.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SMAContactCell = @"SMAContactCell";
    static NSString *SMAFollowCell  = @"SMAFollowCell";
    
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SMAContactCell forIndexPath:indexPath];

    [self setUIContentFor:cell atIndexPath:indexPath];
    [self setContentFor:cell atIndexPath:indexPath];
    
    return cell;
}


#pragma mark - Set Content for Cell

- (void)setContentFor:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    SMAContact *contact = self.addressBook[indexPath.row];
    cell.textLabel.text = contact.fullName;
}

- (void)setUIContentFor:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    UIButton *inviteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    inviteButton.tag       = indexPath.row;
    [inviteButton addTarget:self action:@selector(addContactToSendInvitesButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    
    inviteButton.backgroundColor = [UIColor colorWithRed:238/255.0f green:215/255.0f blue:174/255.0f alpha:1.0];
    [inviteButton setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithRed:199/255.0f green:79/255.0f blue:114/255.0f alpha:1.0]] forState:UIControlStateHighlighted];
    inviteButton.layer.cornerRadius = 5.0f;
    [inviteButton setTitle:@"Invite" forState:UIControlStateNormal];
    cell.accessoryView = inviteButton;

}


#pragma mark - Send Invites

- (void)addContactToSendInvitesButtonDidPress:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self.invitesArray addObject:self.addressBook[button.tag]];
    NSLog(@"%s: %@", __func__, self.addressBook[button.tag]);
}



@end
