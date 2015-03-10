//
//  NSString+ValidEmail.m
//  SmartMom-Alberto
//
//  Created by Alberto Lagos on 10-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import "NSString+ValidEmail.h"

@implementation NSString (ValidEmail)

- (BOOL) isValidEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:self];
    return isValid;
}
@end
