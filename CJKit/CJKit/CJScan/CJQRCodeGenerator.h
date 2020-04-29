//
//  CJQRCodeGenerator.h
//  CJKit
//  二维码生成器
//  Created by vvipchen on 2020/4/10.
//  Copyright © 2020 Average-Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^errorHandle)(NSError *error);
@interface CJQRCodeGenerator : NSObject
//
+(UIImage *)qrCodeWithInfo:(NSString *)info size:(CGSize)size;

+(UIImage *)qrCodeWithInfo:(NSString *)info logo:(UIImage *)logo size:(CGSize)siz;
+(CJQRCodeGenerator *)instance;
//设置QR内容
- (CJQRCodeGenerator *(^)(NSString *content))qrContent;
//设置QRLogo
- (CJQRCodeGenerator *(^)(UIImage *logo))qrLogo;
//二维码大小。默认200*200
- (CJQRCodeGenerator *(^)(CGSize size))qrSize;

//设置错误回调，如果要监测错误需要设置
- (CJQRCodeGenerator *(^)(errorHandle ecb))errorHandle;
//生成二维码
- (UIImage *(^)(void))make;


@end

NS_ASSUME_NONNULL_END
