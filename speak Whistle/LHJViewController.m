//
//  LHJViewController.m
//  speak Whistle -2
//
//  Created by Hanbat19 on 13. 7. 17..
//  Copyright (c) 2013년 Hanbat19. All rights reserved.
//

#import "LHJViewController.h"
#import <AVFoundation/AVFoundation.h> 
 
@interface LHJViewController ()
{
int blowState;
    
NSURL *soundURL;
    
NSArray *imgArray;

    UIImage *image1;
    UIImage *image2;
 
    int i;
   
}
@end

@implementation LHJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    image1 = [UIImage imageNamed:@"whistle.png"];
    image2 = [UIImage imageNamed:@"melodyandharmony.png"];
    
    imgArray = @[image1,image2];
    
    [self.segment setExclusiveTouch:YES];
    
    UISwipeGestureRecognizer *horizontal =
    [[UISwipeGestureRecognizer alloc]
     initWithTarget:self action:@selector(reportHorizontalSwipe:)];
    horizontal.direction = UISwipeGestureRecognizerDirectionLeft|
    UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:horizontal];

    NSURL *url =[NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                              [NSNumber numberWithInt:kAudioFormatAppleLossless], AVFormatIDKey, [NSNumber numberWithInt:1],
                              AVNumberOfChannelsKey, [NSNumber numberWithInt:AVAudioQualityMax], AVEncoderAudioQualityKey,  nil];
    NSError *error;
    
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
   NSString *message = [[NSString alloc] initWithFormat:@"App의 원활한 작동을 위해 매너모드를   해제해주시길 바랍니다."];
    NSString *message2 = [[NSString alloc] initWithFormat:@"소리를 극대화 하기 위해서 설정 > 사운드 > 벨소리 및 알림 음량을 크게 해주세요."];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"" message:message
                          delegate:self cancelButtonTitle:@"승인" otherButtonTitles:nil];
    UIAlertView *alert2 = [[UIAlertView alloc]
                          initWithTitle:@"" message:message2
                          delegate:self cancelButtonTitle:@"승인" otherButtonTitles:nil];
    
    [alert2 show];
    
     [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)reportHorizontalSwipe:(UIGestureRecognizer *)recognizer
{
    
    self.instruments.image = [imgArray objectAtIndex:i++%2];
    AudioServicesDisposeSystemSoundID(WhistleSoundID);
    
}


- (IBAction)valueChange:(id)sender {
   
    NSError *error;
    UISegmentedControl *seg = (UISegmentedControl*) sender;
    
    int segIndex;
    segIndex = seg.selectedSegmentIndex;
    
    
    switch (segIndex)
    {
        case 0:
            AudioServicesDisposeSystemSoundID(WhistleSoundID);
            NSLog(@"Touch Mode");
            [recorder stop];
            [levelTimer invalidate];
            self.buttonOutlet.hidden = NO;
            [self.buttonOutlet setExclusiveTouch:YES];
            self.inforImage.hidden = YES;
            self.inforLabel.hidden = YES;
            self.inforLabel2.hidden = YES;
            self.shakeImage.hidden = YES;
            self.stopbuttonOutlet.hidden = YES;
            self.stopButtonOutlet2.hidden = YES;
            break;
    
        case 1:
            AudioServicesDisposeSystemSoundID(WhistleSoundID);
            NSLog(@"Shake Mode");
            [levelTimer invalidate];
            [recorder stop];
            self.inforImage.hidden = YES;
            self.inforLabel.hidden = YES;
            self.inforLabel2.hidden = YES;
            self.buttonOutlet.hidden = YES;
            self.shakeImage.hidden = NO;
            self.stopbuttonOutlet.hidden = NO;
            self.stopButtonOutlet2.hidden = YES;
            break;
            
        case 2:
            AudioServicesDisposeSystemSoundID(WhistleSoundID);
            NSLog(@"Blow Mode");
            self.inforImage.hidden = YES;
            self.inforLabel.hidden = NO;
            self.inforLabel2.hidden = NO;
            self.buttonOutlet.hidden = YES;
            self.shakeImage.hidden = YES;
            self.stopbuttonOutlet.hidden = YES;
            self.stopButtonOutlet2.hidden = NO;
            if(recorder)
            {
                [recorder prepareToRecord];
                recorder.meteringEnabled = YES;
                [recorder record];
                self.inforImage.hidden = NO;
                levelTimer =  [NSTimer scheduledTimerWithTimeInterval:0.142 target:self selector:@selector(levelTimerCallback:) userInfo:nil repeats:YES];
            }
            else
                NSLog(@"%@",[error description]);
            break;
            
        default:
            break;
    }

    
    
}

