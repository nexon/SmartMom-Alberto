//
//  SMAAddressBookManager.h
//  SmartMom-Alberto
//
//  Created by Alberto Lagos on 09-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface SMAAddressBookManager : NSObject
@property (nonatomic) BOOL             accessGranted;

- (void)askForAuthorizationWithCompletionBlock:(void (^)( BOOL success, NSArray *contacts, NSError *error))completionBlock;
@end
