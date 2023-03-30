//
//  BGGRoleData.h
//  BGGSDK
//
//  Created by 李胜 on 2021/5/27.
//  Copyright © 2021 BGG. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 游戏角色相关事件
typedef NS_ENUM(NSInteger, BGGRoleEventType)
{
    ROLEEVENT_CREATE_ROLE = 1, 
    ROLEEVENT_ENTER_GAME,
    ROLEEVENT_ROLE_LEVELUP
};

@interface BGGRoleData : NSObject
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
 角色游戏内余额
 */
@property (nonatomic,assign)NSInteger  roleBalance;
/**
 角色内VIP
 */
@property (nonatomic,strong)NSString  *roleVip;
/**
 帮派
 */
@property (nonatomic,strong)NSString  *dCountry;
/**
 公会
 */
@property (nonatomic,strong)NSString  *dParty;
/**
角色创建时间，从1970年到现在的时间，单位秒

*/
@property (nonatomic,strong)NSString *roleCreateTime;
/**
角色等级变化时间，从1970年到现在的时间，单位秒

*/
@property (nonatomic,strong)NSString *roleLevelUpTime;
/**
 事件类型
 */
@property (nonatomic,assign)NSInteger  eventType;
/**
 额外信息（json字符串形式，可自定义）
 */
@property (nonatomic,strong)NSString  *dext;



@end

