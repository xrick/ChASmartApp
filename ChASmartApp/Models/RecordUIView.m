//
//  RecordUIView.m
//  ChASmartApp
//
//  Created by Liao Jiue-Ren on 01/10/2017.
//  Copyright © 2017 Liao Jiue-Ren. All rights reserved.
//

#import "RecordUIView.h"

@implementation RecordUIView
@synthesize containerView;
@synthesize RecButton;
@synthesize txtView;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UIView*)initWithViewController:(UIViewController *)viewController action:(SEL)Method
{
    self.containerView = [[[NSBundle mainBundle] loadNibNamed:@"RecordUIView" owner:self options:nil]firstObject];
    [self.RecButton addTarget:viewController action:Method forControlEvents:UIControlEventTouchUpInside];
    return self.containerView;
}

@end
