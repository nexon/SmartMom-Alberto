//
//  SMAGrantAccessView.m
//  SmartMom-Alberto
//
//  Created by Alberto Lagos on 09-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import "SMAGrantAccessView.h"

@interface SMAGrantAccessView()
@property (strong, nonatomic) IBOutlet UIButton    *acceptButton;
- (IBAction)didPressAcceptButton:(id)sender;
@end


@implementation SMAGrantAccessView

- (IBAction)didPressAcceptButton:(id)sender
{
    SMAAddressBookManager *abManager = [[SMAAddressBookManager alloc] init];
    
    [abManager askForAuthorizationWithCompletionBlock:^(BOOL success, NSArray *contacts, NSError *error) {
        if(success) {
            self.contactsViewController.addressBook = [NSArray arrayWithArray:[SMAContact contactsFor:contacts]];
            NSLog(@"%s: %@", __func__, self.contactsViewController);
            [self.contactsViewController.tableView reloadData];
            self.hidden = YES;
        } else {
            NSLog(@"%s: %@", __func__, error);
        }
    }];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
