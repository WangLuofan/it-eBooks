//
//  eBooksDownloadingTask.m
//  it-eBooks
//
//  Created by 王落凡 on 15/11/28.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eBooksDownloadingTask.h"

@implementation eBooksDownloadingTask

-(instancetype)initWithDownloadURL:(NSString *)downloadUrl UserID:(NSInteger)userID BookTitle:(NSString *)bookTitle {
    self = [super init];
    
    if(self) {
        self.downloadUrlString = downloadUrl;
        self.userID = userID;
        self.downloadBookTitle = bookTitle;
    }
    
    return self;
}

-(void)startTask {
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:self.downloadUrlString];
    NSURLSession* session = nil;
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.downloadUrlString]];
    if(self.downloadingData == nil) {
        session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        self.downloadingTask = [session downloadTaskWithRequest:request];
    }
    else {
        session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        self.downloadingTask = [session downloadTaskWithResumeData:self.downloadingData];
        self.downloadingData = nil;
    }
    
    [self.downloadingTask resume];
    
    return ;
}

-(void)pauseTask {
    __weak typeof(self) weakSelf = self;
    [self.downloadingTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        weakSelf.downloadingData = resumeData;
    }];
    return ;
}

-(void)cancelTask {
    [self.downloadingTask cancel];
    return ;
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSFileManager* defaultManager = [NSFileManager defaultManager];
    
    NSString* documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* fileDir = [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld/%@.pdf", (long)self.userID, self.downloadBookTitle]];
    //如果文件存在则移除文件
    if([defaultManager fileExistsAtPath:fileDir])
        [defaultManager removeItemAtPath:fileDir error:nil];
    NSError* error = nil;
    [defaultManager moveItemAtPath:location.path toPath:fileDir error:&error];
    
    //如果成功移动文件，则发送通知告知用户
    __weak typeof(self) weakSelf = self;
    if(!error) {
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:1.0f];
        
        UILocalNotification* notification = [[UILocalNotification alloc] init];
        [notification setFireDate:date];
        [notification setSoundName:UILocalNotificationDefaultSoundName];
        [notification setApplicationIconBadgeNumber:1];
        [notification setAlertTitle:@"下载完成"];
        [notification setAlertBody:[NSString stringWithFormat:@"成功下载文件\n%@.pdf\n赶快点击查看吧!!!",weakSelf.downloadBookTitle]];
        [notification setUserInfo:@{@"filePath" : fileDir}];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    return ;
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"%lld,%lf",bytesWritten,(double)totalBytesWritten / totalBytesExpectedToWrite * 100);
    return ;
}

@end
