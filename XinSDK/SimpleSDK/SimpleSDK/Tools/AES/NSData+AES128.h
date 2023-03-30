//
//  NSData+AES123.h
//  SimpleSDK
//
//  Created by mac on 2021/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (AES128)
/**
 *  加密
 *
 *  @param key 公钥
 *  @param iv  偏移量
 *
 *  @return 加密之后的NSData
 */
- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;
/**
 *  解密
 *
 *  @param key 公钥
 *  @param iv  偏移量
 *
 *  @return 解密之后的NSData
 */
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;
@end

NS_ASSUME_NONNULL_END
