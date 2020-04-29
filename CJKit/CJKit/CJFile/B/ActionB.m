//
//  ActionB.m
//  CJKit
//
//  Created by vvipchen on 2020/4/8.
//  Copyright © 2020 Average-Chen. All rights reserved.
//

#import "ActionB.h"

@implementation ActionB
- (void)sel:(NSString *)sel param:(NSDictionary *)param cb:(callback)cb{
    SEL action = NSSelectorFromString(@"test");
    NSLog(@"222");
}
@end
