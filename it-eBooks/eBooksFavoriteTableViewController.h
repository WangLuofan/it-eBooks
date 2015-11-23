//
//  eBooksFavoriteTableViewController.h
//  it-eBooks
//
//  Created by 王落凡 on 15/8/27.
//  Copyright (c) 2015年 王落凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eBooksFavoriteTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView* tableView;

@end
