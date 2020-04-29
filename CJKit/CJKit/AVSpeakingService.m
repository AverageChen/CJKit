//
//  AVSpeakingService.m
//  yxBox
//
//  Created by vvipchen on 2020/4/15.
//  Copyright © 2020 Dana. All rights reserved.
//

#import "AVSpeakingService.h"

@interface AVSpeakingService()<AVSpeechSynthesizerDelegate>
@property (nonatomic,strong) AVSpeechSynthesizer *synthesizer;
@property (nonatomic,strong) NSString *voiceContent;
@property (nonatomic,strong) NSString *voiceLanguage;

@property (nonatomic ,copy) stateCallBack startcb;
@property (nonatomic ,copy) stateCallBack endcb;

@end
@implementation AVSpeakingService
- (AVSpeechSynthesizer *)synthesizer{
    if (!_synthesizer) {
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
        _synthesizer.delegate = self;
    }
    return _synthesizer;
}

+ (AVSpeakingService *)sharedInstance {
    static dispatch_once_t onceToken;
    __strong static id _speakingService = nil;
    dispatch_once(&onceToken, ^{
        _speakingService = [[AVSpeakingService alloc] init];
    });
    [_speakingService install];
    return _speakingService;
}
- (void)install{
    self.voiceContent = @"";
    self.voiceLanguage = @"zh-CN";
    self.startcb = nil;
    self.endcb = nil;
}
+ (AVSpeakingService *(^)(void))create{
    return ^(void){
        return [AVSpeakingService sharedInstance];
    };
}

- (AVSpeakingService *(^)(NSString *content))content{
    return ^(NSString *content){
        self.voiceContent = content;
        return self;
    };
}
- (AVSpeakingService *(^)(NSString *language))language{
    return ^(NSString *language){
        self.voiceLanguage = language;
        return self;
    };
}

- (AVSpeakingService *(^)(void))speaking{
    return ^(void){
        [self speakInfo:self->_voiceContent];
        return self;
    };
}
//播报开始
- (AVSpeakingService *(^)(stateCallBack cb))speakingStart{
    return ^(stateCallBack cb){
        self->_startcb = cb;
        return self;
    };
}



//播报结束
- (AVSpeakingService *(^)(stateCallBack cb))speakingEnd{
    return ^(stateCallBack cb){
        self->_endcb  = cb;
        return self;
    };
}


- (void)speakInfo:(NSString *)content{
    // 创建合成语音的语言
    NSArray *languages = [AVSpeechSynthesisVoice speechVoices];//可获取所有支持的语言
    NSLog(@"语言列表:%@",languages);
    AVSpeechSynthesisVoice *voiceLanguage = [AVSpeechSynthesisVoice voiceWithLanguage:self.voiceLanguage];
    NSString *speechStrings = content;
    // 创建 AVSpeechSynthesizer
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:speechStrings];
        // 设置合成语音的语言
    utterance.voice = voiceLanguage;
        // 语速 0.0f～1.0f
    utterance.rate = 0.4f;
        // 声音的音调 0.5f～2.0f
    utterance.pitchMultiplier = 0.8f;
        // 使播放下一句的时候有0.1秒的延迟
    utterance.postUtteranceDelay = 0.1f;
    [self.synthesizer speakUtterance:utterance];
    // 播放合成语音
}

// 播放开始状态
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    if (self.startcb) {
        self.startcb(synthesizer, utterance);
    }
}
// 播放结束状态
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    if (self.endcb) {
        self.endcb(synthesizer, utterance);
    }
}
// 播放暂停状态
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{}
// 跳出播放状态
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance{}
// 退出播放状态
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance{}
// 播放状态时，当前所播放的字符串范围，及AVSpeechUtterance实例（可通过此方法监听当前播放的字或者词）
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance{}



@end
