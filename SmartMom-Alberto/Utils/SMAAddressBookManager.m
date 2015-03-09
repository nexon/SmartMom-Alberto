//
//  SMAAddressBookManager.m
//  SmartMom-Alberto
//
//  Created by Alberto Lagos on 09-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import "SMAAddressBookManager.h"

@interface SMAAddressBookManager()
@property (nonatomic) ABAddressBookRef addressBook;
@end

@implementation SMAAddressBookManager

- (instancetype)init
{
    self = [super init];
    if(self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _accessGranted           = [defaults boolForKey:@"SMAAccessGranted"];
    }
    
    return self;
    
}


#pragma mark - do authorization

- (void)askForAuthorizationWithCompletionBlock:(void (^)( BOOL success, NSArray *contacts, NSError *error))completionBlock
{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    NSError __block *error;
    
    switch (status) {
        case kABAuthorizationStatusDenied:
        case kABAuthorizationStatusRestricted: {
            error = [NSError errorWithDomain:@"access.addressbook" code:1 userInfo:@{NSLocalizedDescriptionKey:@"Access was denied/restricted"}];
            self.accessGranted = NO;
            completionBlock(false, nil, error);
            return;
        }
            
            break;
            
        case kABAuthorizationStatusAuthorized:
        case kABAuthorizationStatusNotDetermined: {
            CFErrorRef  _err = nil;
            ABAddressBookRef addressbook = ABAddressBookCreateWithOptions(nil, &_err);
            
            if(addressbook == nil) {
                error = CFBridgingRelease(_err);
                self.accessGranted = NO;
                completionBlock(false, nil, error);
                return;
            }
            
            ABAddressBookRequestAccessWithCompletion(addressbook, ^(bool granted, CFErrorRef _err) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(granted) {
                        self.addressBook = ABAddressBookCreateWithOptions(NULL, nil);
                        self.accessGranted = granted;
                        NSArray *contacts = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(self.addressBook));
                        completionBlock(true, contacts, nil);
                        
                    } else {
                        error = CFBridgingRelease(_err);
                        self.accessGranted = NO;
                        completionBlock(false, nil, error);
                        
                    }
                });
            });
            
        }
            
        default:
            break;
    }
}


#pragma mark - Custom setters

- (void)setAccessGranted:(BOOL)accessGranted
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:accessGranted forKey:@"SMAAccessGranted"];
    _accessGranted           = accessGranted;
    [defaults synchronize];
}
@end
