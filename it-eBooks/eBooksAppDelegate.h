//
//  AppDelegate.h
//  it-eBooks
//
//  Created by 王落凡 on 15/10/3.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;
@interface eBooksAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong) Reachability* reachability;

@end

