//
//  NSString+AES.h
//  SimpleSDK
//
//  Created by XYL on 2021/12/7.
//

#import <Foundation/Foundation.h>

@interface NSString (AES)

/**< 加密方法 */
- (NSString*)aci_encryptWithAEKey:(NSString *)aes_key AES_IV_PARAMETER:(NSString *)ivStr;
/**< 加密方法 */
- (NSString*)aci_encryptWithAES;
-(NSString *)HexStringWithData:(NSData *)data;
/**< 解密方法 */
- (NSString*)aci_decryptWithAES;
- (NSString*)Aci_decryptWithAES:(NSString *)tsstr;


/**
 *  加密
 *
 *  @param string   需要加密的String
 *  @param keyAndIv key和iv都用同一的16位 （服务器商量，必须是16位  例如"1234567812345678"）
 *                  key是公钥，iv是偏移量
 *  @return 加密后的字符串
 */
- (NSString *)AES128CBC_PKCS5Padding_EncryptStrig:(NSString *)string keyAndIv:(NSString *)keyAndIv;
/**
 *  加密
 *
 *  @param string 需要加密的string
 *  @param key    公钥
 *  @param iv     偏移量
 *
 *  @return 加密后的字符串
 */
- (NSString *)AES128CBC_PKCS5Padding_EncryptStrig:(NSString *)string key:(NSString*)key iv:(NSString *)iv;
/**
 *  解密
 *
 *  @param string   加密的string
 *  @param keyAndIv key和iv
 *
 *  @return  解密后的内容
 */
- (NSString *)AES128CBC_PKCS5Padding_DecryptString:(NSString *)string keyAndIv:(NSString *)keyAndIv;
/**
 *  解密
 *
 *  @param string 加密的字符串
 *  @param key    钥匙（公钥）
 *  @param iv     偏移量
 *
 *  @return 解密后的内容
 */
- (NSString *)AES128CBC_PKCS5Padding_DecryptString:(NSString *)string key:(NSString *)key iv:(NSString *)iv;


@end

