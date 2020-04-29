//
//  CJDispatherProtocol.h
//  CJKit
//
//  Created by vvipchen on 2020/4/8.
//  Copyright © 2020 Average-Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^callback)(id _Nullable result ,NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN
typedef void (^callbac1k)(id result);

@protocol CJDispatherProtocol <NSObject>
- (void)sel:(NSString *)sel param:(NSDictionary *)param  cb:(callback)cb;
@end


@protocol CJDispatherSupport <NSObject>
@property (nonatomic,weak) id<CJDispatherProtocol> action;
@end
NS_ASSUME_NONNULL_END
