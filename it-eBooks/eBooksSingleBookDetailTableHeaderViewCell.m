//
//  eBooksSingleBookDetailTableHeaderViewCell.m
//  it-eBooks
//
//  Created by 王落凡 on 15/8/25.
//  Copyright (c) 2015年 王落凡. All rights reserved.
//

#import "eBooksSingleBookDetailTableHeaderViewCell.h"
#import "eBooksImagePreviewController.h"

#import <UIButton+WebCache.h>

#define BUTTON_HEIGHT 40
#define SEPARATOR_LINE_HEIGHT 0.5f

@implementation eBooksSingleBookDetailTableHeaderViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        self.BookThumbImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.BookThumbImageButton setContentMode:UIViewContentModeScaleAspectFit];
        [self.BookThumbImageButton addTarget:self action:@selector(viewPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.BookThumbImageButton];
        
        self.FavoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.FavoriteButton.tag = 0;
        [self.FavoriteButton setTitle:@"收藏书籍" forState:UIControlStateNormal];
        [self.FavoriteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.FavoriteButton setTitleColor:[UIColor brownColor] forState:UIControlStateHighlighted];
        [self.FavoriteButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [self.FavoriteButton setBackgroundColor:[UIColor colorWithRed:((CGFloat)217) / 255 green:((CGFloat)217) / 255 blue:((CGFloat)217) / 255 alpha:0.65f]];
        [self.FavoriteButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.FavoriteButton];
        
        self.DownloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.DownloadButton.tag = 1;
        [self.DownloadButton setTitle:@"下载书籍" forState:UIControlStateNormal];
        [self.DownloadButton setTitleColor:[UIColor brownColor] forState:UIControlStateHighlighted];
        [self.DownloadButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [self.DownloadButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.DownloadButton setBackgroundColor:[UIColor colorWithRed:((CGFloat)217) / 255 green:((CGFloat)217) / 255 blue:((CGFloat)217) / 255 alpha:0.65f]];
        [self.DownloadButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.DownloadButton];
        
        self.PreviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.PreviewButton.tag = 2;
        [self.PreviewButton setTitle:@"在线预览" forState:UIControlStateNormal];
        [self.PreviewButton setTitleColor:[UIColor brownColor] forState:UIControlStateHighlighted];
        [self.PreviewButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [self.PreviewButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.PreviewButton setBackgroundColor:[UIColor colorWithRed:((CGFloat)217) / 255 green:((CGFloat)217) / 255 blue:((CGFloat)217) / 255 alpha:0.65f]];
        [self.PreviewButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.PreviewButton];
        
//        separatorLine = [[UIView alloc] init];
//        [separatorLine setBackgroundColor:[UIColor redColor]];
//        [self.contentView addSubview:separatorLine];
    }
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.BookThumbImageButton setFrame:CGRectMake(5, 5, self.contentView.bounds.size.width * 1 / 3, self.contentView.bounds.size.height - 10)];
    [self.BookThumbImageButton setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.textLabel setFrame:CGRectMake(self.BookThumbImageButton.frame.origin.x + self.BookThumbImageButton.frame.size.width + 5, self.BookThumbImageButton.frame.origin.y, self.contentView.frame.size.width - self.BookThumbImageButton.frame.origin.x - self.BookThumbImageButton.frame.size.width - 10, 30)];
    [self.textLabel setTextAlignment:NSTextAlignmentCenter];
    [self.textLabel setTextColor:[UIColor redColor]];
        
    [self.FavoriteButton setFrame:CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y + self.textLabel.frame.size.height, self.textLabel.frame.size.width / 2 - 0.5, BUTTON_HEIGHT)];
    
    [self.DownloadButton setFrame:CGRectMake(self.FavoriteButton.frame.origin.x + self.FavoriteButton.frame.size.width + 2.5, self.FavoriteButton.frame.origin.y, self.FavoriteButton.frame.size.width, self.FavoriteButton.frame.size.height)];
    [self.PreviewButton setFrame:CGRectMake(self.FavoriteButton.frame.origin.x, self.FavoriteButton.frame.origin.y + self.FavoriteButton.frame.size.height + 5, self.textLabel.frame.size.width, self.BookThumbImageButton.frame.size.height - 5 - self.FavoriteButton.frame.origin.y - self.FavoriteButton.frame.size.height)];
//    [separatorLine setFrame:CGRectMake(0, self.contentView.frame.size.height - SEPARATOR_LINE_HEIGHT, self.contentView.frame.size.width, SEPARATOR_LINE_HEIGHT)];
    return ;
}

-(void)setFavorited:(BOOL)favorited {
    if(favorited) {
        [self.FavoriteButton setTitle:NSLocalizedString(@"Favorited", @"") forState:UIControlStateNormal];
    }else {
        [self.FavoriteButton setTitle:NSLocalizedString(@"Favorite Book", @"") forState:UIControlStateNormal];
    }
    
    [self.FavoriteButton setEnabled:!favorited];
    return ;
}

-(void)setCellInfoWithTitle:(NSString *)title imageUrl:(NSString *)imageUrl {
    [self.textLabel setText:title];
    [self.BookThumbImageButton sd_setBackgroundImageWithURL:FILE_URL(imageUrl) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"books"]];
}

-(void)viewPhoto {
    eBooksImagePreviewController* imageController = [[eBooksImagePreviewController alloc] initWithImageThumbUrl:imageUrlString];
    [imageController setHidesBottomBarWhenPushed:YES];
    UIResponder* responder = self.nextResponder;
    while(![responder isKindOfClass:[UIViewController class]])
        responder = responder.nextResponder;
    [[((UIViewController*)responder) navigationController] pushViewController:imageController animated:YES];
    
    return ;
}

-(void)buttonPressed:(UIButton*)sender {
    if([self.delegate respondsToSelector:@selector(singleBookDetailTableViewCellButtonPressed:)])
        [self.delegate singleBookDetailTableViewCellButtonPressed:sender];
    
    return ;
}

@end
