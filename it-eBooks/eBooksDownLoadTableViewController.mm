//
//  eBooksDownLoadViewController.m
//  it-eBooks
//
//  Created by 王落凡 on 15/8/27.
//  Copyright (c) 2015年 王落凡. All rights reserved.
//

#import "eBooksDownLoadTableViewController.h"
#import "eBooksDownloadTableViewCell.h"
#import "eBooksUserBookStatusList.hpp"
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
    int downloadingCount = eBooksUserBookStatusList::getInstance()->getItemCountByStatus(eBooksUserBookState::STATE_DOWNLOADING) + eBooksUserBookStatusList::getInstance()->getItemCountByStatus(eBooksUserBookState::STATE_DOWNLOADPAUSE);
    int downloadedCount = eBooksUserBookStatusList::getInstance()->getItemCountByStatus(eBooksUserBookState::STATE_DOWNLOADED);
    
    if((downloadedCount | downloadingCount) && !(downloadingCount & downloadedCount))
        return 1;
    else if(!(downloadedCount & downloadingCount) && !(downloadingCount & downloadedCount))
        return 0;
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return eBooksUserBookStatusList::getInstance()->getItemCountByStatus(eBooksUserBookState::STATE_DOWNLOADING) + eBooksUserBookStatusList::getInstance()->getItemCountByStatus(eBooksUserBookState::STATE_DOWNLOADPAUSE);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    eBooksDownloadTableViewCell* cell = (eBooksDownloadTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"DownloadTableViewCellIdentifier"];
    if (cell == nil)
        cell = [[eBooksDownloadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DownloadTableViewCellIdentifier"];
    
    eBooksUserBookStatus status = eBooksUserBookStatusList::getInstance()->getItemAtIndex((int)indexPath.row);
    [cell.textLabel setText:[NSString stringWithUTF8String:status.getBookTitle().c_str()]];
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    int downloadingCount = eBooksUserBookStatusList::getInstance()->getItemCountByStatus(eBooksUserBookState::STATE_DOWNLOADING) + eBooksUserBookStatusList::getInstance()->getItemCountByStatus(eBooksUserBookState::STATE_DOWNLOADPAUSE);
    if(section == 0 && downloadingCount)
        return @"正在下载";
    return @"下载完成";
}

@end
