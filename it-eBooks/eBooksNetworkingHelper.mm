//
//  eBooksNetworkingHelper.m
//  it-eBooks
//
//  Created by 王落凡 on 15/10/4.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import "eBooksNetworkingHelper.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>

#include "eBooksUserInfo.hpp"
#include "eBooksSingleBookDetailInfo.hpp"

static eBooksNetworkingHelper* networkingHelper;
@implementation eBooksNetworkingHelper

-(instancetype)init {
    self = [super init];
    if(self) {
        operationArray = [[NSMutableArray alloc] init];
    }
    return self;
}

+(eBooksNetworkingHelper *)getSharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(networkingHelper == nil) {
            networkingHelper = [[eBooksNetworkingHelper alloc] init];
        }
    });
    
    return networkingHelper;
}

-(void)GET:(NSInteger)serviceType Params:(NSDictionary *)params Success:(ResponseSuccessBlock)success Failure:(ResponseFailureBlock)failure {
    [[AFHTTPRequestOperationManager manager] GET:BASE_URL(serviceType) parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if(success)
            success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if(failure)
            failure(error);
    }];
    return ;
}

-(void)POST:(NSString *)urlString Params:(NSDictionary *)params Success:(ResponseSuccessBlock)success Failure:(ResponseFailureBlock)failure {
    [[AFHTTPRequestOperationManager manager] POST:urlString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        return ;
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error);
        return ;
    }];
}

-(void)UPLOADImageWithParams:(NSDictionary *)params Success:(ResponseSuccessBlock)success Failure:(ResponseFailureBlock)failure {
    NSString* urlString = [NSString stringWithFormat:@"%@&_userID=%d",BASE_URL(SERVICE_UPLOAD_USER_IMAGE),eBooksUserInfo::sharedInstance()->getUserID()];
    [[AFHTTPRequestOperationManager manager] POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation((UIImage*)params[@"image"], 0.5f) name:@"headerImage" fileName:params[@"name"] mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        eBooksUserInfo::sharedInstance()->setUserHeaderImage([responseObject[@"ImageUrl"] UTF8String]);
        success(nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(nil);
    }];
}

-(void)loginWithName:(NSString *)name Password:(NSString *)password {
    NSString* loginUrl = BASE_URL((NSInteger)SERVICE_USER_LOGIN);
    return [self POST:loginUrl Params:@{@"userName":name,@"userPassword":password} Success:^(id responseObject) {
        if([responseObject[@"Result"] integerValue] == 0) {
            eBooksUserInfo::sharedInstance()->setUserName([responseObject[@"_userName"] UTF8String]);
            eBooksUserInfo::sharedInstance()->setUserAge((int)[responseObject[@"_userAge"] integerValue]);
            eBooksUserInfo::sharedInstance()->setUserID((int)[responseObject[@"_userID"] integerValue]);
            eBooksUserInfo::sharedInstance()->setUserBirthday([responseObject[@"_userBirthday"] isEqual:[NSNull null]] ? "" : [responseObject[@"_userBirthday"] UTF8String]);
            eBooksUserInfo::sharedInstance()->setUserPhone([responseObject[@"_userCellPhone"] isEqual:[NSNull null]] ? "" : [responseObject[@"_userCellPhone"] UTF8String]);
            eBooksUserInfo::sharedInstance()->setConstellation([responseObject[@"_userConstellation"] isEqual:[NSNull null]] ? "" : [responseObject[@"_userConstellation"] UTF8String]);
            eBooksUserInfo::sharedInstance()->setUserDescription([responseObject[@"_userDescription"] isEqual:[NSNull null]] ? "" : [responseObject[@"_userDescription"] UTF8String]);
            eBooksUserInfo::sharedInstance()->setUserGender([responseObject[@"_userGender"] isEqualToString:@"男"] ? true : false);
            eBooksUserInfo::sharedInstance()->setUserMessage([responseObject[@"_userMessage"] isEqual:[NSNull null]] ? "" : [responseObject[@"_userMessage"] UTF8String]);
            eBooksUserInfo::sharedInstance()->setNickName([responseObject[@"_uesrNickName"] isEqual:[NSNull null]] ? "" : [responseObject[@"_userNickName"] UTF8String]);
            eBooksUserInfo::sharedInstance()->setProfesstion([responseObject[@"_userProfession"] isEqual:[NSNull null]] ? "" : [responseObject[@"_userProfession"] UTF8String]);
            eBooksUserInfo::sharedInstance()->setUserMail([responseObject[@"_userMail"] isEqual:[NSNull null]] ? "" : [responseObject[@"_userMail"] UTF8String]);
            if(![responseObject[@"_userHeaderImage"] isEqual:[NSNull null]])
                eBooksUserInfo::sharedInstance()->setUserHeaderImage([responseObject[@"_userHeaderImage"] UTF8String]);
            eBooksUserInfo::sharedInstance()->changeLoginState(true);
            
            [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"userPassword"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:EBOOKS_NOTIFICATION_LOGIN_SUCCESS object:nil userInfo:nil];
        }else {
            eBooksUserInfo::sharedInstance()->changeLoginState(false);
            [[NSNotificationCenter defaultCenter] postNotificationName:EBOOKS_NOTIFICATION_USERNAME_OR_PASSWORD_INVALID object:nil userInfo:nil];
        }
    } Failure:^(NSError *error) {
        eBooksUserInfo::sharedInstance()->changeLoginState(false);
        [[NSNotificationCenter defaultCenter] postNotificationName:EBOOKS_NOTIFICATION_LOGIN_FAILURE object:nil userInfo:nil];
        return ;
    }];
}

-(unsigned long long)getFileSize:(NSString*)filePath {
    unsigned long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager new]; // default is not thread safe
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:filePath error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}

-(void)startDownloadWithBookInfo:(eBooksSingleBookDetailInfo *)bookDetailInfo {
    NSString* downloadDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",eBooksUserInfo::sharedInstance()->getUserID()]];
    if(![[NSFileManager defaultManager] fileExistsAtPath:downloadDir])
        [[NSFileManager defaultManager] createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString* downloadUrl = [NSString stringWithUTF8String:bookDetailInfo->getBookDownloadUrl().c_str()];
    NSURLRequest* downloadRequest = [NSURLRequest requestWithURL:FILE_URL(downloadUrl)];
    if([[NSFileManager defaultManager] fileExistsAtPath:downloadDir]) {
        unsigned long long downloadFileSize = [self getFileSize:downloadDir];
        NSMutableURLRequest* mutableRequest = [downloadRequest mutableCopy];
        NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-", downloadFileSize];
        [mutableRequest setValue:requestRange forHTTPHeaderField:@"Range"];
        downloadRequest = [mutableRequest copy];
    }
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:downloadRequest];
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDownloadTask* downloadTask = [manager downloadTaskWithRequest:downloadRequest progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL* fileUrl = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [fileUrl URLByAppendingPathComponent:[NSString stringWithFormat:@"%d/%@.pdf",eBooksUserInfo::sharedInstance()->getUserID(),[NSString stringWithUTF8String:bookDetailInfo->getBookTitle().c_str()]]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        if(!error)
            NSLog(@"%@",filePath);
        return ;
    }];
    
    [downloadTask resume];
    return ;
}

-(void)pauseDownload {
    return ;
}

-(void)stopDownload {
    return ;
}

@end
