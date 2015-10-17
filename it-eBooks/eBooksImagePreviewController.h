//
//  eBooksImagePreviewController.h
//  it-eBooks
//
//  Created by 王落凡 on 15/10/8.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eBooksImagePreviewController : UIViewController <UIScrollViewDelegate> {
    UIScrollView* _scrollView;
}

@property(nonatomic,copy) NSString* imageThumbUrl;

-(instancetype)initWithImageThumbUrl:(NSString*)thumbUrl;

@end
