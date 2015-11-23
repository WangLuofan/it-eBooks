//
//  eBooksCategoryChooseTableViewController.h
//  it-eBooks
//
//  Created by 王落凡 on 15/10/5.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import <UIKit/UIKit.h>

class eBooksCategoryList;
@interface eBooksCategoryChooseTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    eBooksCategoryList* m_booksCategoryList;
    int* selectedItems;
}

@property(nonatomic,strong) UITableView* tableView;

@end
