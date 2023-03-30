//
//  BGGDataModel.m
//  BGGSDK
//
//  Created by lisheng on 2021/5/25.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGDataModel.h"
#import "BGGHTTPRequest.h"
#import "BGGPCH.h"
#import "BGGAntiAddictionView.h"
#import "BGGAutoLoginView.h"
#import "SaveInKeyChain.h"
#define  KDocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

static dispatch_source_t _timer;
@implementation BGGDataModel
+ (BGGDataModel *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        
    });
    
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    [self initValues];
    return self;
}

-(void)initValues{
    self.iosAuditStatus = 2;
}

- (void)setAccountArray:(NSArray *)accountArray{
    BOOL result = [NSKeyedArchiver archiveRootObject:accountArray toFile:[KDocumentPath stringByAppendingPathComponent:@"acountFile"]];
    if (result) {
      
    }else{
       
    }
}

-(NSArray *)accountArray{
    NSArray *unarchiverArr = [NSKeyedUnarchiver unarchiveObjectWithFile:[KDocumentPath stringByAppendingPathComponent:@"acountFile"]];
    return unarchiverArr;
}

-(void)setAppleArray:(NSArray *)appleArray{
    BOOL result = [NSKeyedArchiver archiveRootObject:appleArray toFile:[KDocumentPath stringByAppendingPathComponent:@"appleArray"]];
    if (result) {
      
    }else{
       
    }
}
-(NSArray *)appleArray{
    NSArray *unarchiverArr = [NSKeyedUnarchiver unarchiveObjectWithFile:[KDocumentPath stringByAppendingPathComponent:@"appleArray"]];
    return unarchiverArr;
}

-(void)setSdkUserToken:(NSString *)sdkUserToken{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:sdkUserToken forKey:@"userToken"];
    [ud synchronize];
}

-(NSString *)sdkUserToken{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:@"userToken"];
}


-(void)setAutoLogin:(BOOL)autoLogin{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:autoLogin  forKey:@"autoLogin"];
    [ud synchronize];
}
-(BOOL)autoLogin{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:@"autoLogin"];
}

