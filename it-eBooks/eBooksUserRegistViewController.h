//
//  eBooksUserRegistViewController.h
//  it-eBooks
//
//  Created by 王落凡 on 15/10/27.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,UserRegistResult) {
    UserRegistResultSuccess,
    UserRegistResultUserNameExists,
    UserRegistResultInfoImperfect,
    UserRegistResultNetworkProblem,
    UserRegistResultPasswordConfirmError,
    UserRegistResultUnknown
};

@interface eBooksUserRegistViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray* registTableViewCellArray;
}

@property(nonatomic,strong) UITableView* tableView;

@end
