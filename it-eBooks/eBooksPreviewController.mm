//
//  eBooksPreviewController.m
//  it-eBooks
//
//  Created by 王落凡 on 15/10/14.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import "eBooksPreviewController.h"
#import <MBProgressHUD.h>

@implementation eBooksPreviewController

-(instancetype)initWithFileUrl:(NSURL *)url {
    self = [super init];
    
    if(self) {
        fileUrl = url;
    }
    
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.webView loadRequest:[NSURLRequest requestWithURL:fileUrl]];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:fileUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]];
    [self.webView setDelegate:self];
    [self.webView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    [self.view addSubview:self.webView];
    
    NSInteger oriention = [[NSUserDefaults standardUserDefaults] integerForKey:@"onlineReadOriention"];
    switch (oriention) {
            //向左
        case 0:
        {
            [UIView animateWithDuration:0.5f animations:^{
                self.view.transform = CGAffineTransformMakeRotation(-M_PI_2);
                [self.webView setFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width)];
            }];
        }
            break;
            //向右
        case 2:
        {
            [UIView animateWithDuration:0.5f animations:^{
                self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
                [self.webView setFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width)];
            }];
        }
            break;
        default:
            break;
    }
    
    return ;
}

-(void)tap:(UIGestureRecognizer*)recognizer {
    if(self.navigationController.navigationBarHidden)
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    else
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.webView setFrame:self.view.bounds];
    return ;
}

-(BOOL)prefersStatusBarHidden {
    return self.navigationController.navigationBarHidden;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud removeFromSuperViewOnHide];
    [hud setLabelText:@"加载中..."];
    [self.view addSubview:hud];
    [hud show:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [hud setMode:MBProgressHUDModeText];
    [hud setLabelText:@"无法加载书籍"];
    [hud hide:YES afterDelay:1.0f];
    
    return ;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [hud hide:YES];
}

@end