-(void)setTodayDate:(NSString *)todayDate{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:todayDate forKey:@"todayDate"];
    [ud synchronize];
}
-(NSString *)todayDate{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:@"todayDate"];
}
-(void)setMobile:(NSString *)mobile{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:mobile forKey:@"mobile"];
    [ud synchronize];
}
-(NSString *)mobile{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:@"mobile"];
}
-(void)setProvinces:(NSString *)provinces{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:provinces forKey:@"provinces"];
    [ud synchronize];
}
-(NSString *)provinces{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:@"provinces"];
}
-(void)setCity:(NSString *)city{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:city forKey:@"city"];
    [ud synchronize];
}
-(NSString *)city{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:@"city"];
}
#pragma mark - ==== 根据token获取用户信息 =====
-(void)getUserInfoByToken{
    [BGGHTTPRequest BGGGetUserInfoByTokensuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        if (returnCode == 0) {
            
            NSDictionary *dic = data;
            if (!isStrEmpty([dic objectForKey:@"mobile"])) {
                [BGGDataModel sharedInstance].mobile = [dic objectForKey:@"mobile"];
            }
           
            [BGGDataModel sharedInstance].headImageUrl = [dic objectForKey:@"headUrl"];
            [BGGDataModel sharedInstance].isBind = [[dic objectForKey:@"isBind"] boolValue];
            [BGGDataModel sharedInstance].isRealName = [[dic objectForKey:@"isRealName"] boolValue];
        }else{
            
        }
    } failBlock:^(NSError *error) {
        
    }];
}
#pragma mark - ==== 心跳检测 =====
-(void)heartBeatTest{
   
    //设置时间间隔
    NSTimeInterval period = [[BGGDataModel sharedInstance].heartInterval intValue]*60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    // 事件回调
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [BGGHTTPRequest BGGHeartBeatsuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
                
                if (returnCode == 0) {
                    if ([BGGDataModel sharedInstance].iosAuditStatus == 1 || [BGGDataModel sharedInstance].isShowingRealName) {
                        return;
                    }
                    
                    NSDictionary *dic = data;
                    if ([dic[@"showBox"] boolValue]) {
                        BGGAntiAddictionView *addictionView = [[BGGAntiAddictionView alloc] initWithFrame:KBGGNoticeRect];
                        addictionView.continueGame = [dic[@"continueGame"] boolValue];
                        addictionView.msg = dic[@"realNameMsg"];
                        [BGGDataModel sharedInstance].forceRealName = [[dic objectForKey:@"forceRealName"] boolValue];
                        [BGGDataModel sharedInstance].forceBindPhone = [[dic objectForKey:@"forceBindPhone"] boolValue];
                        [self BGGPresentView:addictionView];
                    }
                   
                }else if (returnCode == 1000){
                    [[BGGAPI sharedAPIManeger] BGGSDKLogout];
                }else{
                    [self popNotice:returnMsg];
                }
            } failBlock:^(NSError *error) {
                
            }];
        });
    });
        
    // 开启定时器
    dispatch_resume(_timer);
}
#pragma mark - ==== 停止心跳检测 =====
-(void)stopHeartBeat{
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
    
}
-(void)BGGPresentView:(UIView *)endView{
    endView.hidden = NO;
    [[BGGDataModel sharedInstance].viewArray addObject:endView];
      SYPopupController *popupController =  [SYPopupController popupControllerWithMaskType:syPopupMaskTypeBlackBlur];
      popupController.layoutType = syPopupLayoutTypeCenter;
      [popupController presentContentView:endView duration:0.25 springAnimated:NO];
      popupController.dismissOnMaskTouched = NO;
//      if ([endView isKindOfClass: NSClassFromString(@"BGGSMRZView")]) {
//        popupController.dismissOnMaskTouched = YES;
//      }
      popupController.popupView.backgroundColor = [UIColor clearColor];
      [BGGDataModel sharedInstance].popupController = popupController;
}
#pragma mark - ==== 缓存登录账号 =====
-(void)insertDataWithAccount:(NSString *)account andPassword:(NSString *)password{
    //将当前登录的账号缓存到keyChain中,用于卸载重装后的自动登录
    [SaveInKeyChain save:@"BGGAccount" data:account];
    [SaveInKeyChain save:@"BGGPassword" data:password];
    
    //将账号缓存到NSUserDefault中
    NSMutableDictionary *acountdict = [NSMutableDictionary dictionary];
    acountdict[@"account"] = account;
    acountdict[@"password"] =  password;
    if (acountdict.count == 0) {
        return ;
    }
    NSMutableArray *acountArr = [NSMutableArray arrayWithArray:self.accountArray];
    if (acountArr.count == 0) {
        [acountArr addObject:acountdict];
    }
    else
    {//存在历史数据
        NSInteger index = 0;
        BOOL isContain = NO;
        for (NSInteger i = 0; i < acountArr.count; i ++) {
            //找出是否有储存相同的数据
            NSDictionary *dict = acountArr[i];
            NSString *historyAccount = dict[@"account"];
            if ([historyAccount isEqualToString:account]) {
                //有相同数据
                isContain = YES;
                index = i;
            }
        }
        
        if (isContain) {
            //删除旧数据
            [acountArr removeObjectAtIndex:index];
        }
        //插入新数据
        [acountArr insertObject:acountdict atIndex:0];
    }
    
    self.accountArray = acountArr;
    
}
#pragma mark - ==== 内购发货 =====
-(void)appleSendGoodsWithRecordNumber:(NSString *)payRecordNumber appStorePriceNumber:(NSString *)appStorePriceNumber tranNum:(NSString *)tranNum receipt:(NSString *)receipt{
    [BGGHTTPRequest BGGAppStoreWithpayRecordNumber:payRecordNumber appStorePriceNumber:appStorePriceNumber tranNum:tranNum receipt:receipt successBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        if (returnCode == 0 ) {
            NSDictionary *dict = data;
            [self hideNotice];
            if ( [[dict objectForKey:@"status"] integerValue] == 0) {
                [[BGGDataModel sharedInstance] removeApplePMDataWithRecordNumber:payRecordNumber];
                [[NSNotificationCenter defaultCenter] postNotificationName:BGGPMNotify object:BGGSuccessResult userInfo:nil];
            }
        }else{
            [self popNotice:returnMsg];
        }
    } failBlock:^(NSError *error) {
        
    }];
}
#pragma mark - ==== 缓存内购数据 =====
-(void)saveApplePMWithRecordNumber:(NSString *)payRecordNumber appStorePriceNumber:(NSString *)appStorePriceNumber tranNum:(NSString *)tranNum receipt:(NSString *)receipt{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"payRecordNumber"] = payRecordNumber;
    dict[@"appStorePriceNumber"] = appStorePriceNumber;
    dict[@"tranNum"] = tranNum;
    dict[@"receipt"] = receipt;
    if (dict.count == 0) {
        return ;
    }
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:self.appleArray];
    [dataArr addObject:dict];
    self.appleArray = dataArr;
}
#pragma mark - ==== 发货成功后清除缓存内购数据 =====
-(void)removeApplePMDataWithRecordNumber:(NSString *)payRecordNumber{
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:self.appleArray];
    if (!dataArr.count) {
        return;
    }
    [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        if ([dic[@"payRecordNumber"]  isEqualToString:payRecordNumber]) {
            [dataArr removeObject:obj];
        }
    }];
    self.appleArray = dataArr;
}
#pragma mark - ==== 内购补发货 =====
-(void)appleResendGoods{
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:self.appleArray];
    if (!dataArr.count) {
        return;
    }
    [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dict = obj;
        [self appleSendGoodsWithRecordNumber:dict[@"payRecordNumber"] appStorePriceNumber:dict[@"appStorePriceNumber"] tranNum:dict[@"tranNum"] receipt:dict[@"receipt"]];
    }];
}

