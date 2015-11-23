//
//  eBooksRecommendTableViewCell.m
//  it-eBooks
//
//  Created by 王落凡 on 15/11/14.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import "eBooksRecommendTableViewCell.h"

@implementation eBooksRecommendTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.eBookCellContentView = [[UIView alloc] init];
        [self.eBookCellContentView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.eBookCellContentView];
        
        self.eBookImageView = [[UIImageView alloc] init];
        [self.eBookImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        self.eBookNameLabel = [[UILabel alloc] init];
        [self.eBookNameLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [self.eBookNameLabel setTextColor:[UIColor redColor]];
        
        self.eBookAuthorLabel = [[UILabel alloc] init];
        [self.eBookAuthorLabel setTextColor:[UIColor redColor]];
        
        self.eBookDescriptionLabel = [[UILabel alloc] init];
        [self.eBookDescriptionLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [self.eBookDescriptionLabel setNumberOfLines:0];
        [self.eBookDescriptionLabel setTextColor:[UIColor lightGrayColor]];
        
        [self.eBookCellContentView addSubview:self.eBookImageView];
        [self.eBookCellContentView addSubview:self.eBookNameLabel];
        [self.eBookCellContentView addSubview:self.eBookAuthorLabel];
        [self.eBookCellContentView addSubview:self.eBookDescriptionLabel];
    }
    
    return self;
}

-(void)layoutSubviews {
    [self.eBookCellContentView setFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height - 5)];
    [self.eBookImageView setFrame:CGRectMake(5, 5, self.eBookCellContentView.bounds.size.height - 10, self.eBookCellContentView.bounds.size.height - 10)];
    [self.eBookNameLabel setFrame:CGRectMake(self.eBookImageView.frame.origin.x + self.eBookImageView.frame.size.width + 5, self.eBookImageView.frame.origin.y, self.eBookCellContentView.bounds.size.width - self.eBookImageView.frame.origin.x - self.eBookImageView.frame.size.width - 10, 20)];
    [self.eBookAuthorLabel setFrame:CGRectMake(self.eBookNameLabel.frame.origin.x, self.eBookNameLabel.frame.origin.y + self.eBookNameLabel.frame.size.height, self.eBookNameLabel.frame.size.width, self.eBookNameLabel.frame.size.height)];
    [self.eBookDescriptionLabel setFrame:CGRectMake(self.eBookAuthorLabel.frame.origin.x, self.eBookAuthorLabel.frame.origin.y + self.eBookAuthorLabel.frame.size.height, self.eBookAuthorLabel.frame.size.width, self.eBookAuthorLabel.frame.size.height * 2)];
    return [super layoutSubviews];
}

@end
