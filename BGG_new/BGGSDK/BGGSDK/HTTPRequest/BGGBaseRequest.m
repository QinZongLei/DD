//
//  BaseRequest.m
//  LoveAngel
//
//  Created by 黄晓丹 on 2016/12/23.
//  Copyright © 2016年 lianchuan. All rights reserved.
//

#import "BGGBaseRequest.h"
#import "DES3Util.h"
#import "RSAUtil.h"
#import "BGGDataModel.h"
#import "BGGPCH.h"
#import <AdSupport/AdSupport.h>
#import "SYAFNetworkReachabilityManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>





static NSString *RSA_Public_key = @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAjo6TPIBt3KVqV9AkawzL97m36HuZAy2iwle6xtxtC6EqFozc1nu+mLRRMck6fqq4BdTSSYOnPOKfZwV4SU6ts7PlJq/ASXvdmUC8EXhXQuMYUJDIaVqGBu/M1IOJp4QMjUJ7aebEnLl/HSPmvxfTAAjnY6YZGX2hGXKs7/lH319hlJMC3Thb9vn07ksJlSWU0xnNuy/bjjvMvusSq2pV3+sdF47CqS7urC5WaoYZAhWCCbeaVdN/YA64cyGL2HhpVt6KraD9/JVB+xC5HMePPATk5xWQJ1xjEqITAJe2AJdl9LyoViqqzWpOyvrfZmElZ7NjGsISMRUM/nGdCFVpDwIDAQAB";

@implementation BGGBaseRequest
{
    NSString *DESKEY;
}
+ (instancetype)request{
    return [[self alloc] init];
}

+ (BGGBaseRequest *)sharedManager
{
    static BGGBaseRequest *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];

    });

    return sharedAccountManagerInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        SYAFHTTPSessionManager *manager = [SYAFHTTPSessionManager manager];
        
//        NSMutableSet *set = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
//        [set addObject:@"text/html"];
//         [set addObject:@"text/plain"];
//        [set addObject:@"text/javascript"];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
       
       [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        /*
        SYAFSecurityPolicy * securityPolicy = [SYAFSecurityPolicy policyWithPinningMode:SYAFSSLPinningModeCertificate];
        
        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
        //如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = NO;
        
        //validatesDomainName 是否需要验证域名，默认为YES；
        //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
        //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        //如置为NO，建议自己添加对应域名的校验逻辑。
        securityPolicy.validatesDomainName = YES;
        
        //validatesCertificateChain 是否验证整个证书链，默认为YES
        //设置为YES，会将服务器返回的Trust Object上的证书链与本地导入的证书进行对比，这就意味着，假如你的证书链是这样的：
        //GeoTrust Global CA
        //    Google Internet Authority G2
        //        *.google.com
        //那么，除了导入*.google.com之外，还需要导入证书链上所有的CA证书（GeoTrust Global CA, Google Internet Authority G2）；
        //如是自建证书的时候，可以设置为YES，增强安全性；假如是信任的CA所签发的证书，则建议关闭该验证，因为整个证书链一一比对是完全没有必要（请查看源代码）；
//        securityPolicy.validatesCertificateChain = NO;

        
        manager.securityPolicy = securityPolicy;
         */
        manager.securityPolicy.allowInvalidCertificates = YES; // not recommended for production
        [manager.securityPolicy setValidatesDomainName:NO];

        
        DESKEY = [self shuffledAlphabet];
        
        DESKEY = @"abcdefghABCDEFGH";
        
       
        
        
        self.operationManager = manager;
        

        
        [self AFNetworkReachability];
    }
    return self;
}

