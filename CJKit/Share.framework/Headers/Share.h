//
//  Share.h
//  Share
//
//  Created by vvipchen on 2020/4/17.
//  Copyright © 2020 Average-Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareProtocol.h"
typedef void (^callBack)(id _Nullable result ,NSError * _Nullable error);
@interface Share:NSObject<ShareProtocol>

+ (Share *_Nonnull(^_Nonnull)(void))create;
//设置分享回调
- (Share *_Nonnull(^_Nonnull)(callBack _Nonnull cb))completion;

//设置分享服务
- (Share *_Nullable(^_Nullable)(NSString *_Nonnull))shareService;
//设置分享参数
- (Share *_Nonnull(^_Nonnull)(NSDictionary * _Nonnull param))shareParam;

//执行分享
- (void (^_Nonnull)(void))share;
//获取支持分享的平台
- (void (^_Nonnull)(void))supportPlat;





@end

