//
//  eBooksFavoriteTableViewCell.m
//  it-eBooks
//
//  Created by 王落凡 on 15/8/28.
//  Copyright (c) 2015年 王落凡. All rights reserved.
//

#import "eBooksFavoriteTableViewCell.h"

#define BUTTON_WIDTH 60

@interface eBooksFavoriteTableViewCell () {
    CGFloat topTableViewCellContentViewPreviousPosition;
}

@end

@implementation eBooksFavoriteTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.bottomButtonView = [[UIView alloc] init];
        [self.contentView addSubview:self.bottomButtonView];
        
        self.topTableViewCellContentView = [[UIView alloc] init];
        [self.topTableViewCellContentView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.topTableViewCellContentView];
        
        self.bookNameLabel = [[UILabel alloc] init];
        [self.topTableViewCellContentView addSubview:self.bookNameLabel];
        
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)]];
        
        [self setTableViewCellEditButtonWithItemsTitle:@"删除", @"下载", @"详情", nil];
    }
    
    return self;
}

-(void)panGestureRecognizer:(UIPanGestureRecognizer*)recognizer {
    if(recognizer.state == UIGestureRecognizerStateBegan){
        topTableViewCellContentViewPreviousPosition = [recognizer translationInView:self.contentView].x;
    }else if(recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat position = [recognizer translationInView:self.contentView].x;
        CGFloat xoffset = self.topTableViewCellContentView.frame.origin.x + position -topTableViewCellContentViewPreviousPosition;
        
        if(xoffset > 0 || xoffset < -self.bottomButtonView.frame.size.width)
            return ;
        
        [self.topTableViewCellContentView setFrame:CGRectMake(xoffset, 0, self.topTableViewCellContentView.bounds.size.width, self.topTableViewCellContentView.bounds.size.height)];
        topTableViewCellContentViewPreviousPosition = position;
    }else if(recognizer.state == UIGestureRecognizerStateEnded) {
        if(self.topTableViewCellContentView.frame.origin.x > - self.bottomButtonView.frame.size.width / 2)
            [UIView animateWithDuration:0.2f animations:^{
                [self.topTableViewCellContentView setFrame:self.contentView.bounds];
            }];
        else
            [UIView animateWithDuration:0.2f animations:^{
                [self.topTableViewCellContentView setFrame:CGRectMake(-self.bottomButtonView.frame.size.width, 0, self.topTableViewCellContentView.frame.size.width, self.topTableViewCellContentView.frame.size.height)];
            }];
    }
    
    return ;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bottomButtonView setFrame:CGRectMake(self.contentView.frame.size.width - editButtonArray.count*BUTTON_WIDTH, 0, editButtonArray.count*BUTTON_WIDTH, self.contentView.frame.size.height)];
    [self.topTableViewCellContentView setFrame:self.contentView.bounds];
    [self.bookNameLabel setFrame:CGRectMake(20,0,0,0)];
    [self.bookNameLabel sizeToFit];
    [self.bookNameLabel setCenter:CGPointMake(self.bookNameLabel.center.x, self.topTableViewCellContentView.center.y)];

    [self addItems];
    return ;
}

-(void)setTableViewCellEditButtonWithItemsTitle:(NSString *)itemTitle, ... {
    if(editButtonArray == nil)
        editButtonArray = [[NSMutableArray alloc] init];
    
    [editButtonArray removeAllObjects];
    va_list args;
    va_start(args, itemTitle);
    
    [editButtonArray addObject:itemTitle];
    
    NSString* otherString;
    while((otherString = va_arg(args, NSString*)) != nil)
        [editButtonArray addObject:otherString];
    
    return ;
}

-(void)setTableViewCellEditButtonWithItemsArray:(NSArray *)itemArray {
    editButtonArray = [[NSMutableArray alloc] initWithArray:itemArray];
    return ;
}

-(void)addItems {
    assert(editButtonArray.count != 0);
    
    [self.bottomButtonView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    BOOL isFirstItem = YES;
    CGFloat xOffset = self.bottomButtonView.frame.size.width - BUTTON_WIDTH;
    for (NSString* title in editButtonArray) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTag:self.bottomButtonView.subviews.count];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        if(isFirstItem) {
             isFirstItem = NO;
            [button setBackgroundColor:[UIColor redColor]];
        }else{
            [button setBackgroundColor:[UIColor colorWithRed:((CGFloat)(arc4random() % 255)) / 255.0 green:((CGFloat)(arc4random() % 255)) / 255.0 blue:((CGFloat)(arc4random() % 255)) / 255.0 alpha:1.0f]];
        }
        [button setFrame:CGRectMake(xOffset, 0, BUTTON_WIDTH, self.bottomButtonView.frame.size.height)];
        xOffset -= BUTTON_WIDTH;
        [self.bottomButtonView addSubview:button];
    }
    
    return ;
}

-(void)buttonPressed:(UIButton*)sender {
    [UIView animateWithDuration:0.2f animations:^{
        [self.topTableViewCellContentView setFrame:self.contentView.bounds];
    }];
    if([self.delegate respondsToSelector:@selector(tableViewCell:buttonIndex:)])
        [self.delegate tableViewCell:self buttonIndex:sender.tag];
    
    return ;
}

-(void)setBookName:(NSString *)bookName {
    _bookNameLabel.text = bookName;
    return ;
}

@end