- (IBAction)thatButton:(id)sender {
    
    if(self.segment.selectedSegmentIndex == 0)
    {
     if([self.instruments.image isEqual:image1])
        soundURL = [[NSBundle mainBundle] URLForResource:@"Whistle" withExtension:@"wav"];
        else
       soundURL = [[NSBundle mainBundle] URLForResource:@"휘파람" withExtension:@"wav"];
    
   
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundURL,
                                      &WhistleSoundID);
   
  AudioServicesPlaySystemSound(WhistleSoundID);
    }
}

- (IBAction)itButton:(id)sender {
    if(self.segment.selectedSegmentIndex ==0)
        AudioServicesDisposeSystemSoundID(WhistleSoundID);
}

- (IBAction)stop2:(id)sender {
    
    if(self.segment.selectedSegmentIndex == 2)
    {
        AudioServicesDisposeSystemSoundID(WhistleSoundID);
        [self recorderStart];
    }

}

- (IBAction)stopButton:(id)sender {
  if(self.segment.selectedSegmentIndex==1)
      AudioServicesDisposeSystemSoundID(WhistleSoundID);
        }

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if(self.segment.selectedSegmentIndex == 1)
    {
        if([self.instruments.image isEqual:image1])
            soundURL = [[NSBundle mainBundle] URLForResource:@"Whistle" withExtension:@"wav"];
        else
            soundURL = [[NSBundle mainBundle] URLForResource:@"휘파람" withExtension:@"wav"];
        
        AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundURL,
                                          &WhistleSoundID);
    
    
        AudioServicesPlaySystemSound(WhistleSoundID);
    }
}


-(void)levelTimerCallback:(NSTimer *)timer
{
   if(self.segment.selectedSegmentIndex  == 2)
    
   { [recorder updateMeters];
    
        if([self.instruments.image isEqual:image1])
            soundURL = [[NSBundle mainBundle] URLForResource:@"Whistle" withExtension:@"wav"];
        else
            soundURL = [[NSBundle mainBundle] URLForResource:@"휘파람" withExtension:@"wav"];
        
        AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundURL,
                                          &WhistleSoundID);
        
        AudioServicesPlaySystemSound(WhistleSoundID);
    
    const double ALPHA = 0.05;
    
    double peakPowerForChannel = pow(10,(0.05*[recorder peakPowerForChannel:0]));
    
    lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
    
    NSLog(@"Average input:%f Peak input:%f Low pass results:%f",[recorder averagePowerForChannel:0],[recorder peakPowerForChannel:0],lowPassResults);
    
    if(lowPassResults > 0.21821)
    {
        NSLog(@"blow detected ");
        [recorder stop];
      
        [levelTimer invalidate];
        
        self.inforImage.hidden = YES;
        
        AudioServicesPlaySystemSound(WhistleSoundID);
        
        lowPassResults = 0.0;
        
        [self performSelector:@selector(recorderStart) withObject:nil afterDelay:3.442];
    }
   }
           else
           AudioServicesDisposeSystemSoundID(WhistleSoundID);
  
}


-(void) recorderStart
{
    if(self.segment.selectedSegmentIndex == 2)
    {
        NSLog(@"after delay");
    if(levelTimer.isValid == NO)
  
    {
    self.inforImage.hidden = NO;
        
    [recorder prepareToRecord];
        
    recorder.meteringEnabled = YES;
        
    [recorder record];
    
    levelTimer =  [NSTimer scheduledTimerWithTimeInterval:0.142 target:self selector:@selector(levelTimerCallback:) userInfo:nil repeats:YES];
    }
    }
    else
        AudioServicesDisposeSystemSoundID(WhistleSoundID);
    
}

@end
