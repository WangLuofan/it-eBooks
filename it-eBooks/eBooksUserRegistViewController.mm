//
//  eBooksUserRegistViewController.m
//  it-eBooks
//
//  Created by 王落凡 on 15/10/27.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import "eBooksUserRegistViewController.h"
#import "eBooksNetworkingHelper.h"
#import "eBooksUserHeaderView.h"
#import "eBooksUserRegistTableViewCell.h"

#import <MBProgressHUD.h>

#include "eBooksUserInfo.hpp"

@interface eBooksUserRegistViewController () <eBooksUserRegistTableViewCellDelegate> {
    CGPoint tableViewPreviousCenter;
    MBProgressHUD* registHud;
}

@end

@implementation eBooksUserRegistViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"用户注册"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    tableViewPreviousCenter = self.tableView.center;
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(regist)];
    
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setDimBackground:YES];
    [self.view addSubview:hud];
    [hud show:YES];
    
    [[eBooksNetworkingHelper getSharedInstance] GET:SERVICE_FETCH_USER_REGIST_TABLE Params:nil Success:^(id responseObject) {
        if(responseObject) {
            registTableViewCellArray = [NSMutableArray array];
            for (NSDictionary* itemDict in responseObject) {
                eBooksUserRegistTableViewCell* cell = [[eBooksUserRegistTableViewCell alloc] initWithInfoDict:itemDict];
                [cell setDelegate:self];
                [registTableViewCellArray addObject:cell];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.tableView reloadData];
        });
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud setMode:MBProgressHUDModeText];
            [hud setLabelText:error.localizedDescription];
            [hud showAnimated:YES whileExecutingBlock:^{
                [NSThread sleepForTimeInterval:1.0f];
            } completionBlock:^{
                __weak typeof(self) weakSelf = self;
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        });
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    return ;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self dateChanged:[NSDate date]];
    
    return ;
}

-(UserRegistResult)canUserRegist {
    //检查所需字段是否为空
    for (eBooksUserRegistTableViewCell* cell in registTableViewCellArray) {
        //如果该字段不允许为空，但字段为空
        if(!cell.canThisDataBeNull) {
            if([cell.contentControl isKindOfClass:[UITextField class]] && ((UITextField*)cell.contentControl).text.length == 0)
                return UserRegistResultInfoImperfect;
        }
    }
    
    if(![((UITextField*)((eBooksUserRegistTableViewCell*)registTableViewCellArray[2]).contentControl).text isEqualToString:((UITextField*)((eBooksUserRegistTableViewCell*)registTableViewCellArray[3]).contentControl).text])
        return UserRegistResultPasswordConfirmError;
    
    return UserRegistResultSuccess;
}

