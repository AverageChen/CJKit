//
//  CJScanViewController+PhotoAlbum.h
//  CJKit
//
//  Created by vvipchen on 2020/4/9.
//  Copyright © 2020 Average-Chen. All rights reserved.
//


#import "CJScanViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJScanViewController (PhotoAlbum)<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
-(void)oepnPhotoLib;
@end

NS_ASSUME_NONNULL_END
