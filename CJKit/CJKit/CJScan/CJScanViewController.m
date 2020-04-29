//
//  CJScanViewController.m
//  CJKit
//
//  Created by vvipchen on 2020/4/9.
//  Copyright © 2020 Average-Chen. All rights reserved.
//

#import "CJScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CJScanViewController+PhotoAlbum.h"
typedef enum : NSUInteger {
    Default = 0,
    AutoOn,
    AutoOff,
    ForceOn,
    ForceOff
} LightType;

#define kScanContentRect     (CGRectMake([UIScreen mainScreen].bounds.size.width *0.15, ([UIScreen mainScreen].bounds.size.height * 0.24 ), [UIScreen mainScreen].bounds.size.width * 0.7, [UIScreen mainScreen].bounds.size.width * 0.7))
@protocol CJScanContentUIViewDelegate<NSObject>
@optional
- (void)backAction;
- (void)turnLightOn:(BOOL)lightOn;
- (void)photoAblum;
@end;

@interface CJScanNaviView : UIView
@property (nonatomic ,strong) UIButton *backBtn;//返回按钮
@property (nonatomic ,strong) UIButton *photoAlbumBtn;//相册按钮
@property (nonatomic ,weak) id<CJScanContentUIViewDelegate> delegate;
@end

@interface CJScanContentUIView : UIView
@property (nonatomic ,strong) CJScanNaviView *navi;
@property (nonatomic ,assign,readonly)CGRect scanContentRect;
@property (nonatomic ,strong)UIImageView *scanline;//扫描线
@property (nonatomic ,strong)UIButton *lightBtn;//灯光
@property (nonatomic ,weak) id<CJScanContentUIViewDelegate> delegate;
- (void)startScanAnimation;//开始扫描动画
- (void)endScanAnimation;//停止扫描动画
@end
@interface CJScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,CJScanContentUIViewDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic,strong) AVCaptureSession * session;
@property (nonatomic,strong) AVCaptureDevice *device;//摄像头设备
@property (nonatomic,strong) AVCaptureVideoPreviewLayer * preview;
@property (nonatomic,strong) CJScanContentUIView *scanContentView;
@property (nonatomic ,assign) BOOL needShowLightSwitch;
@property (nonatomic ,assign) BOOL forceOffLight;//强制关灯光
@property (nonatomic ,assign) LightType lightType;
@end

@implementation CJScanNaviView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBtns];
    }
    return self;
}
- (void)setupBtns{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, self.frame.size.height/2 - 15, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"CJScan.bundle/qrcode_scan_btn_myqrcode_nor"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    UIButton *photoAlbumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoAlbumBtn.frame = CGRectMake(self.frame.size.width - 50,self.frame.size.height/2 - 43.5/2 , 32.5, 43.5);
    [photoAlbumBtn setImage:[UIImage imageNamed:@"CJScan.bundle/qrcode_scan_btn_photo_nor"] forState:UIControlStateNormal];
    [photoAlbumBtn addTarget:self action:@selector(photoAblumClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:photoAlbumBtn];
}

- (void)backClicked:(UIButton*)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backAction)]) {
        [self.delegate backAction];
    }
}
- (void)photoAblumClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoAblum)]) {
        [self.delegate photoAblum];
    }
}



@end

@implementation CJScanContentUIView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        _scanContentRect = kScanContentRect;
        [self setupNavi];
        [self setupScancontent];
        [self setupBorder];
        [self setupScanline];
        [self setupViews];
    }
    return self;
}
//
- (void)setupNavi{
    CJScanNaviView *navi = [[CJScanNaviView alloc] initWithFrame:CGRectMake(0, 20,[UIScreen mainScreen].bounds.size.width , 44)];
    navi.delegate = self.delegate;
    [self addSubview:navi];
    self.navi = navi;
}

- (void)setDelegate:(id<CJScanContentUIViewDelegate>)delegate{
    _delegate = delegate;
    _navi.delegate = delegate;
}
//绘制扫描镂空层
- (void)setupScancontent{
    //中间镂空的矩形框
    CGRect myRect = kScanContentRect;
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:0];
    //镂空
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:myRect];
    [path appendPath:rectPath];
    [path setUsesEvenOddFillRule:YES];
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor;
    [self.layer addSublayer:fillLayer];
}

//原点逆时针开始布局四个角图标

