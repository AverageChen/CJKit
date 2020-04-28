//
//  CJDispatcher.h
//  CJKit
//
//  Created by vvipchen on 2020/4/8.
//  Copyright © 2020 Average-Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^callback)(id _Nullable result ,NSError *error);
NS_ASSUME_NONNULL_BEGIN

@interface CJDispatcher : NSObject
+ (instancetype _Nonnull)sharedInstance;
///组件名
- (CJDispatcher *(^)(NSString *moduleName))module;
///参数
- (CJDispatcher *(^)(id param))param;
///方法
- (CJDispatcher *(^)(void))action;
///
- (CJDispatcher *(^)(NSString *action ,NSDictionary *param,callback cb))dispatch;

@end

NS_ASSUME_NONNULL_END
