//
//  CJScanViewController.h
//  CJKit
//
//  Created by vvipchen on 2020/4/9.
//  Copyright © 2020 Average-Chen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CJScanViewController : UIViewController
- (void)handleScanResult:(NSString *)result ;
@property (nonatomic, copy) void(^scanResult)(id result,NSError *error);
@end

