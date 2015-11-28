//
//  eBooksFavoriteTableViewCell.h
//  it-eBooks
//
//  Created by 王落凡 on 15/8/28.
//  Copyright (c) 2015年 王落凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eBooksFavoriteTableViewCell;
@protocol eBooksFavoriteTableViewCellDelegate <NSObject>

@optional
-(void)tableViewCell:(eBooksFavoriteTableViewCell*)cell buttonIndex:(NSInteger)buttonIndex;

@end

@interface eBooksFavoriteTableViewCell : UITableViewCell {
    NSMutableArray* editButtonArray;
}

@property(nonatomic,assign) id<eBooksFavoriteTableViewCellDelegate> delegate;
@property(nonatomic,strong) UILabel* bookNameLabel;
@property(nonatomic,strong) UIView* bottomButtonView;
@property(nonatomic,strong) UIView* topTableViewCellContentView;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setTableViewCellEditButtonWithItemsTitle:(NSString*)itemTitle,...NS_REQUIRES_NIL_TERMINATION;
-(void)setTableViewCellEditButtonWithItemsArray:(NSArray*)itemArray;
-(void)setBookName:(NSString*)bookName;

@end
