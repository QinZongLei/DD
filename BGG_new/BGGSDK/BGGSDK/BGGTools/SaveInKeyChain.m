//
//  SaveInKeyChain.m
//  BGGSDK
//
//  Created by 李胜 on 2021/8/2.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "SaveInKeyChain.h"

@implementation SaveInKeyChain
// 获取数据

+ (NSMutableDictionary *)keychainQuery:(NSString *)key

{

    if (key) {

        return [NSMutableDictionary dictionaryWithObjectsAndKeys:

                (__bridge_transfer id)kSecClassGenericPassword, (__bridge_transfer id)kSecClass,

                key, (__bridge_transfer id)kSecAttrService,

                key, (__bridge_transfer id)kSecAttrAccount,

                (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock, (__bridge_transfer id)kSecAttrAccessible,

                nil];

    }

    return nil;

}

// 保存数据

+ (void)save:(NSString *)key data:(id)data

{

    if (key && data != nil) {

        //Get search dictionary

        NSMutableDictionary *keychainQuery = [self keychainQuery:key];

        //Delete old item before add new item

        SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);

        //Add new object to search dictionary(Attention:the data format)

        [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];

        //Add item to keychain with the search dictionary

        SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);

    }

}

 // 加载数据

+ (id)load:(NSString *)key

{

    id ret = nil;

    if (key) {

        NSMutableDictionary *keychainQuery = [self keychainQuery:key];

        //Configure the search setting

        [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];

        [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];

        CFDataRef keyData = NULL;

        if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {

            @try {

                ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];

            }

            @catch (NSException *e) {

                

            }

            @finally {}

        }

    }

    return ret;

}

// 删除数据

+ (void)delete:(NSString *)key

{

    NSMutableDictionary *keychainQuery = [self keychainQuery:key];

    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);

}
@end
