//
//  LHJViewController.h
//  speak Whistle -2
//
//  Created by Hanbat19 on 13. 7. 17..
//  Copyright (c) 2013년 Hanbat19. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface LHJViewController : UIViewController <UIGestureRecognizerDelegate , UIApplicationDelegate>
{
   SystemSoundID WhistleSoundID;
   AVAudioRecorder *recorder;
   NSTimer *levelTimer;
   double lowPassResults;
   
    
    
}
- (IBAction)valueChange:(id)sender;
- (IBAction)thatButton:(id)sender;
- (IBAction)itButton:(id)sender;
- (IBAction)stop2:(id)sender;
- (IBAction)stopButton:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UIButton *buttonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *stopbuttonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *stopButtonOutlet2;
@property (weak, nonatomic) IBOutlet UILabel *inforLabel;
@property (weak, nonatomic) IBOutlet UILabel *inforLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *inforImage;
@property (weak, nonatomic) IBOutlet UIImageView *instruments;
@property (weak, nonatomic) IBOutlet UIImageView *shakeImage;
-(void)levelTimerCallback:(NSTimer *)timer;
@end
