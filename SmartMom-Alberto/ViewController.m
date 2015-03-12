//
//  ViewController.m
//  SmartMom-Alberto
//
//  Created by Alberto Lagos on 09-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import "ViewController.h"

static NSString *SMAContactCell = @"SMAContactCell";
static NSString *SMAFollowCell  = @"SMAFollowCell";

@interface ViewController ()
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
- (IBAction)connectToFacebookDidPress:(id)sender;
- (void)showSendInvitationButtonIfNeeded;
- (void)invitationButtonDidPress:(id)sender;
- (void)hideButtonDidPress:(id)sender;
- (void)followButtonDidPress:(id)sender;
- (void)setContentFor:(UITableViewCell *)cell inTableView:(UITableView*)tableView atIndexPath:(NSIndexPath *)indexPath;
- (void)setUIContentFor:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;
- (NSMutableArray *)filterContentIn:(SMASegment)aSegment withText:(NSString *)aText;
@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        _abManager       = [[SMAAddressBookManager alloc] init];
        _invitationArray = [NSMutableArray array];
        _filterArray     = [NSMutableArray array];
        _selectedSegment = SMASegmentInviteContacts;
        _followMoms = [NSMutableArray arrayWithArray:@[  [SMAOtherMom momWithName:@"Shannon Leigh" location:@"Denver, CO" andImage:nil],
                                                         [SMAOtherMom momWithName:@"Meredith Overmyer" location:@"Chicago, IL" andImage:nil],
                                                         [SMAOtherMom momWithName:@"Amber Colvard" location:@"Colorado Springs, CO" andImage:nil],
                                                         [SMAOtherMom momWithName:@"Allie Siarto" location:@"Lansing, MI" andImage:nil],
                                                         [SMAOtherMom momWithName:@"Kim Rothwell" location:@"Glen Ellyn, IL" andImage:nil],
                                                         [SMAOtherMom momWithName:@"Ashlee Finley" location:@"Dallas, TX" andImage:nil],
                                                         [SMAOtherMom momWithName:@"Shannon Leigh" location:@"Denver, CO" andImage:nil],
                                                         ]];
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.grantAccessView.contactsViewController = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.invitationArray.count == 0) {
        self.verticalSpaceTableViewContraint.constant = 0;
    }
    
    if(self.abManager.accessGranted) {
        [self askForAuthorization];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Ask for Authorization 

- (void)askForAuthorization
{
    [self.abManager askForAuthorizationWithCompletionBlock:^(BOOL success, NSArray *contacts, NSError *error) {
        if(success) {
            self.addressBook = [NSArray arrayWithArray:[SMAContact contactsFor:contacts]];
            self.grantAccessView.hidden = YES;
            [self.tableView reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authorization Error"
                                                            message:error.localizedDescription
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(self.selectedSegment == SMASegmentInviteContacts) {
        SMAContact *contact;
        
        if(tableView == self.searchDisplayController.searchResultsTableView) {
            contact  = self.filterArray[indexPath.row];
        } else {
            contact = self.addressBook[indexPath.row];
        }
    } else {
        SMAOtherMom *mom;
        if(tableView == self.searchDisplayController.searchResultsTableView) {
            mom  = self.filterArray[indexPath.row];
        } else {
            mom  = self.followMoms[indexPath.row];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView) return self.filterArray.count;
    
    return (self.selectedSegment == SMASegmentInviteContacts) ? self.addressBook.count : self.followMoms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
 
    if(self.selectedSegment == SMASegmentInviteContacts) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:SMAContactCell forIndexPath:indexPath];
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:SMAFollowCell forIndexPath:indexPath];
    }

    [self setContentFor:cell inTableView:tableView atIndexPath:indexPath];
    
    return cell;
}


#pragma mark - Set Content for Cell

- (void)setContentFor:(UITableViewCell *)cell inTableView:(UITableView*)tableView atIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.selectedSegment == SMASegmentInviteContacts) {
        SMAContact *contact;
        
        if(tableView == self.searchDisplayController.searchResultsTableView) {
            contact  = self.filterArray[indexPath.row];
        } else {
            contact = self.addressBook[indexPath.row];
        }
        
        NSString *type = contact.type == SMAContactTypeMail ? @"(E)" : @"(P)";
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", contact.fullName, type];
        
        [self setUIContentFor:cell atIndexPath:indexPath withObject:contact];
        
    } else {
        SMAOtherMom *mom;
        if(tableView == self.searchDisplayController.searchResultsTableView) {
            mom  = self.filterArray[indexPath.row];
        } else {
            mom  = self.followMoms[indexPath.row];
        }
        cell.textLabel.text = mom.name;
        cell.detailTextLabel.text = mom.location;
        if(mom.image)
            cell.imageView.image = mom.image;
        
        [self setUIContentFor:cell atIndexPath:indexPath withObject:mom];
    }
}

- (void)setUIContentFor:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    if([cell.reuseIdentifier isEqualToString:SMAContactCell]) {
        SMAContact *contact = object;
        SMAButton *inviteButton = [[SMAButton alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
        inviteButton.tag       = indexPath.row;
        
        [inviteButton addTarget:self
                         action:@selector(invitationButtonDidPress:)
               forControlEvents:UIControlEventTouchUpInside];
        
        [inviteButton setTitle:@"Invite" forState:UIControlStateNormal];
        inviteButton.selected = [self.invitationArray containsObject:contact];
        cell.accessoryView = inviteButton;
    } else {
        SMAOtherMom *mom = object;
        UIView *containerButton = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 25)];
        
        SMAButton *hideButton   = [[SMAButton alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
        hideButton.tag          =  indexPath.row;
        [hideButton setTitle:@"Hide" forState:UIControlStateNormal];
        [hideButton addTarget:self
                       action:@selector(hideButtonDidPress:)
             forControlEvents:UIControlEventTouchUpInside];
        
        
        SMAButton *followButton = [[SMAButton alloc] initWithFrame:CGRectMake(100, 0, 80, 25)];
        [followButton setTitle:@"Follow" forState:UIControlStateNormal];
        [followButton addTarget:self
                         action:@selector(followButtonDidPress:)
               forControlEvents:UIControlEventTouchUpInside];
        followButton.tag  = indexPath.row;
        followButton.selected  = mom.isFollowedByMe;
        
        [containerButton addSubview:hideButton];
        [containerButton addSubview:followButton];
        
        cell.accessoryView = containerButton;
        
    }
}

#pragma mark - Send Invites / Buttons in Cells

- (void)invitationButtonDidPress:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected  = !button.selected;
    SMAContact  *contact;
    
    if(self.searchDisplayController.active) {
        contact = self.filterArray[button.tag];
    } else {
        contact = self.addressBook[button.tag];
    }
   
    if(contact.type == SMAContactTypeMail) {
        if(button.selected) {
            [self.invitationArray addObject:contact];
            if(self.verticalSpaceTableViewContraint.constant == 0) {
                self.verticalSpaceTableViewContraint.constant = 43;
                self.sendInvitationButton.hidden = NO;
            }
        } else {
            [self.invitationArray removeObject:self.addressBook[button.tag]];
            if(self.invitationArray.count == 0) {
                self.verticalSpaceTableViewContraint.constant = 0;
                self.sendInvitationButton.hidden = YES;
            }
            
        }
        
        NSString *textButton = [NSString stringWithFormat:@"Send %li Invitations", self.invitationArray.count];
        [self.sendInvitationButton setTitle:textButton forState:UIControlStateNormal];
        [self.sendInvitationButton setTitle:textButton forState:UIControlStateSelected];
        
        [self.tableView reloadData];
        
    } else {
        NSString *messageText = [NSString stringWithFormat:@"Hey! %@ (%@) please join SmartMom", contact.fullName, contact.phoneNumber];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please join SmartMom"
                                                        message:messageText
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        
        button.selected = !button.selected;
    }
}

- (void)hideButtonDidPress:(id)sender
{
    UIButton *button = (UIButton *)sender;
    SMAOtherMom *mom;
    
    if(self.searchDisplayController.active) {
        mom = self.filterArray[button.tag];
        [self.filterArray removeObjectAtIndex:button.tag];
        [self.searchDisplayController.searchResultsTableView reloadData];
    } else {
        mom = self.followMoms[button.tag];
    }
    
    [self.followMoms removeObject:mom];
    [self.tableView reloadData];
}

- (void)followButtonDidPress:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected  = !button.selected;
    SMAOtherMom *mom;
    
    if(self.searchDisplayController.active) {
        mom = self.filterArray[button.tag];
    } else {
        mom = self.followMoms[button.tag];
        
    }

    mom.following = button.selected;
    
    [self.tableView reloadData];
    
}

