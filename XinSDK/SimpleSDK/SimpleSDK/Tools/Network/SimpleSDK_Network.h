//
//  SimpleSDK_Network.h
//  SimpleSDK
//
//  Created by XYL on 2021/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimpleSDK_Network : NSObject

+ (instancetype)manager;



//网络请求
+(void)func_request:(NSString *)url  params:(NSDictionary *) params FuncBlock:(void(^)(BOOL status, NSString *msg, NSDictionary *data))block;

//特殊网络请求
+(void)func_requestGetAttributionWithToken:(NSString *)token FuncBlock:(void(^)(BOOL status, NSString *msg, NSDictionary *data))block;
@end

NS_ASSUME_NONNULL_END
