//
//  ViewController.m
//  ChASmartApp
//
//  Created by Liao Jiue-Ren on 29/09/2017.
//  Copyright © 2017 Liao Jiue-Ren. All rights reserved.
//

#import "MainViewController.h"
#import "STBubbleTableViewCell.h"


@interface MainViewController ()
@property (nonatomic, strong) NSMutableArray * MessageArray;
@end

@implementation MainViewController
@synthesize recButton;
@synthesize txtView;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetButton];
    [self SetTextView];
    self.MessageArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
    //add a button to table footer
    //_recBtnContainer = [[RecordingButton alloc]init];
    //_recBtnContainer.RecordingBtn = [[[NSBundle mainBundle] loadNibNamed:@"RecordingButton" owner:_recBtnContainer options:nil]firstObject];
    //NSLog(@"The total components is %d",coms.count);
    
    speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"]];
    speechRecognizer.delegate = self;
    
    // Request the authorization to make sure the user is asked for permission so you can
    // get an authorized response, also remember to change the .plist file, check the repo's
    // readme file or this project's info.plist
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        switch (status) {
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                NSLog(@"Authorized");
                break;
            case SFSpeechRecognizerAuthorizationStatusDenied:
                NSLog(@"Denied");
                break;
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                NSLog(@"Not Determined");
                break;
            case SFSpeechRecognizerAuthorizationStatusRestricted:
                NSLog(@"Restricted");
                break;
            default:
                break;
        }
    }];
}

/*!
 * @brief Starts listening and recognizing user input through the
 * phone's microphone
 */

- (void)startListening {
    
    // Initialize the AVAudioEngine
    audioEngine = [[AVAudioEngine alloc] init];
    
    // Make sure there's not a recognition task already running
    if (recognitionTask) {
        [recognitionTask cancel];
        recognitionTask = nil;
    }
    
    // Starts an AVAudio Session
    NSError *error;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    
    // Starts a recognition process, in the block it logs the input or stops the audio
    // process if there's an error.
    recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    AVAudioInputNode *inputNode = audioEngine.inputNode;
    recognitionRequest.shouldReportPartialResults = YES;
    recognitionTask = [speechRecognizer recognitionTaskWithRequest:recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        BOOL isFinal = NO;
        if (result) {
            // Whatever you say in the microphone after pressing the button should be being logged
            // in the console.
            //NSLog(@"RESULT:%@",result.bestTranscription.formattedString);
            NSString * resultStr = [[NSString alloc]initWithString:result.bestTranscription.formattedString];
            txtView.text = resultStr;
            //self.MessageCount++;
            //Message * newMessage = [Message messageWithString:resultStr];
            [self.MessageArray addObject:resultStr];
            isFinal = !result.isFinal;
        }
        if (error) {
            [audioEngine stop];
            [inputNode removeTapOnBus:0];
            recognitionRequest = nil;
            recognitionTask = nil;
        }
    }];
    
    // Sets the recording format
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    
    // Starts the audio engine, i.e. it starts listening.
    [audioEngine prepare];
    [audioEngine startAndReturnError:&error];
    NSLog(@"Say Something, I'm listening");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.MessageArray.count;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    STBubbleTableViewCell *cell = (STBubbleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    return nil;
}
 */

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//
//    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 415, 600)];
//    footerView.backgroundColor = UIColor.grayColor;
//   // [self CreateTextView];
//
//   // [footerView addSubview:txtView];
//    [footerView addSubview: self.recButton];
//    [footerView addSubview: self.txtView];
//    return footerView;
//}

-(void)SetTextView
{
    txtView = [[UITextView alloc]init];
    txtView.frame = CGRectMake(0, 400, 415, 200);
    [txtView setReturnKeyType:UIReturnKeyDone];
    [txtView setTag:5];
    [self.view addSubview:txtView];
}

-(void)SetButton
{
    recButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recButton.frame = CGRectMake(130,300, 100, 70);
    UIImage * buttonImage = [UIImage imageNamed:@"Record.png"];
    [recButton setImage:buttonImage forState:UIControlStateNormal];
    [recButton addTarget:self action:@selector(microPhoneTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recButton];
}

- (void)microPhoneTapped:(id)sender {
    [txtView resignFirstResponder];
    if (audioEngine.isRunning) {
        [audioEngine stop];
        [recognitionRequest endAudio];
        [self.recButton setImage:[UIImage imageNamed:@"Record.png"] forState:UIControlStateNormal];
    } else {
        [self startListening];
        
        [self.recButton setImage:[UIImage imageNamed:@"Stop.png"] forState:UIControlStateNormal];
    }
}

- (BOOL)textViewShouldReturn:(UITextView *)textView{
    [txtView resignFirstResponder];
    return YES;
}

- (void)addCharity:(UIButton*)sender
{
    NSLog(@"add to charity");
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 300.0;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    
}




@end
