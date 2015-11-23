//
//  eBooksSearchViewController.m
//  it-eBooks
//
//  Created by 王落凡 on 15/8/24.
//  Copyright (c) 2015年 王落凡. All rights reserved.
//

#import "eBooksSearchViewController.h"
#import "eBooksSearchKeywordLabelView.h"
#import "eBooksSearchTableViewCell.h"
#import "eBooksNetworkingHelper.h"
#import "eBooksTools.h"
#import "eBooksSingleBookDetailViewController.h"

#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>

#include "eBooksSearchResultList.hpp"

@interface eBooksSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,eBooksSearchKeywordLabelViewDelegate> {
    UISearchBar* _searchBar;
    eBooksSearchKeywordLabelView* keywordLabelView;
    BOOL hasMoreData;
}

@end

@implementation eBooksSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"书籍搜索"];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, NAV_STATUS_OFFSET, self.view.bounds.size.width, 44)];
    [_searchBar setPlaceholder:NSLocalizedString(@"Search", @"")];
    [_searchBar setShowsCancelButton:YES animated:YES];
    [_searchBar setSearchBarStyle:UISearchBarStyleProminent];
    [_searchBar setDelegate:self];
    [self.view addSubview:_searchBar];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.frame.origin.y + _searchBar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - _searchBar.frame.origin.y - _searchBar.frame.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setHidden:YES];
    
    searchResultList = new eBooksSearchResultList();
    [self requestSearchKeywordsTable];
    
    hasMoreData = YES;
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(requestSearchKeywordsTable)];
}

-(void)requestSearchKeywordsTable {
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    __block MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud removeFromSuperViewOnHide];
    [self.view addSubview:hud];
    [hud show:YES];
    
    if(keywordLabelView == nil) {
        keywordLabelView = [[eBooksSearchKeywordLabelView alloc] initWithFrame:self.tableView.frame];
        [keywordLabelView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
        [keywordLabelView setDelegate:self];
        [self.view addSubview:keywordLabelView];
    }
    
    [[eBooksNetworkingHelper getSharedInstance] GET:SERVICE_FETCH_SEARCH_KEYWORDS Params:nil Success:^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            [keywordLabelView clearALLKeywordLabels];
            for (NSString* str in responseObject)
                [keywordLabelView generateLabelWithKeyword:str];
        });
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud setMode:MBProgressHUDModeText];
            [hud setLabelText:@"无法获取到搜索关键词"];
            [hud removeFromSuperViewOnHide];
            [hud showAnimated:YES whileExecutingBlock:^{
                [NSThread sleepForTimeInterval:1.0f];
                return ;
            } completionBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationItem.rightBarButtonItem setEnabled:YES];
                });
            }];
        });
    }];
    return ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can berecreated.
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setText:@""];
    [self clearSearchResults];
    
    return ;
}

-(void)loadMoreData {
//    if(hasMoreData) {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [[eBooksNetworking sharedInstance] getJsonWithUrlString:[NSString stringWithFormat:@"/search/%@/page/%lu",[_searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],(eBooksDetailInfoModelVector.size()/10 + 1)] isRelative:YES notificationName:SEARCH_BOOK_BY_KEYWORD_NOTIFICATION];
//    }
    
    return ;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self Search];
    return ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return searchResultList->getItemCount();
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    eBooksSearchTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SearchRecommendTableViewCellIdentifier"];
    if(cell == nil)
        cell = [[eBooksSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SearchRecommendTableViewCellIdentifier"];
    [cell.textLabel setText:[NSString stringWithUTF8String:searchResultList->itemAtIndex((int)indexPath.row)->getName().c_str()]];
    [cell.detailTextLabel setText:[NSString stringWithUTF8String:searchResultList->itemAtIndex((int)indexPath.row)->getDescription().c_str()]];
    NSString* urlString = FILE_URL_STRING([NSString stringWithUTF8String:searchResultList->itemAtIndex((int)indexPath.row)->getThumbImageUrl().c_str()]);
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNoneImage"] == NO || [eBooksTools getCurrentNetworkType] == NetworkTypeWifi)
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"books"]];
    else
        [cell.imageView setImage:[UIImage imageNamed:@"books"]];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchBar.text.length == 0) {
        [self clearSearchResults];
    }
    
    return ;
}

-(void)Search {
    searchResultList->clearALLItems();
    
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud removeFromSuperViewOnHide];
    [hud setLabelText:@"搜索中..."];
    [self.view addSubview:hud];
    [hud show:YES];

    [[eBooksNetworkingHelper getSharedInstance] GET:SERVICE_SEARCH_BOOKS Params:@{@"searchText":_searchBar.text,@"searchBy":@SEARCH_BY_BOOK_NAME} Success:^(id responseObject) {
        for (NSDictionary* itemDict in responseObject)
            searchResultList->addNewItem((int)[itemDict[@"bookID"] integerValue], [itemDict[@"bookName"] UTF8String], [itemDict[@"bookThumbImageUrl"] UTF8String],[itemDict[@"bookDescription"] UTF8String]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [keywordLabelView setHidden:YES];
                [self.tableView setHidden:NO];
                [self.tableView reloadData];
                [hud hide:YES];
            });
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud setMode:MBProgressHUDModeText];
            [hud setLabelText:@"未搜索到相关书籍"];
            [self clearSearchResults];
            [hud hide:YES afterDelay:1.0f];
        });
    }];
    return ;
}

-(void)clearSearchResults {
    
    [self.tableView setHidden:YES];
    [keywordLabelView setHidden:NO];
    searchResultList->clearALLItems();
    [self.tableView reloadData];
    
    return ;
}

-(void)keywordLabelSelected:(NSString *)keyword {
    [_searchBar setText:keyword];
    [self Search];
    return ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    eBooksSingleBookDetailViewController* singleBookDetailCtl = [[eBooksSingleBookDetailViewController alloc] init];
    [singleBookDetailCtl setHidesBottomBarWhenPushed:YES];
    [singleBookDetailCtl setSingleBookID:searchResultList->itemAtIndex((int)indexPath.row)->getID()];
    [self.navigationController pushViewController:singleBookDetailCtl animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    return ;
}

-(void)tap {
    [_searchBar resignFirstResponder];
    return ;
}

- (void)dealloc
{
    delete searchResultList;
}

@end
