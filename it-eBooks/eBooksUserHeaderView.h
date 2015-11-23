//
//  eBooksUserHeaderView.h
//  it-eBooks
//
//  Created by 王落凡 on 15/10/11.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eBooksUserHeaderView : UIView <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property(nonatomic,strong) UIVisualEffectView* effectView;
@property(nonatomic,strong) UIImageView* backgroundImageView;
@property(nonatomic,assign) BOOL isOnlyChangeHeader;

@property(nonatomic,strong) UIButton* headImageView;
@property(nonatomic,strong) UILabel* usernameLabel;
@property(nonatomic,strong) UILabel* messageLabel;
@property(nonatomic,copy) NSString* imageFileName;

-(void)updateUserInfomation;
-(void)userLogin;

@end
