//
//  eBooksSearchViewController.h
//  it-eBooks
//
//  Created by 王落凡 on 15/8/24.
//  Copyright (c) 2015年 王落凡. All rights reserved.
//

#import <UIKit/UIKit.h>

class eBooksSearchResultList;
@interface eBooksSearchViewController : UIViewController {
    eBooksSearchResultList* searchResultList;
}

@property(nonatomic,strong) UITableView* tableView;

@end
