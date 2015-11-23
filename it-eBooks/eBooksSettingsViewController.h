//
//  eBooksSettingsViewController.h
//  it-eBooks
//
//  Created by 王落凡 on 15/10/11.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eBooksSettingsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong) UITableView* tableView;

@end
