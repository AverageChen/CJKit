//
//  NotificationService.m
//  CJKitNotification
//
//  Created by vvipchen on 2020/4/22.
//  Copyright © 2020 Average-Chen. All rights reserved.
//

#import "NotificationService.h"
//#import "AVSpeakingService.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;
@property (nonatomic ,strong) AVSpeechSynthesizer *synthesizer;
@end

@implementation NotificationService
void AudioServicesPlaySystemSoundWithVibration(int, id, NSDictionary *);

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
     
     self.bestAttemptContent = [request.content mutableCopy];

     // Modify the notification content here...
     
     self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];

     NSString *content = request.content.userInfo[@"aps"][@"alert"][@"body"];

     AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:content];

     AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];

     [synth speakUtterance:utterance];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    // 可以自己设定震动间隔与时常（毫秒）
    // 是否生效, 时长, 是否生效, 时长……
    NSArray *pattern = @[@YES, @30, @NO, @1];

    dictionary[@"VibePattern"] = pattern; // 模式
    dictionary[@"Intensity"] = @.9; // 强度（测试范围是0.3～1.0）

     self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
    [self syntheticVoice:@"12323"];

}
- (void)syntheticVoice:(NSString*)string {

    //  语音合成

    self.synthesizer = [[AVSpeechSynthesizer alloc] init];

    AVSpeechUtterance*speechUtterance = [AVSpeechUtterance speechUtteranceWithString:string];

    //设置语言类别（不能被识别，返回值为nil）

    speechUtterance.voice= [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];

    //设置语速快慢

    speechUtterance.rate=0.5;//0.5是一个

    //语音合成器会生成音频

    [self.synthesizer speakUtterance:speechUtterance];

}
@end
