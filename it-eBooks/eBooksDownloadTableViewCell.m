//
//  eBooksDownloadTableViewCell.m
//  it-eBooks
//
//  Created by 王落凡 on 15/11/28.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import "eBooksDownloadTableViewCell.h"

@implementation eBooksDownloadTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        self.downloadingProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [self.downloadingProgressView setProgress:0.0f];
        [self.downloadingProgressView setTintColor:[UIColor redColor]];
        
        [self.topTableViewCellContentView addSubview:self.downloadingProgressView];
        [self setTableViewCellEditButtonWithItemsTitle:@"详情", @"暂停", @"停止", nil];
    }
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.downloadingProgressView setFrame:CGRectMake(0, self.topTableViewCellContentView.bounds.size.height - 2, self.topTableViewCellContentView.bounds.size.width, 3)];
    
    return ;
}

@end
