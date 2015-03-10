//
//  SMAOtherMom.m
//  SmartMom-Alberto
//
//  Created by Alberto Lagos on 10-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import "SMAOtherMom.h"

@implementation SMAOtherMom

+ (instancetype)momWithName:(NSString *)aName location:(NSString *)aLocation andImage:(UIImage *)aImage
{
    SMAOtherMom *newOtherMom = [[[self class] alloc] init];
    
    newOtherMom.name     = aName;
    newOtherMom.location = aLocation;
    newOtherMom.image    = aImage;
    
    return newOtherMom;
}

@end
