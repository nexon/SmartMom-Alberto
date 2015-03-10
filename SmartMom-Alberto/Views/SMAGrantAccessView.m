//
//  SMAGrantAccessView.m
//  SmartMom-Alberto
//
//  Created by Alberto Lagos on 09-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import "SMAGrantAccessView.h"

@interface SMAGrantAccessView()
@property (strong, nonatomic) IBOutlet UIButton    *acceptButton;
- (IBAction)didPressAcceptButton:(id)sender;
@end


@implementation SMAGrantAccessView

- (IBAction)didPressAcceptButton:(id)sender
{
    [self.contactsViewController askForAuthorization];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
