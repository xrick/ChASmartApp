//
//  RecordUIView.h
//  ChASmartApp
//
//  Created by Liao Jiue-Ren on 01/10/2017.
//  Copyright © 2017 Liao Jiue-Ren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface RecordUIView : UIView
{
    
}

-(UIView*)initWithViewController:(UIViewController*)viewController action:(SEL)Method;

@property (nonatomic,retain) IBOutlet UIView * containerView;
@property (nonatomic,retain) IBOutlet UIButton * RecButton;
@property (nonatomic,retain) IBOutlet UITextView * txtView;

@end