- (void)setupBorder{
    NSArray *icons = @[@"CJScan.bundle/QRCodeLeftTop",@"CJScan.bundle/QRCodeLeftBottom",@"CJScan.bundle/QRCodeRightTop",@"CJScan.bundle/QRCodeRightBottom"];
    for (int i = 0;i<=icons.count -1;i++) {
        UIImage *iconImage = [UIImage imageNamed:icons[i]];
        UIImageView *iconImageView = [[UIImageView alloc] init];
        CGFloat x =  (i<=1) ? (CGRectGetMinX(_scanContentRect)) : (CGRectGetMaxX(_scanContentRect) - 10);
        CGFloat y = ((i%2) == 0) ? CGRectGetMinY(_scanContentRect) :(CGRectGetMaxY(_scanContentRect) - 10);
        CGFloat w = 10;
        CGFloat h = 10;
        iconImageView.frame = CGRectMake(x, y, w, h);
        iconImageView.image = iconImage;
        [self addSubview:iconImageView];
    }
}
///设置扫描线
- (void)setupScanline{
    UIImageView *scanline = [[UIImageView alloc] initWithFrame:CGRectMake(_scanContentRect.origin.x, _scanContentRect.origin.y + _scanContentRect.size.height/2.0 - 5, _scanContentRect.size.width, 10)];
    scanline.image = [UIImage imageNamed:@"CJScan.bundle/QRCodeScanningLine"];
    [self addSubview:scanline];
    self.scanline = scanline;
}
///绘制相关功能按钮
- (void)setupViews{
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.backgroundColor = [UIColor clearColor];
    promptLabel.frame = CGRectMake(0, CGRectGetMaxY(_scanContentRect)+30, [UIScreen mainScreen].bounds.size.width, 25);
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
    promptLabel.textColor = [UIColor whiteColor];
    promptLabel.text = @"将二维码/条码放入框内,以便扫描";
    [self addSubview:promptLabel];
    
    //灯光按钮
    UIButton *lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lightBtn.frame = CGRectMake(self.frame.size.width/2 - 32.5,CGRectGetMaxY(promptLabel.frame)+20, 65, 87);
    [lightBtn setImage:[UIImage imageNamed:@"CJScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [lightBtn setImage:[UIImage imageNamed:@"CJScan.bundle/qrcode_scan_btn_scan_off"] forState:UIControlStateSelected];
    [lightBtn addTarget:self action:@selector(lightSwith:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lightBtn];
    self.lightBtn = lightBtn;
}
- (void)lightSwith:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(turnLightOn:)]) {
        [self.delegate turnLightOn:sender.isSelected];
    }
}


- (void)startScanAnimation{
      CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];///.y的话就向下移动。
      animation.toValue = @(_scanContentRect.size.height/2.0);
      animation.duration = 0.8;
      animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
      animation.repeatCount = 1;
      animation.fillMode = kCAFillModeForwards;
      animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
      animation.beginTime = 0;
      //[self.scanline.layer addAnimation:animation forKey:@"scanLineViewAnimation"];
    
      CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
      animation1.toValue = @(0-_scanContentRect.size.height/2.0);
      animation1.duration = 1.4;
      animation1.removedOnCompletion = NO;//yes的话，又返回原位置了。
      animation1.repeatCount = 1;
      animation1.fillMode = kCAFillModeForwards;
      animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
      animation1.beginTime = 0.8;
    
      CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
      animation2.toValue = @(0);
      animation2.duration = 0.8;
      animation2.removedOnCompletion = NO;//yes的话，又返回原位置了。
      animation2.repeatCount = 1;
      animation2.fillMode = kCAFillModeForwards;
      animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
      animation2.beginTime = 2.2;
      
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    [animationGroup setAnimations:@[animation,animation1,animation2]];
    animationGroup.repeatCount = MAXFLOAT;
    animationGroup.duration = 3;
    animationGroup.removedOnCompletion = NO;//yes的话，又返回原位置了。

    [self.scanline.layer addAnimation:animationGroup forKey:@"scanLineViewAnimation"];
    
}
- (void)endScanAnimation{
    [self.scanline.layer removeAnimationForKey:@"scanLineViewAnimation"];
}

@end
@implementation CJScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.title = @"扫一扫";
    [self setupUI];
    [self setupSession];
}


//设置session

