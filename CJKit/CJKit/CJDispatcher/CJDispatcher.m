//
//  CJDispatcher.m
//  CJKit
//
//  Created by vvipchen on 2020/4/8.
//  Copyright © 2020 Average-Chen. All rights reserved.
//

#import "CJDispatcher.h"
#import "CJDispatherProtocol.h"
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
- (CJDispatcher *(^)(NSString *modular ,NSString *sel, NSDictionary *param,callback cb))dispatch{
    return ^(NSString *modular ,NSString *sel, NSDictionary *param,callback cb){
        id<CJDispatherProtocol> dipatcher = [NSClassFromString(modular) new];
        if (dipatcher && [dipatcher respondsToSelector:@selector(sel:param:cb:)]) {
            [dipatcher sel:sel param:param cb:cb];
        }else{
            if (cb) {
                cb(nil,[NSError errorWithDomain:@"未找到对应模块" code:-1001 userInfo:nil]);
            }
        }
        return self;
    };
}

- (CJDispatcher *(^)(void))openUrl:(NSURL *)url param:(NSDictionary*)parma{
    return ^(void){
        return self;
    };
}




@end
