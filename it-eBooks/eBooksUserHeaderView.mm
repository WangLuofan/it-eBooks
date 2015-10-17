//
//  eBooksUserHeaderView.m
//  it-eBooks
//
//  Created by 王落凡 on 15/10/11.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import "eBooksUserHeaderView.h"
#import "eBooksNetworkingHelper.h"
#import "eBooksUserInfo.hpp"

#import "eBooksPersonViewController.h"

#import <MBProgressHUD.h>

#define kControlMargin 25
#define kInfoLabelSize 25
#define kHeadImageViewSize 100

@implementation eBooksUserHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
        [self setBackgroundColor:[UIColor brownColor]];
        
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.backgroundImageView setImage:[UIImage imageNamed:@"default_head"]];
        [self addSubview:self.backgroundImageView];
        
        self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        [self.effectView setAlpha:1.0f];
        [self.effectView setFrame:self.bounds];
        [self addSubview:self.effectView];
        
        self.headImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.headImageView setFrame:CGRectMake(self.effectView.bounds.size.width - 2*kControlMargin - kHeadImageViewSize, 2*kControlMargin, kHeadImageViewSize, kHeadImageViewSize)];
        [self.headImageView setCenter:CGPointMake(self.effectView.center.x, self.effectView.center.y)];
        [self.headImageView setBackgroundColor:[UIColor whiteColor]];
        [self.headImageView setClipsToBounds:YES];
        [self.headImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.headImageView.layer setCornerRadius:kHeadImageViewSize / 2 ];
        [self.headImageView setBackgroundImage:[UIImage imageNamed:@"default_head"] forState:UIControlStateNormal];
        [self.headImageView addTarget:self action:@selector(changeHeadImage) forControlEvents:UIControlEventTouchUpInside];
        [self.effectView addSubview:self.headImageView];
        
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kControlMargin / 2, self.headImageView.frame.origin.y, self.effectView.bounds.size.width - self.headImageView.frame.origin.x + kControlMargin, 2*kInfoLabelSize)];
        [self.usernameLabel setTextColor:[UIColor whiteColor]];
        [self.usernameLabel setTextAlignment:NSTextAlignmentCenter];
//        [self.usernameLabel setCenter:CGPointMake(self.usernameLabel.center.x, self.headImageView.center.y / 2)];
        [self.usernameLabel setFont:[UIFont boldSystemFontOfSize:30.0f]];
        [self.usernameLabel adjustsFontSizeToFitWidth];
        [self.usernameLabel setHidden:YES];
        [self.effectView addSubview:self.usernameLabel];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.usernameLabel.frame.origin.x, self.usernameLabel.frame.origin.y + self.usernameLabel.frame.size.height + 5, self.usernameLabel.frame.size.width, kInfoLabelSize)];
        [self.messageLabel setTextAlignment:NSTextAlignmentCenter];
        [self.messageLabel setCenter:CGPointMake(self.usernameLabel.center.x, self.messageLabel.center.y)];
        [self.messageLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [self.messageLabel setNumberOfLines:0];
        [self.messageLabel setTextColor:[UIColor whiteColor]];
        [self.messageLabel setHidden:YES];
        [self.effectView addSubview:self.messageLabel];
    
    }
    
    [self setUserInfo:@{@"headImage":[UIImage imageNamed:@"default_head"],
                        @"userName":@"人生如梦",
                        @"userMessage":@"逆天改命,再创世纪!!!!"}];
    return self;
}

