//
//  CJScanViewController+PhotoAlbum.m
//  CJKit
//
//  Created by vvipchen on 2020/4/9.
//  Copyright © 2020 Average-Chen. All rights reserved.
//

#import "CJScanViewController+PhotoAlbum.h"

@implementation CJScanViewController (PhotoAlbum)
/**
 *  选择相片
 *
 */
-(void)oepnPhotoLib{
    
    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];

    // 3. 设置打开照片相册类型(显示所有相簿)
    //ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    ipc.allowsEditing = YES;//启动编辑功能
    // 4.设置代理
    ipc.delegate = self;
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
    
}

// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *scannedResult;
    // 设置图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if(image){
        //1. 初始化扫描仪，设置设别类型和识别质量
        CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
        //2. 扫描获取的特征组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if([features count] > 0){
            //3. 获取扫描结果
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            scannedResult = feature.messageString;
        }
    }
    [self handleScanResult:scannedResult];
}
@end
