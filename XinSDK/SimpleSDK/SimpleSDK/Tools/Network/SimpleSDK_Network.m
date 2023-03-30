//
//  SimpleSDK_Network.m
//  SimpleSDK
//
//  Created by XYL on 2021/12/7.
//

#import "SimpleSDK_Network.h"
#import "SImpleSDK_DataTools.h"
#import "SimpleSDK_Tools.h"
#import "RSA.h"

@implementation SimpleSDK_Network

static id instance = nil;

+ (instancetype)manager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self manager];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}



+ (void)func_request:(NSString *)url params:(NSDictionary *)params FuncBlock:(void (^)(BOOL, NSString * _Nonnull, NSDictionary * _Nonnull))block{
    [SimpleSDK_Network func_requestWithUrlString:url func_requestParams:params func_requestCallback:^(NSInteger resultCode, NSString * _Nonnull resultMsg, NSDictionary * _Nonnull resultData) {
        block(resultCode == 1,resultMsg,resultData);
    }];
}



+ (void)func_requestWithUrlString:(NSString *)urlString func_requestParams:(NSDictionary *)param func_requestCallback:(void(^)(NSInteger resultCode, NSString *resultMsg, NSDictionary *resultData))callback {
    
    NSString *hostUrlString = [NSString stringWithFormat:@"%@", urlString];
  
    NSMutableDictionary *hostParmas = [NSMutableDictionary dictionaryWithDictionary:param];
   
  NSString *requestBody = [SimpleSDK_Tools func_sortOfDictionary:hostParmas];
 
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:hostUrlString]];
    request.timeoutInterval = 30;
    request.HTTPMethod = @"POST";
    request.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [[NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (callback) {
                callback(error.code, error.localizedDescription, @{});
            }
        } else {
            @try {
                NSDictionary *responeDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
               
                NSString *code;
                NSString * msg;
                NSDictionary * stateDic;
                NSDictionary *resultDic;
                if (!kDictNotNull(responeDic)) {
                    stateDic=[responeDic objectForKey: @"state"];
                    code = [stateDic objectForKey: @"state"][@"code"];
                    msg = [stateDic objectForKey: @"state"][@"msg"];
                    resultDic  =[responeDic objectForKey: @"data"];
                    callback(code.integerValue,msg,resultDic);
                }else{
                    stateDic=[responeDic objectForKey: @"state"];
                    code = [stateDic objectForKey: @"code"];
                    msg = [stateDic objectForKey:@"msg"];
                    resultDic  =[responeDic objectForKey: @"data"];
                    callback(code.integerValue,msg,resultDic);
                }
                
            } @catch (NSException *exception) {
                if (callback) {
                    callback(19998, @"解密失败！", @{});
                }
                
            } @finally {
                
            }
            
        }
    }] resume];
}


+ (void)func_requestGetAttributionWithToken:(NSString *)token FuncBlock:(void (^)(BOOL, NSString * _Nonnull, NSDictionary * _Nonnull))block{
    
    static NSInteger attributionNumber = 0 ;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:(id)self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"https://api-adservices.apple.com/api/v1/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:10.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSData* postData = [(id)token dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            //如果失败循环请求
            attributionNumber ++;
            if (attributionNumber >=3) {
                
                return;
            }
            [self func_requestGetAttributionWithToken:token FuncBlock:block];
            return;
        }
        NSError *resError;
        NSMutableDictionary *resDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&resError];
        if (kDictNotNull(resDic)) {
            //回调回去
            block(YES,@"获取成功！",resDic);
        }
    }] resume];
    
}




@end
