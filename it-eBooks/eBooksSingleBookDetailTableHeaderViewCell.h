//
//  eBooksSingleBookDetailTableHeaderViewCell.h
//  it-eBooks
//
//  Created by 王落凡 on 15/8/25.
//  Copyright (c) 2015年 王落凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol eBooksSingleBookDetailTableHeaderViewCellDelegate <NSObject>

@optional
-(void)singleBookDetailTableViewCellButtonPressed:(UIButton*)button;

@end

@interface eBooksSingleBookDetailTableHeaderViewCell : UITableViewCell {
    NSString* imageUrlString;
    UIView* separatorLine;
}

@property(nonatomic,strong) UIButton* BookThumbImageButton;     //书籍缩略图
@property(nonatomic,strong) UIButton* FavoriteButton;           //收藏
@property(nonatomic,strong) UIButton* DownloadButton;           //下载
@property(nonatomic,strong) UIButton* PreviewButton;            //阅读

@property(nonatomic,assign) id<eBooksSingleBookDetailTableHeaderViewCellDelegate> delegate;

-(void)setFavorited:(BOOL)favorited;
-(void)setCellInfoWithTitle:(NSString*)title imageUrl:(NSString*)imageUrl;

@end
