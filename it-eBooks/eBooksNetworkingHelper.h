//
//  eBooksNetworkingHelper.h
//  it-eBooks
//
//  Created by 王落凡 on 15/10/4.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import <Foundation/Foundation.h>
class eBooksSingleBookDetailInfo;

typedef void(^ResponseSuccessBlock)(id responseObject);
typedef void(^ResponseFailureBlock) (NSError* error);

@interface eBooksNetworkingHelper : NSObject {
    NSMutableArray* downloadTaskingsArray;
}

+(eBooksNetworkingHelper*)getSharedInstance;
-(void)GET:(NSInteger)serviceType Params:(NSDictionary*)params Success:(ResponseSuccessBlock)success Failure:(ResponseFailureBlock)failure;
-(void)POST:(NSString*)urlString Params:(NSDictionary*)params Success:(ResponseSuccessBlock)success Failure:(ResponseFailureBlock)failure;
-(void)UPLOADImageWithParams:(NSDictionary *)params Success:(ResponseSuccessBlock)success Failure:(ResponseFailureBlock)failure;
-(void)loginWithName:(NSString*)name Password:(NSString*)password;
-(void)startDownloadWithBookInfo:(eBooksSingleBookDetailInfo*)bookDetailInfo;
-(void)pauseDownload;
-(void)stopDownload;

@end
