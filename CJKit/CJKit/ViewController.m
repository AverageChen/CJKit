//
//  ViewController.m
//  CJKit
//
//  Created by vvipchen on 2020/4/8.
//  Copyright © 2020 Average-Chen. All rights reserved.
//

#import "ViewController.h"
#import "CJDispatherProtocol.h"
#import "CJDispatcher.h"
#import "CJScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CJQRCodeGenerator.h"
#import "AVSpeakingService.h"
#import "JPUSHService.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CJDispatcher sharedInstance].dispatch(@"ShareActio1n",@"share1",@{@"1":@"2"},^(id result,NSError *error){
        NSLog(@"%@",error.domain.description);
    });
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    
    Class share = NSClassFromString(@"SDKDemo");

    
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 200, 200)];
//    imageV.image = image;
//    [self.view addSubview:imageV];
    UIImage *logo  = [UIImage imageNamed:@"58*58"];
    UIImage *image111 = CJQRCodeGenerator.instance.qrContent(@"武汉加油，中国加油").qrSize(CGSizeMake(400, 400)).qrLogo(logo).errorHandle(^(NSError *error){
        NSLog(@"rrrrr");
    }).make();
    
    self.imageView.image = image111;
    
    [JPUSHService setAlias:@"vip" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (iResCode == 0) {
            NSLog(@"成功");
        }
    } seq:0];
    
    
}
- (IBAction)scan:(id)sender {
    
    
    
//    AVSpeakingService.create().content(@"话说天下大势，分久必合，合久必分。周末七国分争，并入于秦。及秦灭之后，楚、汉分争，又并入于汉。汉朝自高祖斩白蛇而起义，一统天下，后来光武中兴，传至献帝，遂分为三国。").speaking();

//    CJScanViewController *scanVC = [CJScanViewController new];
//    scanVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:scanVC animated:YES completion:nil];
    
//    [self test];
    
}
- (void)test{
    
    // 创建合成语音的语言
    
    
    NSArray *lans = @[@"zh-CN",@"zh-HK",@"en-US",@"en-GB",@"ja-JP"];
    int x = arc4random() % lans.count;
    AVSpeechSynthesisVoice *voiceLanguage = [AVSpeechSynthesisVoice voiceWithLanguage:lans[x]];
    // 创建 AVSpeechSynthesizer
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:@"话说天下大势，分久必合，合久必分。周末七国分争，并入于秦。及秦灭之后，楚、汉分争，又并入于汉。汉朝自高祖斩白蛇而起义，一统天下，后来光武中兴，传至献帝，遂分为三国。"];
        // 设置合成语音的语言
        utterance.voice = voiceLanguage;
        // 语速 0.0f～1.0f
        utterance.rate = 0.5f;
        // 声音的音调 0.5f～2.0f
        utterance.pitchMultiplier = 0.8f;
        // 使播放下一句的时候有0.2秒的延迟
        utterance.postUtteranceDelay = 0.2f;
        
        [synthesizer speakUtterance:utterance];
    // 播放合成语音
//    [synthesizer speakUtterance:utterance];
    
}


- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //检测到摇动开始
    if (motion == UIEventSubtypeMotionShake)
    {
      // your code
      NSLog(@"检测到摇动开始");
    }
}

- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //摇动取消
    NSLog(@"摇动取消");
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //摇动结束
    if (event.subtype == UIEventSubtypeMotionShake)
    {
        // your code
        NSLog(@"摇动结束");
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//
        [self test];
    }
    
}



@end
