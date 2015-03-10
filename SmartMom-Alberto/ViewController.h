//
//  ViewController.h
//  SmartMom-Alberto
//
//  Created by Alberto Lagos on 09-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAAddressBookManager.h"
#import "SMAContact.h"
#import "SMAGrantAccessView.h"

#import "UIImage+ColorFromImage.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView        *tableView;
@property (strong, nonatomic) NSArray                     *addressBook;

- (void)askForAuthorization;
@end

