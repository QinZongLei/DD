//
//  BaseRequest.h
//  LoveAngel
//
//  Created by 黄晓丹 on 2016/12/23.
//  Copyright © 2016年 lianchuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYAFNetworking.h"

@interface BGGBaseRequest : NSObject

@property (nonatomic, strong) SYAFHTTPSessionManager* operationManager;

@property(nonatomic,strong)SYAFHTTPRequestSerializer *requestManager;

@property (strong, nonatomic) NSURLSessionDataTask *task;

@property (strong, nonatomic) NSURLSessionConfiguration *configuration;

@property (nonatomic,strong) NSString *uuid;

@property (nonatomic,assign) SYAFNetworkReachabilityStatus networkStatus;
/**
 *功能: 创建CMRequest的对象方法
 */
+ (instancetype)request;
+ (BGGBaseRequest *)sharedManager;



-(void)BBGPOST:(NSString *)URLString
   parameters:(id)parameters
      success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
      failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;



- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;
@end

