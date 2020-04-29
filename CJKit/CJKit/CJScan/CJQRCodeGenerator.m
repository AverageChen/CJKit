//
//  CJQRCodeGenerator.m
//  CJKit
//
//  Created by vvipchen on 2020/4/10.
//  Copyright © 2020 Average-Chen. All rights reserved.
//

#import "CJQRCodeGenerator.h"
@interface CJQRCodeGenerator()
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) UIImage *logo;
@property (nonatomic,assign) CGSize size;

@property (nonatomic,copy) errorHandle ecb;
@end
@implementation CJQRCodeGenerator
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.size  = CGSizeMake(200, 200);
    }
    return self;
}
+ (UIImage *)qrCodeWithInfo:(NSString *)info size:(CGSize)size{
    if (info.length == 0) {
        return nil;
    }
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSString *string = info;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    // 转成高清格式
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:image withSize:MAX(size.width, size.height)];
    // 添加logo
    return qrcode;
}


+ (UIImage *)qrCodeWithInfo:(NSString *)info logo:(UIImage *)logo size:(CGSize)size{
    UIImage *qrcode = [self qrCodeWithInfo:info size:size];
    return [self drawImage:logo inImage:qrcode];
}



// 将二维码转成高清的格式
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (UIImage *)drawImage:(UIImage *)newImage inImage:(UIImage *)sourceImage {
    if (newImage == nil) {
        return sourceImage;
    }
    CGSize imageSize; //画的背景 大小
    imageSize = [sourceImage size];
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [sourceImage drawAtPoint:CGPointMake(0, 0)];
    //获得 图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    //画 自己想要画的内容(添加的图片)
    CGContextDrawPath(context, kCGPathStroke);
    // 注意logo的尺寸不要太大,否则可能无法识别
    CGRect rect = CGRectMake(imageSize.width / 2 - 25, imageSize.height / 2 - 25, 50, 50);
//    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [newImage drawInRect:rect];
    
    //返回绘制的新图形
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+(CJQRCodeGenerator *)instance{
    return [[CJQRCodeGenerator alloc] init];
}
- (CJQRCodeGenerator * _Nonnull (^)(NSString * _Nonnull))qrContent{
    return ^(NSString * _Nonnull content) {
        self.content = content;
        return self;
    };
}

- (CJQRCodeGenerator * _Nonnull (^)(UIImage * _Nonnull))qrLogo{
    return ^(UIImage * _Nonnull logo) {
        self.logo = logo;
        return self;
    };
}
- (CJQRCodeGenerator *(^)(CGSize size))qrSize{
    return ^(CGSize size){
        self.size = size;
        return self;
    };
}
- (CJQRCodeGenerator * _Nonnull (^)(errorHandle _Nonnull))errorHandle{
    return ^(errorHandle _Nonnull ecb){
        self.ecb = ecb;
        return self;
    };
}


- (UIImage * _Nonnull (^)(void))make{
    return ^(void){
        if (self.ecb && (self.content.length == 0)) {
            self.ecb([NSError errorWithDomain:@"未设置二维码内容" code:10001 userInfo:nil]);
        }
       return [CJQRCodeGenerator qrCodeWithInfo:self.content logo:self.logo size:self.size ];
    };
}
- (void)dealloc{
    NSLog(@"CJQRCodeGenerator is Safe");
}
@end
