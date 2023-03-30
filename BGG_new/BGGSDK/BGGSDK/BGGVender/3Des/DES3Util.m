//
//  DES3Util.m
//  DES
//
//  Created by Toni on 12-12-27.
//  Copyright (c) 2012年 sinofreely. All rights reserved.
//

#import "DES3Util.h"
#define gkey            @"app_key_ioved1cm!@#$5678"
//#define gkey            @"liuyunqiang@lx100$#365#$"
#define gIv             @"01234567"


@implementation DES3Util


 const Byte iv[] = {1,2,3,4,5,6,7,8};

//Des加密
 +(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
 {
    
     NSString *ciphertext = nil;
     NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
     NSUInteger dataLength = [textData length];
     unsigned char buffer[1024];
     memset(buffer, 0, sizeof(char));
     size_t numBytesEncrypted = 0;
//     CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
//                                                kCCOptionECBMode|kCCOptionPKCS7Padding,
//                                              [key UTF8String], kCCKeySizeDES,
//                                                            iv,
//                                                [textData bytes], dataLength,
//                                                        buffer, 1024,
//                                                    &numBytesEncrypted);
     
     CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                                    kCCOptionPKCS7Padding,
                                                  [key UTF8String], kCCKeySizeDES,
                                                                iv,
                                                    [textData bytes], dataLength,
                                                            buffer, 1024,
                                                        &numBytesEncrypted);
         if (cryptStatus == kCCSuccess) {
                 NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
                 ciphertext = [GTMBase64 stringByEncodingData:data];
             }
         return ciphertext;
     }



//Des解密
 +(NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key
 {
     NSString *plaintext = nil;
     NSData *cipherdata = [GTMBase64 decodeString:cipherText];
     unsigned char buffer[1024];
     memset(buffer, 0, sizeof(char));
     size_t numBytesDecrypted = 0;
     NSString *initVec = @"p2p_s2iv";
     const void *vinitVec = (const void *) [initVec UTF8String];
     CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithm3DES,
                                           kCCOptionPKCS7Padding|kCCOptionECBMode,
                                           [key UTF8String], kCCKeySize3DES,
                                           vinitVec,
                                           [cipherdata bytes], [cipherdata length],
                                           buffer, 1024,
                                           &numBytesDecrypted);
     if(cryptStatus == kCCSuccess)
     {
         NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
         plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
     }
     return plaintext;
 }

+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key {
    
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    NSString *initVec = @"p2p_s2iv";
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [initVec UTF8String];
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding|kCCOptionECBMode,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding]
        ;
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return result;
    
}


@end
