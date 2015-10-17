//
//  eBooksPersonViewController.h
//  it-eBooks
//
//  Created by 王落凡 on 15/10/4.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eBooksUserHeaderView;
@interface eBooksPersonViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) eBooksUserHeaderView* headInfoView;
@property(nonatomic,strong) UITableView* tableView;

@end
