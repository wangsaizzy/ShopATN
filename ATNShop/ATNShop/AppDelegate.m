//
//  AppDelegate.m
//  ATNShop
//
//  Created by 王赛 on 16/8/30.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "AppDelegate.h"
#import "ShopManagerController.h"
#import "LoginAndRegistViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /**
     *  设置启动页时间
     */
    [NSThread sleepForTimeInterval:1.0];
    
    
    /**
     *  创建窗口
     */
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    /**
     *  绑定根视图
     */
    [AMapServices sharedServices].apiKey = KAMap2DMapKey;
    
    //    self.mapView = [[MAMapView alloc] init];
    //    _mapView.delegate = self;
    //
    //    NSString *longitude = [NSString stringWithFormat:@"%@", [UserModel defaultModel].longitude];
    //    NSString *latitude = [NSString stringWithFormat:@"%@", [UserModel defaultModel].latitude];
    //
    //    if ([longitude floatValue] > 0 && [latitude floatValue] > 0) {
    //
    //        _mapView.showsUserLocation = NO;    //YES 为打开定位，NO为关闭定位
    //
    //
    //
    //    } else {
    //
    //        _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    //        _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    //
    //        [_mapView setZoomLevel:16.1 animated:YES];
    //    }
    
    
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [SVProgressHUD showSuccessWithStatus:@"当前未知网络"];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [SVProgressHUD showSuccessWithStatus:@"无网络连接"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [SVProgressHUD showSuccessWithStatus:@"当前为3G/4G网络"];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [SVProgressHUD showSuccessWithStatus:@"当前为WiFi网络"];
                break;
        }
    }];
    
    
    
    ShopManagerController *shopVC = [[ShopManagerController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:shopVC];
    
    NSTimeInterval timeInterval = [self timeAgo];
    
    if (timeInterval < 604795) {
        
        self.window.rootViewController = navi;
    } else {
        
        // 进入登录页面
        self.window.rootViewController = navi;
        [UserModel defaultModel].isAppLogin = NO;
    }
    return YES;
}

- (NSTimeInterval)timeAgo{
    
    //1.创建时间与当前的时间差
    NSTimeInterval intervel = [[NSDate date] timeIntervalSinceDate:[TimeTool unarchiveLoginDate]];
    return intervel;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
