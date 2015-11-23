//
//  eBooksTools.m
//  it-eBooks
//
//  Created by 王落凡 on 15/10/31.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import "eBooksTools.h"
#import "Reachability.h"

@implementation eBooksTools

+(UIImage *)imageFromColor:(UIColor*)color {
    UIGraphicsBeginImageContext(CGSizeMake(1.0f, 1.0f));
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(theContext, [color CGColor]);
    CGContextFillRect(theContext, CGRectMake(0, 0, 1.0f, 1.0f));
    UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+(NetworkType)getCurrentNetworkType {
    Reachability* reachability = [Reachability reachabilityWithHostName:BASE_URL_SERVER];
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable:
            return NetworkTypeNone;
            break;
        case ReachableViaWiFi:
            return NetworkTypeWifi;
            break;
        case ReachableViaWWAN:
            return NetworkTypeWWan;
            break;
        default:
            break;
    }
    
    return NetworkTypeNone;
}

@end