#pragma mark - Change selection of UISegmentedControl

- (IBAction)changeViewDidChange:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if(SMASegmentInviteContacts == selectedSegment) {
        self.selectedSegment = SMASegmentInviteContacts;
    } else {
        self.selectedSegment = SMASegmentFollowMom;
        
        // Here we search all friends in facebook
        
        if([FBSession activeSession].isOpen) {
            [FBRequestConnection startWithGraphPath:@"/me/friends?fields=picture,name" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if(!error) {
                    for (id user in result[@"data"]) {
                        SMAOtherMom *mom = [[SMAOtherMom alloc] init];
                        mom.name = user[@"name"];
                        mom.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user[@"picture"][@"data"][@"url"]]]];
                        [self.followMoms insertObject:mom atIndex:0];
                        [self.tableView reloadData];
                    }
                } else {
                    NSLog(@"%s: Error", __func__);
                }
            }];
            
            
        }
        
    }
    
    [self showSendInvitationButtonIfNeeded];
    [self.tableView reloadData];
}

#pragma mark - Filtering Table

- (NSMutableArray *)filterContentIn:(SMASegment)aSegment withText:(NSString *)aText
{
    [self.filterArray  removeAllObjects];
    NSPredicate *predicate;
    
    if(self.selectedSegment == SMASegmentInviteContacts) {
        predicate = [NSPredicate predicateWithFormat:@"SELF.fullName contains[c] %@",aText];
        return [NSMutableArray arrayWithArray:[self.addressBook filteredArrayUsingPredicate:predicate]];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",aText];
        return [NSMutableArray arrayWithArray:[self.followMoms filteredArrayUsingPredicate:predicate]];
    }
}

