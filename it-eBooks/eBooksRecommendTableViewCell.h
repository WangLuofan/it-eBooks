//
//  eBooksRecommendTableViewCell.h
//  it-eBooks
//
//  Created by 王落凡 on 15/11/14.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eBooksRecommendTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView* eBookImageView;
@property(nonatomic,strong) UILabel* eBookNameLabel;
@property(nonatomic,strong) UILabel* eBookAuthorLabel;
@property(nonatomic,strong) UILabel* eBookDescriptionLabel;

@property(nonatomic,strong) UIView* eBookCellContentView;

@end
