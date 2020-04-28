//
//  ShareProtocol.h
//  Share
//
//  Created by vvipchen on 2020/4/17.
//  Copyright © 2020 Average-Chen. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void (^completionHandler)(id _Nullable result ,NSError * _Nullable error);
NS_ASSUME_NONNULL_BEGIN

@protocol ShareProtocol <NSObject>
@optional
- (NSDictionary*)getServices;//分享服务
- (void)sendWithSystem:(NSDictionary *)shareParams;//使用分享
//sucess YES 表示分享成功,
- (void)shareReuslt:(BOOL)suceess error:(NSError *)error;//分享调用结束



- (void(^)(completionHandler cpm))getShareServices;
- (void(^)(NSDictionary*param, completionHandler cpm))share;


@end



@protocol ShareSupport <NSObject>
@property (nonatomic,weak) id<ShareProtocol> action;
@end


NS_ASSUME_NONNULL_END
