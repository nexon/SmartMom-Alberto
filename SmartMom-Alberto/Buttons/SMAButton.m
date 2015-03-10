//
//  SMAButton.m
//  SmartMom-Alberto
//
//  Created by Alberto Lagos on 10-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import "SMAButton.h"
#define SELECTED_COLOR [UIImage imageFromColor:[UIColor colorWithRed:199/255.0f green:79/255.0f blue:114/255.0f alpha:1.0]]
#define NORMAL_COLOR   [UIImage imageFromColor:[UIColor colorWithRed:238/255.0f green:215/255.0f blue:174/255.0f alpha:1.0]]

@implementation SMAButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setBackgroundImage:NORMAL_COLOR forState:UIControlStateNormal];
        [self setBackgroundImage:SELECTED_COLOR forState:UIControlStateSelected];
        [self setBackgroundImage:SELECTED_COLOR forState:UIControlStateHighlighted];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0f;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if(self) {
        [self setBackgroundImage:NORMAL_COLOR forState:UIControlStateNormal];
        [self setBackgroundImage:SELECTED_COLOR forState:UIControlStateSelected];
        [self setBackgroundImage:SELECTED_COLOR forState:UIControlStateHighlighted];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0f;
    }
    
    return self;
}
@end
