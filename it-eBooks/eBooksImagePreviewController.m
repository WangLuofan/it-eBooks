//
//  eBooksImagePreviewController.m
//  it-eBooks
//
//  Created by 王落凡 on 15/10/8.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import "eBooksImagePreviewController.h"
#import "eBooksTools.h"

#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>

@implementation eBooksImagePreviewController

-(instancetype)initWithImageThumbUrl:(NSString *)thumbUrl {
    self = [super init];
    
    if(self) {
        self.imageThumbUrl = thumbUrl;
    }
    
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [_scrollView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView setDelegate:self];
    [_scrollView setMinimumZoomScale:1.0f];
    [_scrollView setMaximumZoomScale:5.0f];
    [self.view addSubview:_scrollView];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageView setUserInteractionEnabled:YES];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped)]];
    
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:imageView];
    [hud removeFromSuperViewOnHide];
    [imageView addSubview:hud];
    [hud show:YES];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNoneImage"] == NO || [eBooksTools getCurrentNetworkType] == NetworkTypeWifi)
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageThumbUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [hud hide:YES];
        }];
    
    [_scrollView addSubview:imageView];
    
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.25f animations:^{
        [_scrollView setBackgroundColor:[UIColor blackColor]];
        [((UIImageView*)_scrollView.subviews[0]) setBackgroundColor:[UIColor blackColor]];
    }];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return (UIImageView*)scrollView.subviews[0];
}

-(void)imageViewTapped {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    return ;
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

@end
