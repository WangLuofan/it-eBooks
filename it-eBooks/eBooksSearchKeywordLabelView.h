//
//  eBooksSearchKeywordLabelView.h
//  it-eBooks
//
//  Created by 王落凡 on 15/8/27.
//  Copyright (c) 2015年 王落凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol eBooksSearchKeywordLabelViewDelegate <NSObject>

@optional
-(void)keywordLabelSelected:(NSString*)keyword;

@end

@interface eBooksSearchKeywordLabelView : UIView

@property(nonatomic,strong) UIScrollView* scrollView;
@property(nonatomic,assign) id<eBooksSearchKeywordLabelViewDelegate> delegate;

-(void)generateLabelWithKeyword:(NSString*)keyword;
-(void)clearALLKeywordLabels;

@end
