//
//  SaveInKeyChain.h
//  BGGSDK
//
//  Created by 李胜 on 2021/8/2.
//  Copyright © 2021 BGG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaveInKeyChain : NSObject
// 保存数据

+ (void)save:(NSString *)key data:(id)data;

// 加载数据

+ (id)load:(NSString *)key;

// 删除数据

+ (void)delete:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