-(void)AFNetworkReachability
{
    //1.创建网络状态监测管理者
    SYAFNetworkReachabilityManager *networkmanger = [SYAFNetworkReachabilityManager sharedManager];
    [networkmanger startMonitoring];
    //2.监听改变
    [networkmanger setReachabilityStatusChangeBlock:^(SYAFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown          = -1,
         AFNetworkReachabilityStatusNotReachable     = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        self.networkStatus = status;
        switch (status) {
            case SYAFNetworkReachabilityStatusUnknown:
//                DLog(@"未知");
                break;
            case SYAFNetworkReachabilityStatusNotReachable:
//                DLog(@"没有网络");
                break;
            case SYAFNetworkReachabilityStatusReachableViaWWAN:
//                DLog(@"3G|4G");
                break;
            case SYAFNetworkReachabilityStatusReachableViaWiFi:
//                DLog(@"WiFi");
                break;
            default:
                break;
        }
    }];
}
#pragma mark - GET请求
- (void)GET:(NSString *)URLString
parameters:(id)parameters
success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure
{
    
    SYAFHTTPSessionManager *manager = [SYAFHTTPSessionManager manager];
    
//        NSMutableSet *set = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
//        [set addObject:@"text/html"];
//         [set addObject:@"text/plain"];
//        [set addObject:@"text/javascript"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
   
   [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer = [SYAFHTTPResponseSerializer serializer];
//        manager.responseSerializer.acceptableContentTypes = set;
    self.task = [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *responseData = (NSData *)error.userInfo[SYAFNetworkingOperationFailingURLResponseDataErrorKey];
       
        if (responseData) {
//            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];

        }
        failure(task,error);
    }];
}
#pragma mark - POST请求
-(void)BBGPOST:(NSString *)URLString
   parameters:(id)parameters
      success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
      failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure
{
       //[self.operationManager.requestSerializer setValue:@"0" forHTTPHeaderField:@"bg-enrc"];
      NSDictionary *dataDict = [self configHTTPParam:parameters];
    
    self.operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    NSMutableURLRequest *request = [[SYAFJSONRequestSerializer serializer] requestWithMethod:@"POST"URLString:URLString parameters:nil error:nil];
    if ([BGGDataModel sharedInstance].sdkUserToken.length) {
        [request setValue:[BGGDataModel sharedInstance].sdkUserToken forHTTPHeaderField:@"token"];
    }
    [request setValue:@"1" forHTTPHeaderField:@"bg-enrc"];
    [request addValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    NSData *body = [[self dictionaryToJson:dataDict] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:body];
   
    
    [[self.operationManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            
            
            NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                               NSString *signEncrypt = [responseObject objectForKey:@"k"];
                               NSString *dataEncryp = [responseObject objectForKey:@"v"];
            
           
        
                              
                                   NSString *sign = [RSAUtil decryptString:signEncrypt publicKey:RSA_Public_key];
            
            NSString *data = [self aesDecrypt:dataEncryp key:sign];
            
            dataDict = [NSMutableDictionary dictionaryWithDictionary:[self sy_dictionaryWithJSON:data]];
            
            NSInteger  returnCode = [[dataDict objectForKey:@"code"] integerValue];
            if (returnCode == 1000 ) {
                [BGGDataModel sharedInstance].isLogin = NO;
                [BGGDataModel sharedInstance].sdkUserToken = @"";
                [BGGDataModel sharedInstance].autoLogin = NO;
                [[BGGDataModel sharedInstance] stopHeartBeat];
                [[NSNotificationCenter defaultCenter] postNotificationName:BGGLogoutNotify object:BGGSuccessResult userInfo:nil];
            }
             success(nil,dataDict);
        }else{
          
                
                if ([self firstLoadApp]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:BGGInitNotify object:BGGFailResult userInfo:nil];
                }
                
            }
            failure(nil,error);
        
       
    }] resume];
 
    

    
}
#pragma mark - === 判断是否第一次安装该应用 ===
-(BOOL)firstLoadApp{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:identifier]){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:identifier];
        
        return YES;
        }else{
            return  NO;
        }
}
//重新请求TOKEN

- (void)requestToken:(NSURLSessionDataTask *)task{
    
}

/**
 * AES加密
 */
