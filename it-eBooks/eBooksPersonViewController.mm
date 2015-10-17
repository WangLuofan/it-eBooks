//
//  eBooksPersonViewController.m
//  it-eBooks
//
//  Created by 王落凡 on 15/10/4.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import "eBooksPersonViewController.h"
#import "eBooksUserHeaderView.h"
#import "eBooksUserInfo.hpp"
#import "eBooksSettingsViewController.h"

#import <MBProgressHUD.h>

@interface eBooksPersonViewController () {
    UIColor* navPreviousColor;
}

@end

@implementation eBooksPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    navPreviousColor = self.navigationController.navigationBar.backgroundColor;
    
    self.headInfoView = [[eBooksUserHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height / 3)];
    [self.view addSubview:self.headInfoView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headInfoView.frame.origin.y + self.headInfoView.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.headInfoView.frame.origin.y - self.headInfoView.frame.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStyleGrouped];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setHidden:!eBooksUserInfo::sharedInstance()->isUserLogin()];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(settingButtonPressed:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:EBOOKS_NOTIFICATION_LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginInvalid:) name:EBOOKS_NOTIFICATION_USERNAME_OR_PASSWORD_INVALID object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailure:) name:EBOOKS_NOTIFICATION_LOGIN_FAILURE object:nil];
    
    return ;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"nav_bg"]];
    [super viewWillAppear:animated];
    return ;
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setBackgroundColor:navPreviousColor];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)settingButtonPressed:(UIBarButtonItem*)sender {
    eBooksSettingsViewController* settings = [[eBooksSettingsViewController alloc] init];
    [settings setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:settings animated:YES];
    return ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"eBooksPersonTableViewCellIdentifier"];
    if(cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eBooksPersonTableViewCellIdentifier"];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSString* cellText = nil;
    switch (indexPath.section) {
        case 0:
            cellText = [NSString stringWithFormat:@"%@(%@)",[NSString stringWithUTF8String:eBooksUserInfo::sharedInstance()->getUserName().c_str()],eBooksUserInfo::sharedInstance()->getUserGender()?@"男":@"女"];
            break;
        case 1:
            cellText = [NSString stringWithFormat:@"%@(%d-%@)",[NSString stringWithUTF8String:eBooksUserInfo::sharedInstance()->getUserBirthday().c_str()],eBooksUserInfo::sharedInstance()->getUserAge(),[NSString stringWithUTF8String:eBooksUserInfo::sharedInstance()->getConstellation().c_str()]];
            break;
        case 2:
            cellText = [NSString stringWithUTF8String:eBooksUserInfo::sharedInstance()->getUserMail().c_str()];
            break;
        case 3:
            cellText = [NSString stringWithUTF8String:eBooksUserInfo::sharedInstance()->getUserPhone().c_str()];
            break;
        case 4:
            cellText = [NSString stringWithUTF8String:eBooksUserInfo::sharedInstance()->getProfesstion().c_str()];
            break;
        case 5:
            cellText = [NSString stringWithUTF8String:eBooksUserInfo::sharedInstance()->getUserDescription().c_str()];
            break;
        default:
            break;
    }
    
    [cell.textLabel setText:cellText];
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"姓名";
        case 1:
            return @"生日";
        case 2:
            return @"邮箱";
        case 3:
            return @"联系方式";
        case 4:
            return @"职业";
        case 5:
            return @"个人描述";
        default:
            break;
    }
    
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 5) {
        NSString* desc = [NSString stringWithUTF8String:eBooksUserInfo::sharedInstance()->getUserDescription().c_str()];
        CGFloat descHeight = [desc boundingRectWithSize:CGSizeMake(tableView.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size.height;
        return descHeight > 30 ? : 30;
    }
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

-(void)loginSuccess:(NSNotification*)notification {
    //头像待加入
    [self.headInfoView setUserInfo:@{
                                     @"userName":[NSString stringWithUTF8String:eBooksUserInfo::sharedInstance()->getNickName().c_str()],
                                     @"userMessage":[NSString stringWithUTF8String:eBooksUserInfo::sharedInstance()->getUserMessage().c_str()]
                                     }];
    [self.tableView reloadData];
    [self.tableView setHidden:NO];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    return ;
}

-(void)loginFailure:(NSNotification*)notification {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.tableView setHidden:YES];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"用户登陆失败\n请与开发人员联系" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [alertView show];
    return ;
}

-(void)loginInvalid:(NSNotification*)notification {
    [self.tableView setHidden:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"用户登陆失败\n用户名或密码错误,请重新输入" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [alertView show];
    
    return ;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
