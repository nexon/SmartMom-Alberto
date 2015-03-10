//
//  ViewController.h
//  SmartMom-Alberto
//
//  Created by Alberto Lagos on 09-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "SMAAddressBookManager.h"
#import "SMAContact.h"
#import "SMAOtherMom.h"
#import "SMAButton.h"
#import "SMAGrantAccessView.h"

#import "UIImage+ColorFromImage.h"

typedef NS_ENUM(NSInteger, SMASegment) {
    SMASegmentInviteContacts,
    SMASegmentFollowMom
};

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView        *tableView;
@property (strong, nonatomic) NSArray                     *addressBook;

- (void)askForAuthorization;
@end