//判断用户名是否已经被注册
-(UserRegistResult)isUserNameRegisted {
    eBooksUserRegistTableViewCell* theCell = (eBooksUserRegistTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString* userName = ((UITextField*)theCell.contentControl).text;
    
    __block UserRegistResult result;
    [[eBooksNetworkingHelper getSharedInstance] GET:SERVICE_USER_NAME_REGISTED Params:@{@"userName" : userName} Success:^(id responseObject) {
        result = ([responseObject[@"Result"] intValue] == 1 ? UserRegistResultUserNameExists : UserRegistResultSuccess);
        if(result != UserRegistResultSuccess)
            [self showError:result];
        else
            [self doRegist];
    } Failure:^(NSError *error) {
        result =  UserRegistResultNetworkProblem;
        return ;
    }];
    
    return result;
}

-(void)showError:(UserRegistResult)result {
    NSString* message = nil;
    switch (result) {
        case UserRegistResultInfoImperfect:
            message = @"要求的信息未填写完整,请检查";
            break;
        case UserRegistResultUserNameExists:
            message = @"用户名已存在,请更换用户名重新注册";
            break;
        case UserRegistResultPasswordConfirmError:
            message = @"输入的密码不一致，请重新输入";
            break;
        default:
            break;
    }
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [alertView show];
    return ;
}

-(void)regist {
    if(registHud == nil) {
        registHud = [[MBProgressHUD alloc] initWithView:self.view];
        [registHud setMode:MBProgressHUDModeText];
        [registHud removeFromSuperViewOnHide];
        [registHud setDimBackground:YES];
        [registHud setLabelText:@"正在提交用户信息..."];
        [self.view addSubview:registHud];
    }
    [registHud show:YES];
    //1､验证必填字段是否为空
    UserRegistResult result = [self canUserRegist];
    if(result != UserRegistResultSuccess) {
        [self showError:result];
        return ;
    }
    //2、验证用户名是否已经存在
    [self isUserNameRegisted];
    return ;
}

//注册用户
-(void)doRegist {
    //上传用户头像和注册表单信息
    
    UIImage* image = [((eBooksUserRegistTableViewCell*)registTableViewCellArray[0]).userHeaderView.headImageView backgroundImageForState:UIControlStateNormal];
    [[eBooksNetworkingHelper getSharedInstance] UPLOADImageWithParams:@{@"image" : image,@"name" : ((eBooksUserRegistTableViewCell*)registTableViewCellArray[0]).userHeaderView.imageFileName,@"_userID":[NSNumber numberWithInt:eBooksUserInfo::sharedInstance()->getUserID()]} Success:^(id responseObject) {
        //上传用户头像成功之后再上传用户其他资料
        [self registUserInfomation];
        return ;
    } Failure:^(NSError *error) {
        //出错
        return ;
    }];

    return ;
}

-(NSDictionary*)constructUserInfomationParams {
    return @{
             @"imageFileName" : ((eBooksUserRegistTableViewCell*)registTableViewCellArray[0]).userHeaderView.imageFileName,
             @"loginUserName" : ((UITextField*)((eBooksUserRegistTableViewCell*)registTableViewCellArray[1]).contentControl).text,
             @"loginPassword" : ((UITextField*)((eBooksUserRegistTableViewCell*)registTableViewCellArray[2]).contentControl).text,
             @"userRealName" : ((UITextField*)((eBooksUserRegistTableViewCell*)registTableViewCellArray[4]).contentControl).text,
             @"userNickName" : ((UITextField*)((eBooksUserRegistTableViewCell*)registTableViewCellArray[5]).contentControl).text,
             @"userMail" : ((UITextField*)((eBooksUserRegistTableViewCell*)registTableViewCellArray[6]).contentControl).text,
             @"userGender" : ((UISegmentedControl*)((eBooksUserRegistTableViewCell*)registTableViewCellArray[7]).contentControl).selectedSegmentIndex == 0 ? @"男" : @"女",
             @"userAge" : ((UITextField*)((eBooksUserRegistTableViewCell*)registTableViewCellArray[8]).contentControl).text,
             @"userConstellation" : ((UITextField*)((eBooksUserRegistTableViewCell*)registTableViewCellArray[9]).contentControl).text,
             @"userBirthday" : ((UITextField*)((eBooksUserRegistTableViewCell*)registTableViewCellArray[10]).contentControl).text,
             @"userProfession" : ((UITextField*)((eBooksUserRegistTableViewCell*)registTableViewCellArray[11]).contentControl).text,
             @"userCellPhone" : ((UITextField*)((eBooksUserRegistTableViewCell*)registTableViewCellArray[12]).contentControl).text,
             @"userMessage" : ((UITextField*)((eBooksUserRegistTableViewCell*)registTableViewCellArray[13]).contentControl).text,
             @"userDescription" : ((UITextField*)((eBooksUserRegistTableViewCell*)registTableViewCellArray[14]).contentControl).text
             };
}

-(void)registUserInfomation {
    NSString* loginUrl = BASE_URL((NSInteger)SERVICE_USER_REGIST);
    NSDictionary* paramDict = [self constructUserInfomationParams];
    [[eBooksNetworkingHelper getSharedInstance] POST:loginUrl Params:paramDict Success:^(id responseObject) {
        if(responseObject) {
        //注册成功
            if([responseObject[@"Result"] integerValue] == 0) {
                [registHud setLabelText:@"恭喜你，用户注册成功"];
                [registHud hide:YES afterDelay:2.f];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        //注册失败
            else {
                [registHud setLabelText:@"用户注册失败，请联系开发人员"];
                [registHud hide:YES afterDelay:1.f];
            }
        }
        return ;
    } Failure:^(NSError *error) {
        //出错
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:error.localizedDescription delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alertView show];
        return ;
    }];
    return ;
}

-(CGPoint)getFirstResponderCellRect {
    CGRect rect = CGRectZero;
    for (eBooksUserRegistTableViewCell* cell in self.tableView.visibleCells) {
        if([cell.contentControl isFirstResponder]) {
            NSIndexPath* cellIndexPath = [self.tableView indexPathForCell:cell];
            rect = [self.tableView rectForRowAtIndexPath:cellIndexPath];
        }
    }
    
    return [self.tableView convertPoint:rect.origin toView:self.view];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(registTableViewCellArray == nil)
        return 0;
    return registTableViewCellArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (eBooksUserRegistTableViewCell*)registTableViewCellArray[indexPath.row];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0)
        return 150;
    return 50;
}

