//
//  AppDelegate.m
//  CJKit
//
//  Created by vvipchen on 2020/4/8.
//  Copyright © 2020 Average-Chen. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "JPUSHService.h"
@interface AppDelegate ()<UNUserNotificationCenterDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;//设置该代理对象尽量在willFinishLaunchingWithOptions方法中，设置太晚可能无法及时处理通知消息
    UNAuthorizationOptions options = UNAuthorizationOptionBadge + UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    //请求指定推送设置的权限
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        NSLog(@"granted:%@, error:%@", @(granted), error);
        //获得权限后注册远程推送通知
        if (!error && granted)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
        }
    }];

    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    [JPUSHService setupWithOption:launchOptions appKey:@"612d19f6e8e76953d0e608ed"
                          channel:@"appStore"
                 apsForProduction:NO
            advertisingIdentifier:nil];
    
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
     entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
     if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
       // 可以添加自定义 categories
       // NSSet<UNNotificationCategory *> *categories for iOS10 or later
       // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
     }
     [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"5524b7bd"];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *apnsToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"anpsToken:%@",apnsToken);
    //update deviceToken
    [JPUSHService registerDeviceToken:deviceToken];

}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
