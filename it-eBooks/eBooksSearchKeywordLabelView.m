//
//  eBooksSearchKeywordLabelView.m
//  it-eBooks
//
//  Created by 王落凡 on 15/8/27.
//  Copyright (c) 2015年 王落凡. All rights reserved.
//

#import "eBooksSearchKeywordLabelView.h"

#define LABEL_LEFT_MARGIN 10
#define LABEL_HEIGHT 25

@interface eBooksSearchKeywordLabelView () {
    CGFloat yOffset;
}

@end

@implementation eBooksSearchKeywordLabelView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_scrollView];
    }
    
    return self;
}

-(void)clearALLKeywordLabels {
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    return ;
}

-(void)generateLabelWithKeyword:(NSString *)keyword {
    UIButton* keyWordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [keyWordButton setTitle:keyword forState:UIControlStateNormal];
    [keyWordButton setBackgroundColor:[UIColor colorWithRed:((CGFloat) (arc4random() % 255)) / 255.0f green:((CGFloat) (arc4random() % 255)) / 255.0f blue:((CGFloat) (arc4random() % 255)) / 255.0f alpha:1.0f]];
    [keyWordButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [keyWordButton.layer setCornerRadius:5.0f];
    [keyWordButton setClipsToBounds:YES];
    [keyWordButton addTarget:self action:@selector(keywordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize textSize = [keyword boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f]} context:nil].size;
    
    UILabel* lastKeyWordButton = (UILabel*)[_scrollView.subviews lastObject];
    
    //没有控件
    if(lastKeyWordButton == nil && _scrollView.bounds.size.width > textSize.width + 2*LABEL_LEFT_MARGIN) {
        [keyWordButton setFrame:CGRectMake(LABEL_LEFT_MARGIN, LABEL_LEFT_MARGIN, textSize.width + LABEL_LEFT_MARGIN, LABEL_HEIGHT)];
        
        yOffset = keyWordButton.frame.origin.y + keyWordButton.frame.size.height + LABEL_LEFT_MARGIN;
    } else {
        //是否可以放在当前行
        CGFloat restWidth = _scrollView.bounds.size.width - lastKeyWordButton.frame.origin.x - lastKeyWordButton.frame.size.width - 2*LABEL_LEFT_MARGIN;
        if(restWidth >= textSize.width + LABEL_LEFT_MARGIN)
            [keyWordButton setFrame:CGRectMake(lastKeyWordButton.frame.origin.x + lastKeyWordButton.frame.size.width + LABEL_LEFT_MARGIN, lastKeyWordButton.frame.origin.y, textSize.width + LABEL_LEFT_MARGIN, LABEL_HEIGHT)];
        else if(_scrollView.bounds.size.width <= textSize.width + 2*LABEL_LEFT_MARGIN) {
            [keyWordButton setFrame:CGRectMake(LABEL_LEFT_MARGIN, yOffset, _scrollView.frame.size.width - 2*LABEL_LEFT_MARGIN, LABEL_HEIGHT)];
            yOffset = keyWordButton.frame.origin.y + keyWordButton.frame.size.height + LABEL_LEFT_MARGIN;
        }
        else {
            UIButton* firstKeywordButton = (UIButton*)[_scrollView.subviews firstObject];
            [keyWordButton setFrame:CGRectMake(firstKeywordButton.frame.origin.x, yOffset, textSize.width + LABEL_LEFT_MARGIN, LABEL_HEIGHT)];
            yOffset = keyWordButton.frame.origin.y + keyWordButton.frame.size.height + LABEL_LEFT_MARGIN;
        }
    }
    
    [keyWordButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_scrollView addSubview:keyWordButton];
    
    [_scrollView setContentSize:CGSizeMake(0, yOffset)];
    return ;
}

-(void)keywordButtonPressed:(UIButton*)sender {
    if([self.delegate respondsToSelector:@selector(keywordLabelSelected:)]) {
        NSString* keyword = [sender titleForState:UIControlStateNormal];
        [self.delegate keywordLabelSelected:keyword];
    }
    
    return ;
}

@end