-(void)dateChanged:(NSDate *)date {
    if(registTableViewCellArray == nil)
        return ;
    eBooksUserRegistTableViewCell* ageCell = (eBooksUserRegistTableViewCell*)registTableViewCellArray[8];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    if(ageCell != nil)
        [((UITextField*)ageCell.contentControl) setText:[NSString stringWithFormat:@"%d",(int)round(timeInterval / (3600 * 8760))]];
    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents* comps = [calendar components:unitFlags fromDate:date];
    NSInteger monthDay = [comps month]*100 + [comps day];
    
    NSString* Constellation = nil;
    if(monthDay >= 321 && monthDay <= 419)
        Constellation = @"白羊座";
    else if(monthDay >= 420 && monthDay <= 520)
        Constellation = @"金牛座";
    else if(monthDay >= 521 && monthDay <= 621)
        Constellation = @"双子座";
    else if(monthDay >= 622 && monthDay <= 722)
        Constellation = @"巨蟹座";
    else if(monthDay >= 723 && monthDay <= 822)
        Constellation = @"狮子座";
    else if(monthDay >= 823 && monthDay <= 922)
        Constellation = @"处女座";
    else if(monthDay >= 923 && monthDay <= 1023)
        Constellation = @"天秤座";
    else if(monthDay >= 1024 && monthDay <= 1122)
        Constellation = @"天蝎座";
    else if(monthDay >= 1123 && monthDay <= 1221)
        Constellation = @"射手座";
    else if(monthDay >= 120 && monthDay <= 218)
        Constellation = @"水瓶座";
    else if(monthDay >= 219 && monthDay <= 320)
        Constellation = @"双鱼座";
    else
        Constellation = @"魔羯座";
    
    eBooksUserRegistTableViewCell* constellationCell = (eBooksUserRegistTableViewCell*)registTableViewCellArray[9];
    
    if(constellationCell != nil)
        [((UITextField*)constellationCell.contentControl) setText:Constellation];
    
    return ;
}

-(void)tap {
    for (eBooksUserRegistTableViewCell* cell in self.tableView.visibleCells) {
        if(cell.contentControl != nil)
            [cell.contentControl resignFirstResponder];
    }
    return ;
}

-(void)keyBoardWillShowNotification:(NSNotification*)notification {
    CGPoint point = [self getFirstResponderCellRect];
    CGRect keyBoardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if(point.y > keyBoardRect.origin.y) {
        CGPoint pt = CGPointMake(self.tableView.center.x, self.tableView.center.y + keyBoardRect.origin.y - point.y - 40);
        [self.tableView setCenter:pt];
    }
    return ;
}

-(void)keyBoardWillHideNotification:(NSNotification*)notification {
    [self.tableView setCenter:tableViewPreviousCenter];
    return ;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
