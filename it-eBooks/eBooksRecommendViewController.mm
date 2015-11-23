//
//  eBooksRecommendViewController.m
//  it-eBooks
//
//  Created by 王落凡 on 15/10/4.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import "eBooksRecommendViewController.h"
#import "eBooksRecommendTableViewCell.h"
#import "eBooksSingleBookDetailViewController.h"
#import "eBooksNetworkingHelper.h"
#import "eBooksTools.h"

#import <UIImageView+WebCache.h>
#import <SVPullToRefresh.h>

#include "eBooksRecommendList.hpp"

@interface eBooksRecommendViewController () {
    eBooksRecommendList* recommendList;
}

@end

@implementation eBooksRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    recommendList = new eBooksRecommendList();
    [self.view setBackgroundColor:[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f]];
    
    __weak typeof(self) WeakSelf = self;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - self.tabBarController.tabBar.bounds.size.height) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView addPullToRefreshWithActionHandler:^{
        [[eBooksNetworkingHelper getSharedInstance] GET:SERVICE_FETCH_RECOMMEND_LIST Params:nil Success:^(id responseObject) {
            if(responseObject) {
                [WeakSelf.tableView.pullToRefreshView stopAnimating];
                [WeakSelf refreshData:responseObject];
            }
        } Failure:^(NSError *error) {
            [WeakSelf.tableView.pullToRefreshView stopAnimating];
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:error.localizedDescription delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alertView show];
        }];
        return ;
    }];
    [self.tableView.pullToRefreshView setTitle:@"下拉刷新数据" forState:SVPullToRefreshStateStopped];
    [self.tableView.pullToRefreshView setTitle:@"上拉加载数据" forState:SVPullToRefreshStateTriggered];
    [self.tableView.pullToRefreshView setTitle:@"正在加载..." forState:SVPullToRefreshStateLoading];
    
    [self.tableView triggerPullToRefresh];
    return ;
}

-(void)refreshData:(NSArray*)responseObject {
    recommendList->clearAllItems();
    for (NSArray* arrayObj in responseObject) {
        eBooksSingleBookDetailInfo singleBookInfo;
        singleBookInfo.setID([arrayObj[0] intValue]);
        singleBookInfo.setBookTitle([arrayObj[1] UTF8String]);
        singleBookInfo.setBookAuthor([arrayObj[2] UTF8String]);
        singleBookInfo.setBookDescription([arrayObj[3] UTF8String]);
        singleBookInfo.setBookThumbImageUrl([arrayObj[4] UTF8String]);
        
        recommendList->addItem(singleBookInfo);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    return ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return recommendList->getListSize();;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    eBooksRecommendTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"eBooksRecommendTableViewCellIdentifier"];
    if(cell == nil)
        cell = [[eBooksRecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"eBooksRecommendTableViewCellIdentifier"];
    
    eBooksSingleBookDetailInfo itemInfo = recommendList->getItemAtIndex((int)indexPath.row);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNoneImage"] == NO || [eBooksTools getCurrentNetworkType] == NetworkTypeWifi)
        [cell.eBookImageView sd_setImageWithURL:FILE_URL([NSString stringWithUTF8String:itemInfo.getBookThumbImageUrl().c_str()]) placeholderImage:[UIImage imageNamed:@"books"]];
    else
        [cell.eBookImageView setImage:[UIImage imageNamed:@"books"]];
    
    [cell.eBookNameLabel setText:[NSString stringWithFormat:@"%@",[NSString stringWithUTF8String:itemInfo.getBookTitle().c_str()]]];
    [cell.eBookAuthorLabel setText:[NSString stringWithUTF8String:itemInfo.getBookAuthor().c_str()]];
    [cell.eBookDescriptionLabel setText:[NSString stringWithUTF8String:itemInfo.getBookDescription().c_str()]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    eBooksSingleBookDetailViewController* controller = [[eBooksSingleBookDetailViewController alloc] initWithBookID:recommendList->getItemAtIndex((int)indexPath.row).getID()];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
    return ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    delete recommendList;
}

@end