#pragma mark - ==== 登录后弹窗处理 =====
-(void)dealPopViewIsExistAfterLogin{
    
    if ([BGGDataModel sharedInstance].iosAuditStatus == 1) {
        return;
    }
    
    
    //优先判断是否强制 在判断弹窗类型
    if (![BGGDataModel sharedInstance].isBind) {
        if (![[BGGDataModel sharedInstance].popViewArray containsObject:@"BGGBangDingMobileView"]) {
            if ([BGGDataModel sharedInstance].forceBindPhone) {
                NSString *className = @"BGGBangDingMobileView";
                [[BGGDataModel sharedInstance].popViewArray addObject:className];
            }else{
                if ([[BGGDataModel sharedInstance].bindMobileType isEqualToString:@"2"]) {
                    if ([self isFirstLoginToday]) {
                        NSString *className = @"BGGBangDingMobileView";
                        [[BGGDataModel sharedInstance].popViewArray addObject:className];
                    }
                }
                if ([[BGGDataModel sharedInstance].bindMobileType isEqualToString:@"3"]) {
                    NSString *className = @"BGGBangDingMobileView";
                    [[BGGDataModel sharedInstance].popViewArray addObject:className];
                }
            }
        }
        
        
    }
     if (![BGGDataModel sharedInstance].isRealName) {
         if (![[BGGDataModel sharedInstance].popViewArray containsObject:@"BGGSMRZView"]) {
             if ([BGGDataModel sharedInstance].forceRealName) {
                 NSString *className = @"BGGSMRZView";
                 [[BGGDataModel sharedInstance].popViewArray addObject:className];
             }else{
                 if ([[BGGDataModel sharedInstance].realNameType isEqualToString:@"3"]) {
                     NSString *className = @"BGGSMRZView";
                     [[BGGDataModel sharedInstance].popViewArray addObject:className];
                 }
                 if ([[BGGDataModel sharedInstance].realNameType isEqualToString:@"2"]) {
                     if ([self isFirstLoginToday]) {
                         NSString *className = @"BGGSMRZView";
                         [[BGGDataModel sharedInstance].popViewArray addObject:className];
                     }
                    
                 }
             }
         }
      
    }
}
-(void)showPoviewAfterLogin{
    if ([BGGDataModel sharedInstance].popViewArray.count && [BGGDataModel sharedInstance].isLogin) {
        [BGGAPI sharedAPIManeger].hideDragBtn = YES;
        NSString *className = [[BGGDataModel sharedInstance].popViewArray firstObject];
       
        CGRect rect ;
        if ([className isEqualToString:@"BGGSMRZView"]) {
            rect = KBGGSMRZRect;
        }else{
            rect = KBGGLoginRect;
        }
        Class objClass = NSClassFromString(className);
        UIView *popView = [objClass alloc]  ;
        popView =   [popView initWithFrame:rect];
        [self BGGPresentView:popView];
        [[BGGDataModel sharedInstance].popViewArray removeObjectAtIndex:0];
    }
}

#pragma mark - ==== 登录成功后欢迎界面 =====
-(void)welcomeGameWithAccount:(NSString *)account
{
   BGGAutoLoginView *welLoginView = [[BGGAutoLoginView alloc] initWithFrame:KBGGAutoLoginRect];
  
    welLoginView.hidden = NO;
    [[BGGDataModel sharedInstance].viewArray addObject:welLoginView];
    SYPopupController *popupController =  [SYPopupController popupControllerWithMaskType:syPopupMaskTypeClear];
    popupController.layoutType = syPopupLayoutTypeTop;
    [popupController presentContentView:welLoginView duration:0.8 springAnimated:NO inView:nil displayTime:1];
    [[BGGDataModel sharedInstance].viewArray removeObject:welLoginView];
    if (KIsIphone_X_series && IsPortrait ) {
        welLoginView.center =  CGPointMake([BGGDataModel sharedInstance].popupController.popupView.frame.size.width/2.0,30 + 45 );
    }else{
        welLoginView.center =  CGPointMake([BGGDataModel sharedInstance].popupController.popupView.frame.size.width/2.0,40 );
    }
    
      popupController.dismissOnMaskTouched = NO;
      popupController.popupView.backgroundColor = [UIColor clearColor];
      [BGGDataModel sharedInstance].popupController = popupController;
    welLoginView.account = account;
}



@end
