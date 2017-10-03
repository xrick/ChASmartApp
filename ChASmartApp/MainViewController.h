//
//  ViewController.h
//  ChASmartApp
//
//  Created by Liao Jiue-Ren on 29/09/2017.
//  Copyright © 2017 Liao Jiue-Ren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Speech/Speech.h>
//#import "Models/RecordUIView.h"

@interface MainViewController : UIViewController<SFSpeechRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    SFSpeechRecognizer *speechRecognizer;
    SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
    SFSpeechRecognitionTask *recognitionTask;
    AVAudioEngine *audioEngine;
    //RecordingButton * _recBtnContainer;
    
}

-(void)SetButton;

-(void)SetTextView;
//@property (nonatomic) int MessageCount;
//@property (nonatomic,retain) RecordUIView * recordView;
@property (nonatomic,retain) UIButton * recButton;
@property (nonatomic,retain) UITextView * txtView;
@end

