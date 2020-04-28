//
//  CJDispatcher.m
//  CJKit
//
//  Created by vvipchen on 2020/4/8.
//  Copyright © 2020 Average-Chen. All rights reserved.
//

#import "CJDispatcher.h"

@implementation CJDispatcher
+ (instancetype)sharedInstance
{
    static CJDispatcher *dispatcher;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatcher = [[CJDispatcher alloc] init];
    });
    return dispatcher;
}

///组件名
- (CJDispatcher *(^)(NSString *moduleName))module{
    return ^(NSString *moduleName){
        return self;
    };
}
///参数
- (CJDispatcher *(^)(id param))param{
    return ^(id param){
        return self;
    };
}
///方法
- (CJDispatcher *(^)(void))action{
    return ^(void){
        return self;
    };
}
- (CJDispatcher *(^)(NSString *action ,NSDictionary *param,callback cb))dispatch{
    return ^(NSString *action ,NSDictionary *param,callback cb){
        return self;
    };
}





@end
