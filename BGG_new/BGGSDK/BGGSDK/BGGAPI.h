//
//  BGGAPI.h
//  BGGSDK
//
//  Created by lisheng on 2021/5/24.
//  Copyright © 2021 BGG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BGGRoleData.h"
#import "BGGPMData.h"
NS_ASSUME_NONNULL_BEGIN

@interface BGGAPI : NSObject

@property (nonatomic,assign)BOOL isTest;

/**
  手机登录到验证码界面显示手机号
 */
@property (nonatomic, copy) NSString *phoneNumStr;

/**
 *  是否隐藏悬浮按钮，默认显示
 */
@property (nonatomic,assign) BOOL hideDragBtn;

/**
 *  初始化
 
 *  @return 返回单例对象
 */
+ (BGGAPI *)sharedAPIManeger;

-(void)BGGInit;

-(void)BGGLogin;

-(void)BGGPM:(BGGPMData *)PMData;

-(void)BGGSDKLogout;

-(void)BGGUploadRoleData:(BGGRoleData *)roleData;

-(void)BGGDismiss;

/**
 *APP跳转处理
 */
-(BOOL)handleApplication:(UIApplication *)application
                  openURL:(NSURL *)url
        sourceApplication:(NSString *)sourceApplication
               annotation:(id)annotation;

@end

NS_ASSUME_NONNULL_END
