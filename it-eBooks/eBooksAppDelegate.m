//
//  AppDelegate.m
//  it-eBooks
//
//  Created by 王落凡 on 15/10/3.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import "eBooksAppDelegate.h"
#import "Reachability.h"
#import "eBooksPreviewController.h"
#import <UIView+Toast.h>

@interface UITabBarController (Rotate)

@end

@implementation UITabBarController (Rotate)

-(BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

@end

@interface UINavigationController (Rotate)

@end

@implementation UINavigationController (Rotate)

-(BOOL)shouldAutorotate {
    if([[self.viewControllers lastObject] isKindOfClass:[eBooksPreviewController class]])
        return [[self.viewControllers lastObject] shouldAutorotate];
    
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if([[self.viewControllers lastObject] isKindOfClass:[eBooksPreviewController class]])
        return [[self.viewControllers lastObject] supportedInterfaceOrientations];
    
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end

@interface UIViewController (Rotate)

@end

@implementation UIViewController (Rotate)

-(BOOL)shouldAutorotate {
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end

@interface eBooksAppDelegate ()

@end

@implementation eBooksAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:1.0f];
    
    //注册本地通知
    if([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityWithHostName:BASE_URL_SERVER];
    [self.reachability startNotifier];

    return YES;
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

-(void)networkStatusChanged:(NSNotification*)notification {
    Reachability *curReachability = [notification object];
    NSParameterAssert([curReachability isKindOfClass:[Reachability class]]);
    NetworkStatus curStatus = [curReachability currentReachabilityStatus];
    if(curStatus == ReachableViaWiFi) {
        [self.window makeToast:@"您已连接到WIFI网络" duration:2.0f position:CSToastPositionCenter];
    }else if(curStatus == ReachableViaWWAN) {
        [self.window makeToast:@"注意\n您已切换非WIFI环境，将产生流量费用" duration:2.0f position:CSToastPositionCenter];
    }else {
        [self.window makeToast:@"当前已断开网络连接" duration:2.0f position:CSToastPositionCenter];
    }
    
    return ;
}

//收到本地通知
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [application setApplicationIconBadgeNumber:0];
    //如果程序在前台执行，则弹出提示框
    if(application.applicationState == UIApplicationStateActive) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"通知" message:notification.alertBody delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        [alertView show];
    }
    
    return ;
}

-(void)dealloc {
    [self.reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
