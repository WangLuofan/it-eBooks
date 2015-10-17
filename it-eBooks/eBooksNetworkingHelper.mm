//
//  eBooksNetworkingHelper.m
//  it-eBooks
//
//  Created by 王落凡 on 15/10/4.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import "eBooksNetworkingHelper.h"
#import <AFNetworking.h>

#include "eBooksUserInfo.hpp"

static eBooksNetworkingHelper* networkingHelper;

@implementation eBooksNetworkingHelper

+(eBooksNetworkingHelper *)getSharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(networkingHelper == nil) {
            networkingHelper = [[eBooksNetworkingHelper alloc] init];
        }
    });
    
    return networkingHelper;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if(operationQueue == nil) {
            operationQueue = [[NSOperationQueue alloc] init];
        }
    }
    return self;
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

-(void)loginWithName:(NSString *)name Password:(NSString *)password {
    NSString* loginUrl = BASE_URL((NSInteger)SERVICE_USER_LOGIN);
    return [self POST:loginUrl Params:@{@"userName":name,@"userPassword":password} Success:^(id responseObject) {
        if([responseObject[@"Result"] integerValue] == 0) {
            eBooksUserInfo::sharedInstance()->setUserName([responseObject[@"_userName"] UTF8String]);
            eBooksUserInfo::sharedInstance()->setUserAge((int)[responseObject[@"_userAge"] integerValue]);
            eBooksUserInfo::sharedInstance()->setUserBirthday([[responseObject[@"_userBirthday"] substringWithRange:NSMakeRange(0, 10)] UTF8String]);
            eBooksUserInfo::sharedInstance()->setUserPhone([responseObject[@"_userCellPhone"] UTF8String]);
            eBooksUserInfo::sharedInstance()->setConstellation([responseObject[@"_userConstellation"] UTF8String]);
            eBooksUserInfo::sharedInstance()->setUserDescription([responseObject[@"_userDescription"] UTF8String]);
            eBooksUserInfo::sharedInstance()->setUserGender([responseObject[@"_userGender"] isEqualToString:@"男"] ? true : false);
            eBooksUserInfo::sharedInstance()->setUserMessage([responseObject[@"_userMessage"] UTF8String]);
            eBooksUserInfo::sharedInstance()->setNickName([responseObject[@"_userNickName"] UTF8String]);
            eBooksUserInfo::sharedInstance()->setProfesstion([responseObject[@"_userProfession"] UTF8String]);
            eBooksUserInfo::sharedInstance()->setUserMail([responseObject[@"_userMail"] UTF8String]);
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

-(void)cancel {
    [operationQueue cancelAllOperations];
    return ;
}

@end
