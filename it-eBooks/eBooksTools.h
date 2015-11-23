//
//  eBooksTools.h
//  it-eBooks
//
//  Created by 王落凡 on 15/10/31.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,NetworkType) {
    NetworkTypeNone,
    NetworkTypeWWan,
    NetworkTypeWifi
};


@interface eBooksTools : NSObject

+(UIImage*)imageFromColor:(UIColor*)color;
+(NetworkType)getCurrentNetworkType;

@end
