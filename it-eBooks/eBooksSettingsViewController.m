//
//  eBooksSettingsViewController.m
//  it-eBooks
//
//  Created by 王落凡 on 15/10/11.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import "eBooksSettingsViewController.h"

@implementation eBooksSettingsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    
    return;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
            
            UISegmentedControl* segmented = [[UISegmentedControl alloc] initWithItems:@[@"左转",@"竖直",@"右转"]];
            [segmented addTarget:self action:@selector(onlineReadOriention:) forControlEvents:UIControlEventValueChanged];
            [segmented setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"onlineReadOriention"]];
            cell.accessoryView = segmented;
        }
    }
    
    return cell;
}

-(void)rememberPassword:(UISwitch*)Switch {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:Switch.isOn forKey:@"isRememberPassword"];
    [userDefaults synchronize];
    
    if(!Switch.on) {
        [userDefaults setObject:nil forKey:@"userName"];
        [userDefaults setObject:nil forKey:@"userPassword"];
    }
    
    return ;
}

-(void)onlineReadOriention:(UISegmentedControl*)Segmented {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:Segmented.selectedSegmentIndex forKey:@"onlineReadOriention"];
    [userDefaults synchronize];
    return ;
}

@end
