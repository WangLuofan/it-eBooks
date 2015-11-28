//
//  eBooksFavoriteTableViewController.m
//  it-eBooks
//
//  Created by 王落凡 on 15/8/27.
//  Copyright (c) 2015年 王落凡. All rights reserved.
//

#import "eBooksFavoriteTableViewController.h"
#import "eBooksFavoriteTableViewCell.h"
#import "eBooksSingleBookDetailViewController.h"
#import "eBooksNetworkingHelper.h"

#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>

#include "eBooksUserBookStatusList.hpp"
#include "eBooksUserInfo.hpp"

@interface eBooksFavoriteTableViewController () <eBooksFavoriteTableViewCellDelegate>

@end

@implementation eBooksFavoriteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"我的收藏"];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    return ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return eBooksUserBookStatusList::getInstance()->getItemCountByStatus(eBooksUserBookState::STATE_FAVORITED);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    eBooksFavoriteTableViewCell* cell = (eBooksFavoriteTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"eBooksMineTableViewCellIdentifier"];
    if(cell == nil) {
        cell = [[eBooksFavoriteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eBooksFavoriteTableViewCellIdentifier"];
        [cell setDelegate:self];
    }
    
    [cell.bookNameLabel setText:[NSString stringWithUTF8String:eBooksUserBookStatusList::getInstance()->getItemAtIndex((int)indexPath.row).getBookTitle().c_str()]];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void)editButtonPressed:(UIBarButtonItem*)sender {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    [self.tableView setEditing:YES animated:YES];
    return ;
}

-(void)doneButtonPressed:(UIBarButtonItem*)sender {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed:)];
    [self.tableView setEditing:NO animated:YES];
    return ;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self deleteRowAtIndexPath:indexPath];
    return ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

-(void)deleteRowAtIndexPath:(NSIndexPath*)indexPath {
    __block eBooksUserBookStatus status = eBooksUserBookStatusList::getInstance()->getItemAtIndex((int)indexPath.row);
    __weak typeof(self) weakSelf = self;
    [[eBooksNetworkingHelper getSharedInstance] GET:SERVICE_FAVORITE_BOOK Params:@{
        @"flag" : [NSNumber numberWithInt:0],
        @"userID" : [NSNumber numberWithInt:eBooksUserInfo::sharedInstance()->getUserID()],
        @"bookID" : [NSNumber numberWithInt:status.getBookID()],
    } Success:^(id responseObject) {
        if([responseObject[@"Result"] intValue] == 0) {
            eBooksUserBookStatusList::getInstance()->removeItem(status.getBookID());
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else {
            MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.view];
            [hud setRemoveFromSuperViewOnHide:YES];
            [hud setMode:MBProgressHUDModeText];
            [hud setLabelText:@"操作失败,请与开发人员联系。"];
            [self.view addSubview:hud];
            [hud show:YES];
            [hud hide:YES afterDelay:1.f];
        }
    } Failure:^(NSError *error) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:error.localizedDescription delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alertView show];
    }];
    
    return ;
}

-(void)tableViewCell:(eBooksFavoriteTableViewCell*)cell buttonIndex:(NSInteger)buttonIndex {
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    if(buttonIndex == 0) {
        [self deleteRowAtIndexPath:indexPath];
    }else if(buttonIndex == 1) {
    }else {
        eBooksUserBookStatus status = eBooksUserBookStatusList::getInstance()->getItemAtIndex((int)indexPath.row);
        eBooksSingleBookDetailViewController* viewController = [[eBooksSingleBookDetailViewController alloc] initWithBookID:status.getBookID()];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    return ;
}

@end
