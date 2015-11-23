//
//  eBooksDownLoadViewController.m
//  it-eBooks
//
//  Created by 王落凡 on 15/8/27.
//  Copyright (c) 2015年 王落凡. All rights reserved.
//

#import "eBooksDownLoadTableViewController.h"
#import "eBooksAppDelegate.h"

@interface eBooksDownLoadTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation eBooksDownLoadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"我的下载"];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadTableViewCellIdentifier"];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DownloadTableViewCellIdentifier"];
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"正在下载";
    return @"下载完成";
}

@end
