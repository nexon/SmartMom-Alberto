//
//  SMAContact.m
//  SmartMom-Alberto
//
//  Created by Alberto Lagos on 09-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import "SMAContact.h"

@implementation SMAContact

+ (instancetype)contactFor:(ABRecordRef)record
{
    NSDictionary *properties = [self dictionaryRepresentationForABPerson:record];
    NSArray *phone          = [self getPropertyFrom:ABRecordCopyValue(record, kABPersonPhoneProperty)];
    NSArray *mail           = [self getPropertyFrom:ABRecordCopyValue(record, kABPersonEmailProperty)];
    
    SMAContact *newContact = [[SMAContact alloc] init];
    newContact.firstName = properties[@"First"];
    newContact.lastName  = properties[@"Last"];
    newContact.phoneNumbers = phone;
    newContact.emails = mail;
    
    return newContact;
}

+ (NSArray *)contactsFor:(NSArray *)aContacts
{
    NSMutableArray *array = [NSMutableArray array];
    for (id record in aContacts) {
        SMAContact *contact = [SMAContact contactFor:(ABRecordRef)record];
        if([contact type] != SMAContactTypeNone)
            [array addObject:contact];
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
    if(self.phoneNumbers.count > 0 && self.emails.count > 0) {
       return SMAContactTypeBoth;
    } else {
        if(self.emails.count > 0) {
            return SMAContactTypeMail;
        } else if(self.phoneNumbers.count > 0) {
            return SMAContactTypePhone;
        } else {
            return SMAContactTypeNone;
        }
    }
}

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}
@end
