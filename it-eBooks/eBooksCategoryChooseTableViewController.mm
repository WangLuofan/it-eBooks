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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选定" style:UIBarButtonItemStylePlain target:self action:@selector(selected)];
    
    [self requestCategoryList];
}

-(void)requestCategoryList {
    if(m_booksCategoryList == nullptr)
        m_booksCategoryList = new eBooksCategoryList();
    [[eBooksNetworkingHelper getSharedInstance] GET:SERVICE_FETCH_BOOK_CATEGORY Params:nil Success:^(id responseObject) {
        for (NSString* str in (NSArray*)responseObject) {
            m_booksCategoryList->addNewItem([str UTF8String]);
        }
        selectedItems = new int[m_booksCategoryList->getItemCount()];
        memset(selectedItems, 0, sizeof(int)*m_booksCategoryList->getItemCount());
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } Failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    return ;
}

-(void)selected {
    NSMutableArray* selectArray = [NSMutableArray array];
    for(int i = 0; i != m_booksCategoryList->getItemCount(); ++i) {
        if(selectedItems[i] == 1)
            [selectArray addObject:[NSString stringWithUTF8String:m_booksCategoryList->itemAtIndex(i).c_str()]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EBOOKS_NOTIFICATION_CATEGORY_CHOISE_COMPLETE object:nil userInfo:@{@"selectedArray":selectArray}];
    
    [self.navigationController popViewControllerAnimated:YES];
    return ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return m_booksCategoryList->getItemCount();
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"eBooksCategoryChooseTableViewCellIdentifier"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eBooksCategoryChooseTableViewCellIdentifier"];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    if(selectedItems[indexPath.row] == 1)
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    else
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell.textLabel setText:[NSString stringWithFormat:@"%ld、%@",(long)indexPath.row + 1,[NSString stringWithUTF8String:m_booksCategoryList->itemAtIndex((int)indexPath.row).c_str()]]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        selectedItems[indexPath.row] = 0;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        selectedItems[indexPath.row] = 1;
    }
    
    return ;
}

- (void)dealloc
{
    CPP_SAFEDELETE(m_booksCategoryList);
    CPP_SAFEDELETE(selectedItems);
}

@end
