//
//  eBooksPreviewController.h
//  it-eBooks
//
//  Created by 王落凡 on 15/10/14.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;
@interface eBooksPreviewController : UIViewController <UIWebViewDelegate>{
    NSURL* fileUrl;
    MBProgressHUD* hud;
}

-(instancetype)initWithFileUrl:(NSURL*)url;

@property(nonatomic,strong) UIWebView* webView;

@end
