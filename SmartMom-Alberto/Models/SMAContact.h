//
//  SMAContact.h
//  SmartMom-Alberto
//
//  Created by Alberto Lagos on 09-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/ABPerson.h>
#import <AddressBook/ABMultiValue.h>
#import "NSString+ValidEmail.h"

typedef NS_ENUM(NSInteger, SMAContactType) {
    SMAContactTypeMail,
    SMAContactTypePhone,
    SMAContactTypeBoth,
    SMAContactTypeNone
};

@interface SMAContact : NSObject

+ (NSArray *)contactsFor:(NSArray *)aContacts;
- (NSString *)fullName;
- (SMAContactType)type;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *email;

@end