-(void)changeHeadImage {
    if(eBooksUserInfo::sharedInstance()->isUserLogin()) {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"修改用户头像\n请选择头像图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销" otherButtonTitles:@"相机",@"图库", nil];
        [actionSheet setTag:101];
        [actionSheet showInView:self];
    }else {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"登陆?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"登陆" otherButtonTitles:@"注册", nil];
        [actionSheet setTag:102];
        [actionSheet showInView:self];
    }
    return ;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet.tag == 101) {
        UIImagePickerController* pickerController = [[UIImagePickerController alloc] init];
        switch (buttonIndex) {
            case 0:
            {
                eBooksUserInfo::sharedInstance()->changeLoginState(false);
                [self setUserInfo:nil];
                
                UIResponder* responder = self.nextResponder;
                while(![responder isKindOfClass:[eBooksPersonViewController class]])
                    responder = responder.nextResponder;
                [((eBooksPersonViewController*)responder).tableView setHidden:YES];
                
                return ;
            }
                break;
            case 1:
            {
                if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"设备照相机不可用,请检查" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
                    [alertView show];
                    
                    return ;
                }
                [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            }
                break;
            case 2:
            {
                if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"设备图库不可用,请检查" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
                    [alertView show];
                    
                    return ;
                }
                
                [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
                break;
            default:
                return ;
                break;
        }
        
        [pickerController setDelegate:self];
        UIResponder* responser = self.nextResponder;
        while (![responser isKindOfClass:[UIViewController class]])
            responser = responser.nextResponder;
        [((UIViewController*)responser) presentViewController:pickerController animated:YES completion:nil];
    } else {
        switch (buttonIndex) {
            case 0:
            {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"登陆" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登陆", nil];
                [alertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                if([userDefaults boolForKey:@"isRememberPassword"]) {
                    NSString* userName = [userDefaults objectForKey:@"userName"];
                    NSString* password = [userDefaults objectForKey:@"userPassword"];
                    
                    if(userName != nil && password != nil) {
                        [[alertView textFieldAtIndex:0] setText:userName];
                        [[alertView textFieldAtIndex:1] setText:password];
                    }
                    
                }
                
                [alertView show];
            }
                break;
            case 1:
                break;
            default:
                break;
        }
    }
    
    return ;
}

-(void)setUserInfo:(NSDictionary *)userInfo {
    if(eBooksUserInfo::sharedInstance()->isUserLogin()) {
        [UIView animateWithDuration:0.5f animations:^{
            UIImage* headImage = (UIImage*)userInfo[@"headImage"];
            if(headImage != nil)
                [self.headImageView setBackgroundImage:headImage forState:UIControlStateNormal];
            else
                [self.headImageView setBackgroundImage:[UIImage imageNamed:@"default_head"] forState:UIControlStateNormal];
            [self.backgroundImageView setImage:headImage];
            [self.headImageView setCenter:CGPointMake(self.effectView.bounds.size.width * 3 / 4, self.headImageView.center.y)];
        }];
        
        [UIView animateWithDuration:0.5f animations:^{
            NSString* username = (NSString*)userInfo[@"userName"];
            if(username != nil)
                [self.usernameLabel setText:username];
            
            NSString* message = (NSString*)userInfo[@"userMessage"];
            if(message != nil) {
                [self.messageLabel setText:message];
                CGFloat textHeight = [message boundingRectWithSize:CGSizeMake(self.usernameLabel.bounds.size.width, self.effectView.    bounds.size.height - self.messageLabel.frame.origin.y - kControlMargin) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:    nil].size.height;
                [self.messageLabel setFrame:CGRectMake(self.messageLabel.frame.origin.x, self.messageLabel.frame.origin.y, self.    messageLabel.frame.size.width, textHeight)];
            }else
                [self.messageLabel setText:@"这家伙很懒,什么都没留下~"];
            
            [self.messageLabel setHidden:NO];
            [self.usernameLabel setHidden:NO];
        }];
    }else {
        [UIView animateWithDuration:0.5f animations:^{
            [self.usernameLabel setHidden:YES];
            [self.messageLabel setHidden:YES];
            [self.headImageView setBackgroundImage:[UIImage imageNamed:@"default_head"] forState:UIControlStateNormal];
            [self.headImageView setCenter:CGPointMake(self.effectView.center.x, self.headImageView.center.y)];
        }];
    }
    
    return ;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage* pickedImage = (UIImage*)info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self setUserInfo:@{@"headImage":pickedImage,@"userName":self.usernameLabel.text,@"userMessage":self.messageLabel.text}];
    }];
    
    return ;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        NSString* userNameStr = [[alertView textFieldAtIndex:0] text];
        NSString* passwordStr = [[alertView textFieldAtIndex:1] text];
        [[eBooksNetworkingHelper getSharedInstance] loginWithName:userNameStr Password:passwordStr];
        
        UIResponder* responder = self.nextResponder;
        while(![responder isKindOfClass:[UIViewController class]])
            responder = responder.nextResponder;
        [MBProgressHUD showHUDAddedTo:((UIViewController*)responder).view animated:YES];
    }
    
    return ;
}

@end