-(NSString *)aesEncrypt:(NSString *)sourceStr{
     if (!sourceStr) {
            return nil;
        }
        char keyPtr[kCCKeySizeAES256 + 1];
        bzero(keyPtr, sizeof(keyPtr));
        [DESKEY getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
         void const *initVectorBytes = [@"HGFEDCBAhgfedcba" dataUsingEncoding:NSUTF8StringEncoding].bytes;
        NSData *sourceData = [sourceStr dataUsingEncoding:NSUTF8StringEncoding];
        NSUInteger dataLength = [sourceData length];
        size_t buffersize = dataLength + kCCBlockSizeAES128;
        void *buffer = malloc(buffersize);
        size_t numBytesEncrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding , keyPtr, kCCBlockSizeAES128, initVectorBytes  , [sourceData bytes], dataLength, buffer, buffersize, &numBytesEncrypted);
         
        if (cryptStatus == kCCSuccess) {
            NSData *encryptData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
            //对加密后的二进制数据进行base64转码
            return [encryptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        } else {
            free(buffer);
            return nil;
        }
    
}

/**
 * AES解密。
 */
-(NSString *)aesDecrypt:(NSString *)secretStr key:(NSString *)key{
     if (!secretStr) {
            return nil;
        }
        //先对加密的字符串进行base64解码
        NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:secretStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
         
        char keyPtr[kCCKeySizeAES256 + 1];
        bzero(keyPtr, sizeof(keyPtr));
        [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSString *reverStr = [self reversalString:key];
         void const *initVectorBytes = [reverStr dataUsingEncoding:NSUTF8StringEncoding].bytes;
        NSUInteger dataLength = [decodeData length];
        size_t bufferSize = dataLength + kCCBlockSizeAES128;
        void *buffer = malloc(bufferSize);
        size_t numBytesDecrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding , keyPtr, kCCBlockSizeAES128, initVectorBytes, [decodeData bytes], dataLength, buffer, bufferSize, &numBytesDecrypted);
        if (cryptStatus == kCCSuccess) {
            NSData *data = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            return result;
        } else {
            free(buffer);
            return nil;
        }
    
   
}


- (NSString *)reversalString:(NSString *)originString{
    NSString *resultStr = @"";
    for (NSInteger i = originString.length -1; i >= 0; i--) {
      NSString *indexStr = [originString substringWithRange:NSMakeRange(i, 1)];
      resultStr = [resultStr stringByAppendingString:indexStr];
    }
  return resultStr;
}

/**
 DES加密

 @param dict dict description
 @return return value description
 */
- (NSString *)DESencode:(NSDictionary *)dict
{
    
    NSString *dictJson = [self dictionaryToJson:dict];
    NSString *data = [DES3Util encryptUseDES:dictJson key:DESKEY];
    
    return data;
}

/**
 DES解密

 @param desString desString description
 @param sign sign description
 @return return value description
 */
- (NSDictionary *)DESdecrypt:(NSString *)desString sign:(NSString *)sign
{
    NSString *datastring = [DES3Util TripleDES:desString encryptOrDecrypt:kCCDecrypt key:sign];
    NSDictionary *dict;
    if (datastring) {
        dict = [self sy_dictionaryWithJSON:datastring];
    }
    return dict;
}


/**
 配置请求参数

 @param parameters parameters description
 @return return value description
 */
- (NSDictionary *)configHTTPParam:(id)parameters{
   
    NSMutableDictionary *datadict = [NSMutableDictionary dictionary];

     [datadict setValuesForKeysWithDictionary:parameters];
  
    
//    NSError *parseError = nil;
//       NSData *jsonData = [NSJSONSerialization dataWithJSONObject:datadict options:NSJSONWritingPrettyPrinted error:&parseError];
//
//       NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *jsonStr = [self dictionaryToJson:datadict];
   
    
        [datadict setDictionary:@{
                                  @"k":[RSAUtil encryptString: DESKEY publicKey:RSA_Public_key],
                                  @"v":[self aesEncrypt:jsonStr]
                                  }];
    
    
    return datadict;
}

-(NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

/**
 字典转json

 @param dic dic description
 @return return value description
 */
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 json转字典

 @param json json description
 @return return value description
 */
- (NSDictionary *)sy_dictionaryWithJSON:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}

/**
 生成16位随机字符串

 @return return value description
 */
- (NSString *)shuffledAlphabet {
    
    if (DESKEY == nil) {
        NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        
        // Get the characters into a C array for efficient shuffling
        NSUInteger numberOfCharacters = [alphabet length];
        unichar *characters = calloc(numberOfCharacters, sizeof(unichar));
        [alphabet getCharacters:characters range:NSMakeRange(0, numberOfCharacters)];
        
        // Perform a Fisher-Yates shuffle
        for (NSUInteger i = 0; i < numberOfCharacters; ++i) {
            NSUInteger j = (arc4random_uniform((float)numberOfCharacters - i) + i);
            unichar c = characters[i];
            characters[i] = characters[j];
            characters[j] = c;
        }
        
        // Turn the result back into a string
        NSString *result = [NSString stringWithCharacters:characters length:8];
        free(characters);
        DESKEY = [NSString stringWithFormat:@"%@%@",result,result];
    }
   
    return DESKEY;
}

@end
