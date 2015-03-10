//
//  SMAOtherMom.h
//  SmartMom-Alberto
//
//  Created by Alberto Lagos on 10-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SMAOtherMom : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) UIImage  *image;


+ (instancetype)momWithName:(NSString *)aName location:(NSString *)aLocation andImage:(UIImage *)aImage;
@end
