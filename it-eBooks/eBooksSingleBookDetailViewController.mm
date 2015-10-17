//
//  eBooksSingleBookDetailViewController.m
//  it-eBooks
//
//  Created by 王落凡 on 15/10/8.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import "eBooksSingleBookDetailViewController.h"
#import "eBooksSingleBookDetailTableHeaderViewCell.h"
#import "eBooksNetworkingHelper.h"
#import "eBooksPreviewController.h"
#include "eBooksSingleBookDetailInfo.hpp"

#import <MBProgressHUD.h>

@interface eBooksSingleBookDetailViewController () <eBooksSingleBookDetailTableHeaderViewCellDelegate>{
    NSArray* dataSourceArray;
}

@end

@implementation eBooksSingleBookDetailViewController

-(instancetype)initWithBookID:(NSInteger)bookID {
    self = [super init];
    
    if(self) {
        self.singleBookID = bookID;
    }
    
    return self;
}

-(void)viewDidLoad {
    self.title = @"书籍详情";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    
    [self requestBookDetailInfo];
    return ;
}

-(void)requestBookDetailInfo {
    [[eBooksNetworkingHelper getSharedInstance] GET:SERVICE_FETCH_BOOK_DETAIL_INFO Params:@{@"bookID":[NSNumber numberWithInteger:self.singleBookID]} Success:^(id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CPP_SAFEDELETE(bookDetailInfo);
                bookDetailInfo = new eBooksSingleBookDetailInfo();
                bookDetailInfo->setBookTitle([responseObject[@"bookName"] UTF8String]);
                bookDetailInfo->setBookAuthor([responseObject[@"bookAuthor"] UTF8String]);
                bookDetailInfo->setBookDescription([responseObject[@"bookDescription"] UTF8String]);
                bookDetailInfo->setBookDownloadUrl([responseObject[@"bookDownloadUrl"] UTF8String]);
                bookDetailInfo->setBookThumbImageUrl([responseObject[@"bookThumbImageUrl"] UTF8String]);
                bookDetailInfo->setBookPages((int)[responseObject[@"bookPages"] integerValue]);
                bookDetailInfo->setBookFileSize((unsigned long)[responseObject[@"bookFileSize"] integerValue]);
                bookDetailInfo->setBookPublisher((responseObject[@"bookPublisher"] == [NSNull null]) ? "" : [responseObject[@"bookPublisher"] UTF8String]);
                bookDetailInfo->setBookPublishDate((responseObject[@"bookPublishDate"] == [NSNull null]) ? "" : [responseObject[@"bookPublishDate"] UTF8String]);
                bookDetailInfo->setBookCategoryName([responseObject[@"bookCategoryName"] UTF8String]);
                
                [self.tableView reloadData];
            });
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.view];
            [hud setMode:MBProgressHUDModeText];
            [hud setLabelText:@"无法查询到书籍的相关信息"];
            [hud removeFromSuperViewOnHide];
            [hud showAnimated:YES whileExecutingBlock:^{
                [NSThread sleepForTimeInterval:1.0f];
                return ;
            } completionBlock:^{
                [hud hide:YES];
            }];
        });
    }];
    return ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(bookDetailInfo == nullptr)
        return 0;
    return 9;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(bookDetailInfo == nullptr)
        return 0;
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0)
        return 150.0f;
    else if(indexPath.section == 2) {
        NSString* desc = [NSString stringWithFormat:@"    %@",[NSString stringWithUTF8String:bookDetailInfo->getBookDescription().c_str()]];
        CGFloat descHeight = [desc boundingRectWithSize:CGSizeMake(IOS_SCREEN_WIDTH - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:[UIColor redColor]} context:nil].size.height;
        return (descHeight + 10.0f) < 50.0f ? 50.f : (descHeight + 10.0f);
    }
    
    return 50.0f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        eBooksSingleBookDetailTableHeaderViewCell* cell = (eBooksSingleBookDetailTableHeaderViewCell*)[tableView dequeueReusableCellWithIdentifier:@"eBooksSingleBookDetailTableHeaderViewCellIdentifier"];
        if(cell == nil) {
            cell = [[eBooksSingleBookDetailTableHeaderViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eBooksSingleBookDetailTableHeaderViewCellIdentifier"];
            [cell setDelegate:self];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }

        [cell setCellInfoWithTitle:[NSString stringWithUTF8String:bookDetailInfo->getBookTitle().c_str()] imageUrl:[NSString stringWithUTF8String:bookDetailInfo->getBookThumbImageUrl().c_str()]];
        return cell;
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"eBooksSingleBookDetailTableViewCellIdentifier"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eBooksSingleBookDetailTableViewCellIdentifier"];
        [cell.textLabel setNumberOfLines:0];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [cell.textLabel setTextColor:[UIColor redColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    NSString* cellText = nil;
    switch (indexPath.section) {
        case 1:
            cellText = [NSString stringWithFormat:@"    %@",[NSString stringWithUTF8String:bookDetailInfo->getBookAuthor().c_str()]];
            break;
        case 2:
            cellText = [NSString stringWithFormat:@"    %@",[NSString stringWithUTF8String:bookDetailInfo->getBookDescription().c_str()]];
            break;
        case 3:
            cellText = [NSString stringWithFormat:@"   %u",bookDetailInfo->getBookPages()];
            break;
        case 4:
            cellText = [NSString stringWithFormat:@"    %ld (KB)",bookDetailInfo->getBookFileSize()];
            break;
        case 5:
            cellText = [NSString stringWithFormat:@"    %@",[NSString stringWithUTF8String:bookDetailInfo->getBookCategoryName().c_str()]];
            break;
        case 6:
            cellText = [NSString stringWithFormat:@"    %@",(bookDetailInfo->getBookPublisher().length() == 0 ? @"未知" : [NSString stringWithUTF8String:bookDetailInfo->getBookPublisher().c_str()])];
            break;
        case 7: {
                    cellText = [NSString stringWithFormat:@"    %@",(bookDetailInfo->getBookPublishDate().length() == 0 ? @"未知" : [NSString stringWithUTF8String:bookDetailInfo->getBookPublishDate().c_str()])];
                    if(cellText.length == 8)
                        cellText = [cellText stringByAppendingString:@" 年"];
                }
            break;
        default:
            break;
    }
    
    [cell.textLabel setText:cellText];
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* headerStr = @"";
    switch (section) {
        case 0:
            headerStr = @"基本信息";
            break;
        case 1:
            headerStr = @"书籍作者";
            break;
        case 2:
            headerStr = @"书籍描述";
            break;
        case 3:
            headerStr = @"书籍页数";
            break;
        case 4:
            headerStr = @"书籍大小";
            break;
        case 5:
            headerStr = @"所属分类";
            break;
        case 6:
            headerStr = @"出版社";
            break;
        case 7:
            headerStr = @"出版日期";
            break;
        default:
            break;
    }
    
    return headerStr;
}

-(void)singleBookDetailTableViewCellButtonPressed:(UIButton *)button {
    //
    if(button.tag == 0) {
        
    }else if(button.tag == 1) {
        
    }else {
        eBooksPreviewController* preViewController = [[eBooksPreviewController alloc] initWithFileUrl:FILE_URL([NSString stringWithUTF8String:bookDetailInfo->getBookDownloadUrl().c_str()])];
        [preViewController setTitle:[NSString stringWithUTF8String:bookDetailInfo->getBookTitle().c_str()]];
        preViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:preViewController animated:YES];
    }
    
    return ;
}

-(void)dealloc {
    CPP_SAFEDELETE(bookDetailInfo);
}

@end
