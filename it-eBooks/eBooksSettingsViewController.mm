//
//  eBooksSettingsViewController.m
//  it-eBooks
//
//  Created by 王落凡 on 15/10/11.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import "eBooksSettingsViewController.h"
#import "eBooksFavoriteTableViewController.h"
#import "eBooksDownLoadTableViewController.h"

#include "eBooksUserInfo.hpp"

@implementation eBooksSettingsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    
    return;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return 2;
    if(section == 2)
        return 2;
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"eBooksSettingTableViewCellIdentifier"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eBooksSettingTableViewCellIdentifier"];
    
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            [cell.textLabel setText:@"记住密码"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
            UISwitch* Switch = [[UISwitch alloc] init];
            [Switch addTarget:self action:@selector(rememberPassword:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = Switch;
            Switch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"isRememberPassword"];
        }else if(indexPath.row == 1) {
            [cell.textLabel setText:@"在线预览方向"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UISegmentedControl* segmented = [[UISegmentedControl alloc] initWithItems:@[@"左转",@"竖直",@"右转",@"跟随"]];
            [segmented addTarget:self action:@selector(onlineReadOriention:) forControlEvents:UIControlEventValueChanged];
            [segmented setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"onlineReadOriention"]];
            cell.accessoryView = segmented;
        }
    }else if(indexPath.section == 1) {
        [cell.textLabel setText:@"无图模式"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UISwitch* Switch = [[UISwitch alloc] init];
        [Switch addTarget:self action:@selector(noneImageChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = Switch;
        Switch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"isNoneImage"];
    }else if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            [cell.textLabel setText:@"我的收藏"];
        }else if(indexPath.row == 1) {
            [cell.textLabel setText:@"我的下载"];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 2) {
        if(!eBooksUserInfo::sharedInstance()->isUserLogin()) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"您目前没有登陆,是否现在登陆?" delegate:self  cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
            [alertView show];
        }else {
            UIViewController* viewController = nil;
            if(indexPath.row == 0)
                viewController = [[eBooksFavoriteTableViewController alloc] init];
            else if(indexPath.row == 1)
                viewController = [[eBooksDownLoadTableViewController alloc] init];
        
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    
    return ;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"基本设置";
    else if(section == 1)
        return @"其他设置";
    else if(section == 2)
        return @"我的";
    return @"";
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if(section == 1)
        return @"在2G/3G/4G模式下，将不显示任何图片,只有在WIFI情况下才会显示";
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 1)
        return 50.0f;
    return 0.1f;
}

-(void)noneImageChanged:(UISwitch*)Switch {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:Switch.isOn forKey:@"isNoneImage"];
    [userDefaults synchronize];
    
    return ;
}

-(void)rememberPassword:(UISwitch*)Switch {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:Switch.isOn forKey:@"isRememberPassword"];
    [userDefaults synchronize];
    
    if(!Switch.on) {
        [userDefaults setObject:@"" forKey:@"userName"];
        [userDefaults setObject:@"" forKey:@"userPassword"];
    }
    
    return ;
}

-(void)onlineReadOriention:(UISegmentedControl*)Segmented {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:Segmented.selectedSegmentIndex forKey:@"onlineReadOriention"];
    [userDefaults synchronize];
    return ;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [self.tabBarController.tabBar setHidden:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:EBOOKS_NOTIFICATION_NEED_LOGIN object:nil userInfo:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    return ;
}

@end
