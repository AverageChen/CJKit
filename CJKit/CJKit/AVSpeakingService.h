//
//  AVSpeakingService.h
//  yxBox
//
//  Created by vvipchen on 2020/4/15.
//  Copyright © 2020 Dana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN



typedef void(^stateCallBack)(AVSpeechSynthesizer * speechSynthesizer,AVSpeechUtterance *speechUtterance );


@interface AVSpeakingService : NSObject
+ (AVSpeakingService*)sharedInstance;
//创建
+ (AVSpeakingService *(^)(void))create;
//播报内容
- (AVSpeakingService *(^)(NSString *content))content;
//播报语言
- (AVSpeakingService *(^)(NSString *language))language;

//启动播报
- (AVSpeakingService *(^)(void))speaking;
//播报开始
- (AVSpeakingService *(^)(stateCallBack cb))speakingStart;
//播报结束
- (AVSpeakingService *(^)(stateCallBack cb))speakingEnd;

@end

NS_ASSUME_NONNULL_END
