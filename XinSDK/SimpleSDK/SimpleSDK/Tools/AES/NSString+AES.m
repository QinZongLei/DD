//
//  NSString+AES.m
//  SimpleSDK
//
//  Created by XYL on 2021/12/7.
//

#import "NSString+AES.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import "NSData+AES128.h"

static NSString *const PSW_AES_KEY = @"456";
static NSString *const AES_IV_PARAMETER = @"789";
@implementation NSString (AES)

- (NSString*)aci_encryptWithAEKey:(NSString *)aes_key AES_IV_PARAMETER:(NSString *)ivStr

{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *AESData = [self AES128operation:kCCEncrypt
                                       data:data
                                        key:aes_key
                                         iv:ivStr];
    NSString *baseStr_GTM = [self encodeBase64Data:AESData];

    if (DEBUG) {
        NSString *baseStr = [AESData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSLog(@"*****************\nGTMBase:%@\n*****************", baseStr_GTM);
        NSLog(@"*****************\niOSCode:%@\n*****************", baseStr);
    }
 
    return baseStr_GTM;
    
}
- (NSString*)aci_encryptWithAES {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *AESData = [self AES128operation:kCCEncrypt
                                       data:data
                                        key:PSW_AES_KEY
                                         iv:AES_IV_PARAMETER];
    NSString *baseStr_GTM = [self encodeBase64Data:AESData];

    if (DEBUG) {
        NSString *baseStr = [AESData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSLog(@"*****************\nGTMBase:%@\n*****************", baseStr_GTM);
        NSLog(@"*****************\niOSCode:%@\n*****************", baseStr);
    }
 
    return baseStr_GTM;
}

- (NSString*)Aci_decryptWithAES:(NSString *)tsstr;{
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *baseData_GTM = [self decodeBase64Data:data];
    NSData *baseData = [[NSData alloc]initWithBase64EncodedString:self options:0];
    
    NSData *AESData_GTM = [self AES128operation:kCCDecrypt
                                           data:baseData_GTM
                                            key:tsstr
                                             iv:[self decryptWithAES:tsstr]];
    NSData *AESData = [self AES128operation:kCCDecrypt
                                       data:baseData
                                        key:tsstr
                                         iv:[self decryptWithAES:tsstr]];
    
    NSString *decStr_GTM = [[NSString alloc] initWithData:AESData_GTM encoding:NSUTF8StringEncoding];
    NSString *decStr = [[NSString alloc] initWithData:AESData encoding:NSUTF8StringEncoding];
    
    if (DEBUG) {
      NSLog(@"*****************\nGTMBase:%@\n*****************", decStr_GTM);
      NSLog(@"*****************\niOSCode:%@\n*****************", decStr);
    }
    
    return decStr;
}
- (NSString*)decryptWithAES:(NSString *)tsstr5{
    
       
 NSMutableString * string = [[NSMutableString alloc]initWithCapacity:tsstr5.length];

    int j = (int)tsstr5.length;

    for (int i = j - 1; i >= 0; i--) {

        [string appendFormat:@"%c", [tsstr5 characterAtIndex:i]];

    }
  
    return string;
    
}

- (NSString*)aci_decryptWithAES {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *baseData_GTM = [self decodeBase64Data:data];
    NSData *baseData = [[NSData alloc]initWithBase64EncodedString:self options:0];
    
    NSData *AESData_GTM = [self AES128operation:kCCDecrypt
                                           data:baseData_GTM
                                            key:PSW_AES_KEY
                                             iv:AES_IV_PARAMETER];
    NSData *AESData = [self AES128operation:kCCDecrypt
                                       data:baseData
                                        key:PSW_AES_KEY
                                         iv:AES_IV_PARAMETER];
    
    NSString *decStr_GTM = [[NSString alloc] initWithData:AESData_GTM encoding:NSUTF8StringEncoding];
    NSString *decStr = [[NSString alloc] initWithData:AESData encoding:NSUTF8StringEncoding];
    
    if (DEBUG) {
      NSLog(@"*****************\nGTMBase:%@\n*****************", decStr_GTM);
      NSLog(@"*****************\niOSCode:%@\n*****************", decStr);
    }
    
    return decStr;
}

/**
 *  AES加解密算法
 *
 *  @param operation kCCEncrypt（加密）kCCDecrypt（解密）
 *  @param data      待操作Data数据
 *  @param key       key
 *  @param iv        向量
 *
 *  @return NSString
 */
- (NSData *)AES128operation:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv {
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                            keyPtr, kCCKeySizeAES128,
                                            ivPtr,
                                            [data bytes], [data length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess) {
        if (DEBUG) {
          NSLog(@"Success");
        }
        
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
    } else {
        if (DEBUG) {
          NSLog(@"Error");
        }
    }
    
    free(buffer);
    return nil;
}

- (NSString *)AES128CBC_PKCS5Padding_EncryptStrig:(NSString *)string keyAndIv:(NSString *)keyAndIv {
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
       NSData *encryptData = [data AES128EncryptWithKey:keyAndIv iv:keyAndIv];
       NSString *encryptring =  [encryptData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
       return encryptring;
    
}

- (NSString *)AES128CBC_PKCS5Padding_EncryptStrig:(NSString *)string key:(NSString*)key iv:(NSString *)iv
{
       NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
       NSData *encryptData = [data AES128EncryptWithKey:key iv:iv];
       NSString *encryptring = [self HexStringWithData:encryptData];
//       NSString *encryptring =  [encryptData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
       return encryptring;
    
}


//加密
+ (NSString *)AES128CBC_PKCS5Padding_EncryptStrig:(NSString *)string key:(NSString*)key iv:(NSString *)iv{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [data AES128EncryptWithKey:key iv:iv];
    NSString *encryptring =  [encryptData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encryptring;
    
}


//解密
+ (NSString *)AES128CBC_PKCS5Padding_DecryptString:(NSString *)string keyAndIv:(NSString *)keyAndIv{
    
    NSData *decryptBase64data = [[NSData alloc]initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *decryptData = [decryptBase64data AES128DecryptWithKey:keyAndIv iv:keyAndIv];
    NSString *decryptString = [[NSString alloc]initWithData:decryptData encoding:NSUTF8StringEncoding];
    return decryptString;
   
}

//解密
+ (NSString *)AES128CBC_PKCS5Padding_DecryptString:(NSString *)string key:(NSString *)key iv:(NSString *)iv{
    
//    NSData *decryptBase64data = [[NSData alloc]initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *data = [self convertHexStrToData:string];
    NSData *decryptData = [data AES128DecryptWithKey:key iv:iv];
    NSString *decryptString = [[NSString alloc]initWithData:decryptData encoding:NSUTF8StringEncoding];
    return decryptString;
    
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



- (NSData *)AES128Operation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv

{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
   char keyPtr[kCCKeySizeAES128 + 1];
   
   memset(keyPtr, 0, sizeof(keyPtr));
   
   [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
   
   
   
   char ivPtr[kCCBlockSizeAES128 + 1];
   
   memset(ivPtr, 0, sizeof(ivPtr));
   
   [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
   
   
   
   NSUInteger dataLength = [self length];
   
   size_t bufferSize = dataLength + kCCBlockSizeAES128;
   
   void *buffer = malloc(bufferSize);
   
   
   
   size_t numBytesCrypted = 0;
   
   CCCryptorStatus cryptStatus = CCCrypt(operation,
                                         
                                         kCCAlgorithmAES128,
                                         
                                         kCCOptionPKCS7Padding,
                                         
                                         keyPtr,
                                         
                                         kCCBlockSizeAES128,
                                         
                                         ivPtr,
                                         
                                         [data bytes],
                                         
                                         dataLength,
                                         
                                         buffer,
                                         
                                         bufferSize,
                                         
                                         &numBytesCrypted);
   
   if (cryptStatus == kCCSuccess) {
       
       return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
       
   }
   
   free(buffer);
   
   return nil;
   
}


- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv

{
   
   return [self AES128Operation:kCCEncrypt key:key iv:iv];
   
}


- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv

{
   
   return [self AES128Operation:kCCDecrypt key:key iv:iv];
   
}
-(NSString *)HexStringWithData:(NSData *)data{
    
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



/**< GTMBase64编码 */
- (NSString*)encodeBase64Data:(NSData *)data {
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

/**< GTMBase64解码 */
- (NSData*)decodeBase64Data:(NSData *)data {
    data = [GTMBase64 decodeData:data];
    return data;
}

@end
