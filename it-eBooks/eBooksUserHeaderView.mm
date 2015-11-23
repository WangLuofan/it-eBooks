//
//  eBooksUserHeaderView.m
//  it-eBooks
//
//  Created by 王落凡 on 15/10/11.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import "eBooksUserHeaderView.h"
#import "eBooksNetworkingHelper.h"
#import "eBooksUserRegistViewController.h"
#import "eBooksPersonViewController.h"
#import "eBooksUserBookStatusList.hpp"
#import "eBooksTools.h"

#import <MBProgressHUD.h>
#import <UIButton+WebCache.h>
#import <AssetsLibrary/AssetsLibrary.h>

#include "eBooksUserInfo.hpp"

#define kControlMargin 25
#define kInfoLabelSize 25
#define kHeadImageViewSize 100

@implementation eBooksUserHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
        [self setBackgroundColor:[UIColor brownColor]];
        
        self.isOnlyChangeHeader = NO;
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.backgroundImageView setImage:[UIImage imageNamed:@"default_head"]];
        [self.backgroundImageView setContentMode:UIViewContentModeScaleToFill];
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
    
        self.imageFileName = @"default_head.png";
    }
    return self;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self.effectView setFrame:self.bounds];
    [self.backgroundImageView setFrame:self.bounds];
    [self.headImageView setCenter:CGPointMake(self.effectView.center.x, self.effectView.center.y)];
    
    return ;
}

-(void)changeHeadImage {
    if(_isOnlyChangeHeader) {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"修改用户头像\n请选择头像图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"图库", nil];
        [actionSheet setTag:101];
        [actionSheet showInView:self];
    }else {
        if(eBooksUserInfo::sharedInstance()->isUserLogin()) {
            UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"修改用户头像\n请选择头像图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销" otherButtonTitles:@"相机",@"图库", nil];
            [actionSheet setTag:102];
            [actionSheet showInView:self];
        }else {
            UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"登陆?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"登陆" otherButtonTitles:@"注册", nil];
            [actionSheet setTag:103];
            [actionSheet showInView:self];
        }
    }
    return ;
}

-(void)userLogin {
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
    return ;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet.tag == 101) {
        UIImagePickerController* pickerController = [[UIImagePickerController alloc] init];
        switch (buttonIndex) {
            case 0:
            {
                if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"设备照相机不可用,请检查" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
                    [alertView show];
                    
                    return ;
                }
                [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            }
                break;
            case 1:
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
    }
    else if(actionSheet.tag == 102) {
        UIImagePickerController* pickerController = [[UIImagePickerController alloc] init];
        switch (buttonIndex) {
            case 0:
            {
                eBooksUserInfo::sharedInstance()->changeLoginState(false);
                UIResponder* responder = self.nextResponder;
                while(![responder isKindOfClass:[eBooksPersonViewController class]])
                    responder = responder.nextResponder;
                [((eBooksPersonViewController*)responder).tableView setHidden:YES];
                [self updateUserInfomation];
                
                UIAlertView* alertVIew = [[UIAlertView alloc] initWithTitle:@"消息" message:@"您已经成功注销" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                [alertVIew show];
                
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
                [self userLogin];
                break;
            case 1:
            {
                eBooksUserRegistViewController* registViewController = [[eBooksUserRegistViewController alloc] init];
                [registViewController setHidesBottomBarWhenPushed:YES];
                UIResponder* responder = self.nextResponder;
                while(![responder isKindOfClass:[UIViewController class]])
                    responder = responder.nextResponder;
                [((UIViewController*)responder).navigationController pushViewController:registViewController animated:YES];
            }
                break;
            default:
                break;
        }
    }
    
    return ;
}

-(void)updateUserInfomation {
    if(eBooksUserInfo::sharedInstance()->isUserLogin()) {
        [UIView animateWithDuration:0.5f animations:^{
            NSString* imageUrl = [NSString stringWithUTF8String:eBooksUserInfo::sharedInstance()->getUserHeaderImage().c_str()];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNoneImage"] == NO || [eBooksTools getCurrentNetworkType] == NetworkTypeWifi) {
                [self.headImageView sd_setBackgroundImageWithURL:FILE_URL(imageUrl) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head"] completed:^(UIImage *image, NSError *error,SDImageCacheType cacheType, NSURL *imageURL) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.backgroundImageView setImage:image];
                    });
                }];
            }else
                [self.headImageView setBackgroundImage:[UIImage imageNamed:@"default_head"] forState:UIControlStateNormal];
            
            [self.headImageView setCenter:CGPointMake(self.effectView.bounds.size.width * 3 / 4, self.headImageView.center.y)];
        }];
        
        [UIView animateWithDuration:0.5f animations:^{
            [self.usernameLabel setText:[NSString stringWithUTF8String:eBooksUserInfo::sharedInstance()->getNickName().c_str()]];
            [self.messageLabel setText:(eBooksUserInfo::sharedInstance()->getUserMessage().length() == 0 ? @"这家伙很懒，什么都没有留下~" : [NSString stringWithUTF8String:eBooksUserInfo::sharedInstance()->getUserMessage().c_str()])];
            CGFloat textHeight = [self.messageLabel.text boundingRectWithSize:CGSizeMake(self.usernameLabel.bounds.size.width, self.effectView.    bounds.size.height - self.messageLabel.frame.origin.y - kControlMargin) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:    nil].size.height;
            [self.messageLabel setFrame:CGRectMake(self.messageLabel.frame.origin.x, self.messageLabel.frame.origin.y, self.    messageLabel.frame.size.width, textHeight)];
            
            [self.messageLabel setHidden:NO];
            [self.usernameLabel setHidden:NO];
        }];
    }else {
        [UIView animateWithDuration:0.5f animations:^{
            [self.usernameLabel setHidden:YES];
            [self.messageLabel setHidden:YES];
            [self.headImageView setBackgroundImage:[UIImage imageNamed:@"default_head"] forState:UIControlStateNormal];
            [self.backgroundImageView setImage:[UIImage imageNamed:@"default_head"]];
            [self.headImageView setCenter:CGPointMake(self.effectView.center.x, self.headImageView.center.y)];
            
        } completion:^(BOOL finished) {
            if(finished) {
                eBooksUserInfo::sharedInstance()->userLogoff();
                eBooksUserBookStatusList::getInstance()->clearAll();
            }
        }];
    }
    
    return ;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage* pickedImage = (UIImage*)info[UIImagePickerControllerOriginalImage];
    if(!_isOnlyChangeHeader){
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:info[UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
            self.imageFileName = asset.defaultRepresentation.filename;
            if(self.imageFileName == nil)
                self.imageFileName = [self getImageFileName];
            
            [[eBooksNetworkingHelper getSharedInstance] UPLOADImageWithParams:@{@"image":pickedImage,@"name":self.imageFileName,@"_userID":[NSNumber numberWithInt:eBooksUserInfo::sharedInstance()->getUserID()]} Success:^(id responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateUserInfomation];
                });
            } Failure:^(NSError *error) {
                return ;
            }];
        } failureBlock:^(NSError *error) {
        }];
    }else {
        [self.headImageView setBackgroundImage:pickedImage forState:UIControlStateNormal];
        [self.backgroundImageView setImage:pickedImage];
    }
    
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

-(NSString*)getImageFileName {
    CFUUIDRef uuidref = CFUUIDCreate(nil);
    NSString* uuidStr = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidref);
    CFRelease(uuidref);
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    return [uuidStr stringByAppendingString:[NSString stringWithFormat:@"_%@.jpg",[formatter stringFromDate:[NSDate date]]]];;
}

@end
