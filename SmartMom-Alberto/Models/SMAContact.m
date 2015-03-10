//
//  SMAContact.m
//  SmartMom-Alberto
//
//  Created by Alberto Lagos on 09-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import "SMAContact.h"

@implementation SMAContact

+ (NSArray *)allContactFor:(ABRecordRef)record
{
    NSMutableArray *allContacts = [NSMutableArray array];
    NSDictionary *properties = [self dictionaryRepresentationForABPerson:record];
    NSArray *phones          = [self getPropertyFrom:ABRecordCopyValue(record, kABPersonPhoneProperty)];
    NSArray *mails           = [self getPropertyFrom:ABRecordCopyValue(record, kABPersonEmailProperty)];

    for (NSString *phone in phones) {
        SMAContact *newContact = [[SMAContact alloc] init];
        newContact.firstName = properties[@"First"];
        newContact.lastName  = properties[@"Last"];
        newContact.phoneNumber = phone;
        
        [allContacts addObject:newContact];
        
    }
    
    for (NSString *mail in mails) {
        if([mail isValidEmail]) {
            SMAContact *newContact = [[SMAContact alloc] init];
            newContact.firstName = properties[@"First"];
            newContact.lastName  = properties[@"Last"];
            newContact.email     = mail;
            
            [allContacts addObject:newContact];
        }
    }
    
   
    
    
    return allContacts;
}

+ (NSArray *)contactsFor:(NSArray *)aContacts
{
    NSMutableArray *array = [NSMutableArray array];
    for (id record in aContacts) {
        NSArray *allContacts = [SMAContact allContactFor:(ABRecordRef)record];
        
        for (SMAContact *contact in allContacts) {
            if([contact type] != SMAContactTypeNone) {
                [array addObject:contact];
            }
        }
    }
    return array;
}

+ (NSDictionary*)dictionaryRepresentationForABPerson:(ABRecordRef) person
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    for ( int32_t propertyIndex = kABPersonFirstNameProperty; propertyIndex <= kABPersonSocialProfileProperty; propertyIndex ++ )
    {
        NSString* propertyName = CFBridgingRelease(ABPersonCopyLocalizedPropertyName(propertyIndex));
        id value = CFBridgingRelease(ABRecordCopyValue(person, propertyIndex));
        
        if ( value )
            [dictionary setObject:value forKey:propertyName];
    }
    
    return dictionary;
}

+ (NSArray *)getPropertyFrom:(ABMultiValueRef)record
{

    NSMutableArray *array = [NSMutableArray array];

    for (CFIndex i = 0; i<ABMultiValueGetCount(record);i++) {
        [array  addObject:CFBridgingRelease(ABMultiValueCopyValueAtIndex(record, i))];
    }

    CFRelease(record);
    
    return array;
}

#pragma mark - Custom getters

- (SMAContactType)type
{
    if(self.email) {
        return SMAContactTypeMail;
    } else if(self.phoneNumber) {
        return SMAContactTypePhone;
    } else {
        return SMAContactTypeNone;
    }
}

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}
@end
