//
//  eBooksCategoryChooseTableViewController.m
//  it-eBooks
//
//  Created by 王落凡 on 15/10/5.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import "eBooksCategoryChooseTableViewController.h"
#import "eBooksNetworkingHelper.h"

#include "eBooksCategoryList.hpp"

@implementation eBooksCategoryChooseTableViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"分类列表"];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    
    [self requestCategoryList];
}

-(void)requestCategoryList {
    if(m_booksCategoryList == nullptr)
        m_booksCategoryList = new eBooksCategoryList();
//    [[eBooksNetworkingHelper getSharedInstance] sendAsyncRequestWithUrlString:@"" Method:@"GET" completionBlock:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable error) {
//        if(error == nil) {
//            NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            for (NSString* str in jsonArray) {
//                m_booksCategoryList->addNewItem([str UTF8String]);
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
//        }
//    }];
//    [[eBooksNetworkingHelper getSharedInstance] GET_RequestWithServiceType:SERVICE_FETCH_RECOMMEND_LIST params:nil completion:^(NSURLResponse * response, NSData * data, NSError * error) {
//        if(error == nil) {
//            NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            for (NSString* str in jsonArray) {
//                m_booksCategoryList->addNewItem([str UTF8String]);
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
//        }
//    }];
    
    return ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return m_booksCategoryList->getItemCount();
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"eBooksCategoryChooseTableViewCellIdentifier"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eBooksCategoryChooseTableViewCellIdentifier"];
    [cell.textLabel setText:[NSString stringWithFormat:@"%ld、%@",(long)indexPath.row + 1,[NSString stringWithUTF8String:m_booksCategoryList->itemAtIndex((int)indexPath.row).c_str()]]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    CPP_SAFEDELETE(m_booksCategoryList);
}

@end
