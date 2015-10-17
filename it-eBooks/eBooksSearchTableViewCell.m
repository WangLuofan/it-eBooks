//
//  eBooksSearchTableViewCell.m
//  it-eBooks
//
//  Created by 王落凡 on 15/10/7.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import "eBooksSearchTableViewCell.h"

#define kControlMargin 5
#define kLabelCommonHeight 20

@implementation eBooksSearchTableViewCell

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageView setFrame:CGRectMake(kControlMargin, kControlMargin, self.contentView.frame.size.height - 2*kControlMargin, self.contentView.frame.size.height - 2*kControlMargin)];
    
    [self.textLabel setFrame:CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + kControlMargin, self.imageView.frame.origin.y, self.contentView.frame.size.width - self.imageView.frame.origin.y - self.imageView.frame.size.width - 2*kControlMargin, kLabelCommonHeight)];
    [self.detailTextLabel setFrame:CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.size.height + self.textLabel.frame.origin.y + kControlMargin, self.textLabel.frame.size.width, self.contentView.frame.size.height - self.textLabel.frame.origin.y - self.textLabel.frame.size.height - 2*kControlMargin)];
    [self.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    
    [self setSeparatorInset:UIEdgeInsetsMake(0, self.imageView.frame.size.width, 0, 0)];
    
    return ;
}

@end