#pragma mark - UISearchDisplayController Delegate Methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    self.filterArray = [self filterContentIn:self.selectedSegment withText:searchString];
    return YES;
}

#pragma mark - For sending invitations

- (void)showSendInvitationButtonIfNeeded
{
    if(self.invitationArray.count > 0 && self.selectedSegment == SMASegmentInviteContacts) self.sendInvitationButton.hidden = NO;
    else {
        self.sendInvitationButton.hidden = YES;
        self.verticalSpaceTableViewContraint.constant = 0;
    }
}

- (IBAction)sendInvitationButtonDidPress:(id)send
{
    if([MFMailComposeViewController canSendMail]) {
        // Here we should iterate like a map/filter (Ruby)
        
        NSMutableArray *recipients = [NSMutableArray array];
        
        for (SMAContact *contact in self.invitationArray) {
            [recipients addObject:contact.email];
        }
        

        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"Please join SmartMoms"];
        [mailViewController setToRecipients:recipients];
        [mailViewController setMessageBody:@"Please join SmartMoms....this is awesome..." isHTML:NO];
        
        [self presentViewController:mailViewController animated:YES completion:^{
            [self.invitationArray removeAllObjects];
            [self.tableView reloadData];
            [self showSendInvitationButtonIfNeeded];
        }];
    } else {
        NSString *messageText = [NSString stringWithFormat:@"We can't send the emails (%li)", self.invitationArray.count];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't send emails"
                                                        message:messageText
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
        
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    [self.tableView reloadData];
}

#pragma mark - Facebook Button

- (void)connectToFacebookDidPress:(id)sender
{
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_friends"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
    }
}
@end
