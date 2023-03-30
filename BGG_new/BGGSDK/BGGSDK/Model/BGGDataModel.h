//
//  BGGDataModel.h
//  BGGSDK
//
//  Created by lisheng on 2021/5/25.
//  Copyright © 2021 BGG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYPopupController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BGGDataModel : NSObject

@property(nonatomic,assign)BOOL isLogin;
@property(nonatomic,assign)BOOL autoLogin;
@property(nonatomic,assign)BOOL bggInit;
@property(nonatomic,strong)NSString *gameVersion;
@property(nonatomic,assign)int iosAuditStatus; //1:审核中 2:非审核
@property(nonatomic,strong)NSString *realNameMsg; //防沉迷弹窗的提示信息
@property(nonatomic,strong)NSString *appNumber;
@property(nonatomic,strong)NSString *channelNumber;
@property(nonatomic,strong)NSString *number;
@property(nonatomic,strong)NSString *teamCompanyNumber;
@property(nonatomic,strong)NSString *todayDate; // 今天日期的字符串
@property(nonatomic,strong)NSString *sdkUserToken;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)NSString *headImageUrl;
@property(nonatomic,strong)NSNumber *heartInterval;
@property(nonatomic,assign)BOOL isRealName;
@property(nonatomic,assign)BOOL isBind;
@property(nonatomic,strong)NSString *passWord;
@property(nonatomic,strong)NSString *realNameType;//1:关闭提示 2:当天首次登录提示 3:每次登录提示
@property(nonatomic,strong)NSString *floatWindowsStatus;//浮窗状态 1:显示 2：隐藏
@property(nonatomic,assign)BOOL forceRealName;//是否强制实名 1是 2否
@property(nonatomic,assign)BOOL forceBindPhone;//是否强制实名 1是 2否
@property(nonatomic,strong)NSString *reportEvent;// 是否上报广告系统 1：上报 2：不上报
@property(nonatomic,strong)NSString *cutLoginStatus;//是否切登录 1：是 2：否
@property(nonatomic,strong)NSString *h5GameUrl;//H5game地址
@property(nonatomic,strong)NSString *customerUrl;//客服地址
@property(nonatomic,strong)NSString *privacyUrl;// 隐私地址
@property(nonatomic,strong)NSString *noticeUrl;//初始化成功之后弹出公告
@property(nonatomic,strong)NSString *bindMobileType;//1:关闭提示 2:当天首次登录提示 3:每次登录提示
@property(nonatomic,strong)NSArray *floatWindowsVoList;
@property (nonatomic,strong) NSMutableArray *viewArray;
@property(nonatomic,strong)NSMutableArray *popViewArray;
@property(nonatomic,strong)NSArray *accountArray;
@property(nonatomic,strong)NSArray *appleArray;//存储内购信息用于补发货
@property(nonatomic,strong)NSString *provinces;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *timeZone;
@property(nonatomic,strong)NSString *orderNumber;
@property(nonatomic,assign)BOOL isShowingRealName;

@property(nonatomic,assign)BOOL isPaying;
@property(strong,nonatomic) SYPopupController *popupController;
+ (BGGDataModel *)sharedInstance;


-(void)getUserInfoByToken;
-(void)heartBeatTest;
-(void)stopHeartBeat;
-(void)BGGPresentView:(UIView *)endView;
-(void)insertDataWithAccount:(NSString *)account andPassword:(NSString *)password;
-(void)appleSendGoodsWithRecordNumber:(NSString *)payRecordNumber appStorePriceNumber:(NSString *)appStorePriceNumber tranNum:(NSString *)tranNum receipt:(NSString *)receipt;
-(void)appleResendGoods;
-(void)saveApplePMWithRecordNumber:(NSString *)payRecordNumber appStorePriceNumber:(NSString *)appStorePriceNumber tranNum:(NSString *)tranNum receipt:(NSString *)receipt;
-(void)removeApplePMDataWithRecordNumber:(NSString *)payRecordNumber;
-(void)dealPopViewIsExistAfterLogin; //登录后处理各种弹窗是否存在
-(void)showPoviewAfterLogin;//展示各种弹窗(登录之后)

-(void)welcomeGameWithAccount:(NSString *)account;//登录成功之后展示欢迎界面

@end

NS_ASSUME_NONNULL_END
