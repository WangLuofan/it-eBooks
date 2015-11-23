//
//  eBooksUserRegistTableViewCell.h
//  it-eBooks
//
//  Created by 王落凡 on 15/10/28.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,Cell_Type) {
    Cell_Type_HeaderImage,
    Cell_Type_TextField,
    Cell_Type_Password_TextField,
    Cell_Type_SegmentControl,
    Cell_Type_DatePicker,
    Cell_Type_NumberPad,
    Cell_Type_Button,
    Cell_Type_Alphabet
};

@protocol eBooksUserRegistTableViewCellDelegate <NSObject>

@optional
-(void)dateChanged:(NSDate*)date;

@end

@class eBooksUserHeaderView;
@interface eBooksUserRegistTableViewCell : UITableViewCell <UITextFieldDelegate>

@property(nonatomic,assign) id<eBooksUserRegistTableViewCellDelegate> delegate;
@property(nonatomic,strong) eBooksUserHeaderView* userHeaderView;
@property(nonatomic,assign) BOOL canThisDataBeNull;

@property(nonatomic,strong) UIControl* contentControl;
-(instancetype)initWithInfoDict:(NSDictionary*)infoDict;

@end
