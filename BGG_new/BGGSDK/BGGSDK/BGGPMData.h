//
//  BGGPMData.h
//  BGGSDK
//
//  Created by 李胜 on 2021/5/27.
//  Copyright © 2021 BGG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGGPMData : NSObject
/**
 CP订单号
 */
@property (nonatomic,strong)NSString *CPOrderId;
/**
 服务器ID
 */
@property (nonatomic,strong)NSString *serverId;
/**
 服务器名称
 */
@property (nonatomic,strong)NSString *serverName;
/**
 角色ID
 */
@property (nonatomic,strong)NSString  *roleId;
/**
 角色名称
 */
@property (nonatomic,strong)NSString  *roleName;
/**
 角色等级
 */
@property (nonatomic,assign)NSInteger  roleLevel;
/**
 透传参数,该参数会原样返回给 CP 服务端
 */
@property (nonatomic,strong)NSString  *dext;
/**
 兑换比例
 */
@property (nonatomic,strong)NSString  *dradio;
/**
 商品单位 如：元宝
 */
@property (nonatomic,strong)NSString  *dunit;
/**
 支付金额单位为(分)（除苹果之外必传）
 */
@property (nonatomic,assign)NSInteger  pm;
/**
 苹果产品编号
 */
@property (nonatomic,strong)NSString  *appStoreProductId;
@end

NS_ASSUME_NONNULL_END
