//
//  ShareAction.m
//  CJKit
//
//  Created by vvipchen on 2020/4/8.
//  Copyright © 2020 Average-Chen. All rights reserved.
//

#import "ShareAction.h"
#import "CJDispatcher.h"
@implementation ShareAction
- (void)sel:(NSString *)sel param:(NSDictionary *)param cb:(callback)cb{
    SEL  action = NSSelectorFromString([NSString stringWithFormat:@"%@:cb:",sel]);
    if ([self respondsToSelector:action]) {
        void (*imp)(id, SEL, NSDictionary*, callback) ;
        imp = (void (*)(id, SEL, NSDictionary*, callback))[self methodForSelector:action];
        imp(self,action,param,cb);
    }else{
        if (cb) {
            cb(nil,[NSError errorWithDomain:@"未找到模块对应方法" code:-1001 userInfo:nil]);
        }
    }

}

- (void)share:(NSDictionary *)prama cb:(callback)cb{

}










@end
