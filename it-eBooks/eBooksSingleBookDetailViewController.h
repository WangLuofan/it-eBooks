//
//  eBooksSingleBookDetailViewController.h
//  it-eBooks
//
//  Created by 王落凡 on 15/10/8.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import <UIKit/UIKit.h>

class eBooksSingleBookDetailInfo;
@interface eBooksSingleBookDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    eBooksSingleBookDetailInfo* bookDetailInfo;
}

@property(nonatomic,assign) NSInteger singleBookID;
@property(nonatomic,strong) UITableView* tableView;

-(instancetype)initWithBookID:(NSInteger)bookID;

@end
