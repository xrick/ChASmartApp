//
//  BaseLayoutViewController.h
//  ChASmartApp
//
//  Created by Liao Jiue-Ren on 02/10/2017.
//  Copyright © 2017 Liao Jiue-Ren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LayoutDelegate.h"
@interface BaseLayoutViewController : UIViewController

@property (nonatomic,assign) id<LayoutDelegate> delegate;

//init method
- (id)initWithFrame:(CGRect)frame;

//TextToSpeech
- (void)uiTextToSpeechWithText:(NSString *)text;
- (void)uiTextToSpeechWithText:(NSString *)text characterRange:(NSRange)range;

//SpeechToText
- (void)uiStartRecording;
- (void)uiStopRecording;
- (void)uiCancelRecording;

//Agent
- (void)uiAgentQuestionWithQuestion:(NSString *)questionStr;

//Setting
- (void)settingTapped:(UIButton *)sender;

//SpeakButton
- (void)updateSpeakButton;

@end
