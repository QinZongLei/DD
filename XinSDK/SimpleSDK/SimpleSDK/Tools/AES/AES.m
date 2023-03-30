//
//  AES.m
//  SimpleSDK
//
//  Created by mac on 2021/12/14.
//

#import "AES.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
#import <iconv.h>

@implementation AES
#pragma mark - AES加密
+ (NSString *)AES128_Decrypt:(NSString *)key encryptString:(NSString *)encryptText giv:(NSString *)gIv{
    //    字符串 ->UTF-8 ->NSData -> AES加密 ->NSData密 ->16进制字符串
        NSData *data = [encryptText dataUsingEncoding:NSUTF8StringEncoding];
        
        NSData * encryData = [self AES128_Encrypt:key encryptData:data giv:gIv];
    //    NSString *output = [encryData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        NSString *output = [self HexStringWithData:encryData];
        return output;
}

+ (NSData *)AES128_Encrypt:(NSString *)key encryptData:(NSData *)data giv:(NSString *)gIv{
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    char ivPtr[kCCKeySizeAES128+1];
    bzero(ivPtr, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];

    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytes:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

+(NSString *)HexStringWithData:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1){
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else{
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    hexStr = [hexStr uppercaseString];
    return hexStr;
}

+ (NSString *)AES128_Encrypt:(NSString *)key encryptString:(NSString *)encryptText giv:(NSString *)gIv{
    //   NSData *data = [[NSData alloc] initWithBase64EncodedString:encryptText options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *data = [self convertHexStrToData:encryptText];
        
    //    NSData *data = [encryptText dataUsingEncoding:NSUTF8StringEncoding];
        NSData * encryptData =  [self AES128_Decrypt:key encryptData:data giv:gIv];
        NSString *output = [[NSString alloc] initWithData:encryptData encoding:NSUTF8StringEncoding];

        return output;
}

//AES128解密data(带自定义向量)
+ (NSData *)AES128_Decrypt:(NSString *)key encryptData:(NSData *)data giv:(NSString *)gIv{
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCKeySizeAES128+1];
    bzero(ivPtr, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        
       return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

+ (NSData *)convertHexStrToData:(NSString *)str
{    if (!str || [str length] == 0) {
    
       return nil;
    
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];    NSRange range;    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }    return hexData;
}

@end