- (void)setupSession{

    //初始化摄像头
      NSError *error = nil;
    //1.获取摄像设备
      AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
      //2.创建输入流
      AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
      //3.创建输出流
      AVCaptureMetadataOutput *metdataOutput = [[AVCaptureMetadataOutput alloc] init];
      //设置代理 在主线程刷新
      [metdataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
     //
      AVCaptureVideoDataOutput *lightOut = [[AVCaptureVideoDataOutput alloc] init];
      [lightOut setSampleBufferDelegate:self queue:dispatch_get_main_queue()];

     //设置扫描作用范围(由于扫码时系统默认横屏关系, 导致作用框原点变为我们绘制的框的右上角,而不是左上角) 且参数为比率不是像素点

     self.device = device;

    CGRect scanContentRect = kScanContentRect;
    metdataOutput.rectOfInterest = CGRectMake(CGRectGetMinY(scanContentRect)/CGRectGetMaxY([UIScreen mainScreen].bounds),CGRectGetMinX(scanContentRect)/CGRectGetMaxX([UIScreen mainScreen].bounds),CGRectGetHeight(scanContentRect)/CGRectGetHeight([UIScreen mainScreen].bounds),CGRectGetWidth(scanContentRect)/CGRectGetWidth([UIScreen mainScreen].bounds));


    //
    //4.初始化连接对象
     self.session = [[AVCaptureSession alloc] init];
     //设置高质量采集率
     [self.session  setSessionPreset:AVCaptureSessionPresetHigh];
     //组合
     [self.session addInput:input];
     [self.session addOutput:metdataOutput];
     [self.session addOutput:lightOut];
     //设置扫码格式支持的码(一定要在 session 添加 addOutput之后再设置 否则会爆)
     metdataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
     //展示layer
     AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session ];
     layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
     layer.frame = self.view.layer.bounds;
     layer.backgroundColor = [UIColor blueColor].CGColor;
     [self.view.layer insertSublayer:layer atIndex:0];
    [self startScan];

}



- (void)setupUI{
    //扫码框
    CJScanContentUIView *scanContentView = [[CJScanContentUIView alloc] initWithFrame:self.view.bounds];
    scanContentView.delegate = self;
    [self.view addSubview:scanContentView];
    self.scanContentView = scanContentView;
}
//开始扫描
- (void)startScan{
    [self.session startRunning];
    [self.scanContentView startScanAnimation];
}

#pragma mark -CJScanContentUIViewDelegate

- (void)turnLightOn:(BOOL)lightOn{
    //1.是否存在手电功能
       if ([_device hasTorch]) {
           //2.锁定当前设备为使用者
           [_device lockForConfiguration:nil];
           //3.开关手电筒
           if (lightOn) {
               [_device setTorchMode:AVCaptureTorchModeOn];
               self.scanContentView.lightBtn.selected = YES;
               self.lightType = ForceOn;

           } else {
               [_device setTorchMode: AVCaptureTorchModeOff];
               self.scanContentView.lightBtn.selected = NO;
               self.lightType = ForceOff;
           }
           //4.使用完成后解锁
           [_device unlockForConfiguration];
       }
}

- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoAblum{
    [self oepnPhotoLib];
}


- (void)autoLight:(BOOL)lightOn{
    
    //1.是否存在手电功能
       if ([_device hasTorch]) {
           //2.锁定当前设备为使用者
           [_device lockForConfiguration:nil];
           //3.开关手电筒
           if (lightOn) {
               [_device setTorchMode:AVCaptureTorchModeOn];
               self.scanContentView.lightBtn.selected = YES;
               self.lightType = AutoOn;
           } else {
               [_device setTorchMode: AVCaptureTorchModeOff];
               self.scanContentView.lightBtn.selected = NO;
               self.lightType = AutoOff;
           }
           //4.使用完成后解锁
           [_device unlockForConfiguration];
       }
    
}

//停止扫描
- (void)stopScan{
    [self.session stopRunning];
    [self.scanContentView endScanAnimation];
}

#pragma mark -- AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
     [self stopScan];//停止会话
     [self.preview removeFromSuperlayer];//移除取景器
     if (metadataObjects.count > 0) {
         AVMetadataMachineReadableCodeObject * obj = metadataObjects[0];
         NSString * result = obj.stringValue;//这就是扫描的结果
         [self handleScanResult:result error:nil];
     }else{
         [self handleScanResult:nil error:[NSError errorWithDomain:@"扫描失败" code:11001 userInfo:nil]];
         
     }
 }

#pragma mark -- AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    BOOL hidenLightOn = (brightnessValue>0.3) ? YES:NO;
    
    if(hidenLightOn == NO && _device.torchMode == AVCaptureFlashModeOff){
        //自动开灯
        if (self.lightType != ForceOff) {
            [self autoLight:YES];
        }
    }
    
    //如果当前电筒打开,则电筒开关永久显示
    if (self.scanContentView.lightBtn.isSelected == YES) {
        self.scanContentView.lightBtn.hidden = NO;
    }else{
        self.scanContentView.lightBtn.hidden = hidenLightOn;
    }
    
}


- (void)handleScanResult:(NSString *)result error:(NSError *)error{
    if (self.scanResult) {
        self.scanResult(result, error);
    }
    

}


@end
