//
//  eBooksDownloadingTask.h
//  it-eBooks
//
//  Created by 王落凡 on 15/11/28.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eBooksDownloadingTask : NSObject <NSURLSessionDownloadDelegate>

-(instancetype)initWithDownloadURL:(NSString *)downloadUrl UserID:(NSInteger)userID BookTitle:(NSString*)bookTitle;

@property(nonatomic,copy) NSString* downloadUrlString;
@property(nonatomic,assign) NSInteger userID;
@property(nonatomic,copy) NSString* downloadBookTitle;
@property(nonatomic,strong) NSURLSessionDownloadTask* downloadingTask;
@property(nonatomic,strong) NSData* downloadingData;

//开始下载
-(void)startTask;

//暂停下载
-(void)pauseTask;

//结束下载
-(void)cancelTask;

@end
