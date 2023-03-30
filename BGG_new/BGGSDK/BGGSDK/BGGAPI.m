//
//  BGGAPI.m
//  BGGSDK
//
//  Created by lisheng on 2021/5/24.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGAPI.h"
#import "BGGHTTPRequest.h"
#import "BGGDataModel.h"
#import "BGGLogionView.h"
#import "NSObject+BGGHUD.h"
#import "BGGDragButton.h"
#import "BGGMenuView.h"
#import "BGGWKWebview.h"
#import "BGGAntiAddictionView.h"
#import "BGGDeviceInfo.h"
#import "BGGAppStoreManager.h"
#import "BGGAutoLoginView.h"
#import "BGGAccountLoginView.h"
#import "BGGNoticeView.h"
#import "BGGUpdateNoticeView.h"
#import "BGGPMStatusView.h"
#import "SaveInKeyChain.h"
#import "BGGPrivacyView.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <NetworkExtension/NetworkExtension.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreLocation/CoreLocation.h>
#import <AppTrackingTransparency/ATTrackingManager.h>
#import "APPNETReachability.h"
static BGGAPI * _bggApi;
@interface BGGAPI()<UIDragButtonDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong)CLLocationManager *locationManager;
@property(strong,nonatomic)BGGLogionView *lgView;
@property(strong,nonatomic)BGGAutoLoginView *autoLogin;
@property(strong,nonatomic)BGGAccountLoginView *accountLogin;
@property(strong,nonatomic)BGGMenuView *menuView;
@property(strong,nonatomic)BGGDragButton *button;
@property(strong,nonatomic)BGGDeviceInfo *deviceInfo;
@property(strong,nonatomic)BGGPrivacyView *privacyView;
@property (nonatomic, strong) NSTimer *NetTimer;
@end


@implementation BGGAPI
+ (BGGAPI *)sharedAPIManeger{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bggApi = [[self alloc] init];
    });
    return _bggApi;
}
-(instancetype)init{
    self= [super init];
    if (self) {
        self.button = [[BGGDragButton alloc] init];
        self.button.btnDelegate = self;
        self.button.window.hidden = YES;
        //先给一个默认地址
        [BGGDataModel sharedInstance].provinces = @"广东省";
        [BGGDataModel sharedInstance].city = @"广州市";
        [BGGDataModel sharedInstance].viewArray =  [NSMutableArray array];
        [BGGDataModel sharedInstance].popViewArray = [NSMutableArray array];
        [self addObservers];
    }
    return self;
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIApplicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    // Refresh...
  
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {


        }];
    }
    
}

- (void)UIApplicationWillEnterForeground:(NSNotification *)notification {
    // Refresh...
   
    if ([BGGDataModel sharedInstance].isPaying) {
        [BGGDataModel sharedInstance].isPaying = false;
        [self hideNotice];
        [self showPMStatus:2];
    }
}


-(void)setHideDragBtn:(BOOL)hideDragBtn{
    
    if ([BGGDataModel sharedInstance].iosAuditStatus == 1) {//审核中，隐藏掉
        self.button.window.hidden = YES;
        self.button.alpha = 1;
        [self.button.window resignKeyWindow];
        return;
    }
    
    _hideDragBtn = hideDragBtn;
    if ([[BGGDataModel sharedInstance].floatWindowsStatus isEqualToString:@"1"]) {
        if (_hideDragBtn) {
            self.button.window.hidden = YES;
            self.button.alpha = 1;
            [self.button.window resignKeyWindow];
        }else{
            self.button.window.hidden = NO;
            self.button.alpha = 0.5;
        }
    }else{
        self.button.window.hidden = YES;
        self.button.alpha = 1;
        [self.button.window resignKeyWindow];
    }
}

#pragma mark - ==== UIDragButtonDelegate ====
- (void)dragButtonClicked:(UIButton *)sender {
    self.hideDragBtn = YES;
    [self presentMenuView];
}
#pragma mark - ==== 点击悬浮球 ====
-(void)presentMenuView{
    

    if ([BGGDataModel sharedInstance].viewArray.count) {
        BGGMainBaseView *baseView = (BGGMainBaseView *)[[BGGDataModel sharedInstance].viewArray lastObject];
       // [[BGGDataModel sharedInstance].viewArray removeAllObjects];
        self.menuView = [[BGGMenuView alloc] initWithFrame:KBGGMenuRect];
        self.menuView.center = [self getPopControllerCenter];
        [self.menuView pushToView:self.menuView currentView:baseView];
        [self dealMenuAnimate:self.menuView];
    }else{
        self.menuView = [[BGGMenuView alloc] initWithFrame:KBGGMenuRect];
        self.menuView.hidden = NO;
        [[BGGDataModel sharedInstance].viewArray addObject:self.menuView];
          SYPopupController *popupController =  [SYPopupController popupControllerWithMaskType:syPopupMaskTypeClear];
          popupController.layoutType = syPopupLayoutTypeCenter;
          [popupController presentContentView:self.menuView duration:0.25 springAnimated:NO];
          popupController.dismissOnMaskTouched = NO;
          popupController.popupView.backgroundColor = [UIColor clearColor];
          [BGGDataModel sharedInstance].popupController = popupController;
        [self dealMenuAnimate:self.menuView];
      }
}
#pragma mark - ==== 处理菜单的动画 ====
-(void)dealMenuAnimate:(UIView *)view{
    
    CGRect btnRect = self.button.window.frame;
    CGAffineTransform smaller = CGAffineTransformMakeScale(0.1, 0.1);//比例缩放
    CGAffineTransform moveUp;
    CGFloat btnCenterX = btnRect.origin.x + btnRect.size.width/2.0;
    CGFloat btnCenterY = btnRect.origin.y + btnRect.size.height/2.0;
    if (IsPortrait) {
        view.center = [self getPopControllerCenter];
        if (btnCenterX < SCREEN_WIDTH/2.0 && btnCenterY < SCREEN_HEIGHT/2.0) {//左上角
             view.frame = CGRectMake(20, btnRect.origin.y, view.frame.size.width, view.frame.size.height);
             moveUp = CGAffineTransformMakeTranslation(-(view.frame.size.width/2-btnCenterX),-view.frame.size.height/2);//平移
         }else if (btnCenterX < SCREEN_WIDTH/2.0 && btnCenterY > SCREEN_HEIGHT/2.0){//左下角
             view.frame = CGRectMake(20, btnRect.origin.y-view.frame.size.height, view.frame.size.width, view.frame.size.height);
             moveUp = CGAffineTransformMakeTranslation(-(view.frame.size.width/2-btnCenterX),view.frame.size.height/2);//平移
         }else if (btnCenterX > SCREEN_WIDTH/2.0 && btnCenterY < SCREEN_HEIGHT/2.0){//右上角
             view.frame = CGRectMake(20, btnRect.origin.y, view.frame.size.width, view.frame.size.height);
             moveUp = CGAffineTransformMakeTranslation(btnCenterX -view.frame.size.width/2,-view.frame.size.height/2);//平移
         }else{//右下角
             view.frame = CGRectMake(20, btnRect.origin.y- view.frame.size.height, view.frame.size.width, view.frame.size.height);
             moveUp = CGAffineTransformMakeTranslation(btnCenterX -view.frame.size.width/2,view.frame.size.height/2);//平移
         }
        
    }else{
       if (btnCenterX < SCREEN_WIDTH/2.0 && btnCenterY < SCREEN_HEIGHT/2.0) {//左上角
           
           double Y;
           
           if (btnRect.origin.y >0) {
               Y = (btnRect.origin.y + view.frame.size.height ) < SCREEN_HEIGHT ? btnRect.origin.y : (SCREEN_HEIGHT - view.frame.size.height - 10);
           }else{
               Y = btnRect.origin.y+30;
           }
           
            view.frame = CGRectMake(btnCenterX + 30, Y, view.frame.size.width, view.frame.size.height);
            moveUp = CGAffineTransformMakeTranslation(-view.frame.size.width/2,-view.frame.size.height/2);//平移
        }else if (btnCenterX < SCREEN_WIDTH/2.0 && btnCenterY > SCREEN_HEIGHT/2.0){//左下角
            CGFloat y = btnRect.origin.y- view.frame.size.height;
            view.frame = CGRectMake(btnCenterX + 30, y>0 ? y:10, view.frame.size.width, view.frame.size.height);
            moveUp = CGAffineTransformMakeTranslation(-view.frame.size.width/2,view.frame.size.height/2);//平移
        }else if (btnCenterX > SCREEN_WIDTH/2.0 && btnCenterY < SCREEN_HEIGHT/2.0){//右上角
            double Y;
            
            if (btnRect.origin.y >0) {
                Y = (btnRect.origin.y + view.frame.size.height ) < SCREEN_HEIGHT ? btnRect.origin.y : (SCREEN_HEIGHT - view.frame.size.height - 10);
            }else{
                Y = btnRect.origin.y+30;
            }
            
            view.frame = CGRectMake(btnCenterX -view.frame.size.width-30, Y, view.frame.size.width, view.frame.size.height);
            moveUp = CGAffineTransformMakeTranslation(view.frame.size.width/2,-view.frame.size.height/2);//平移
        }else{//右下角
            CGFloat y = btnRect.origin.y- view.frame.size.height;
            view.frame = CGRectMake(btnCenterX -view.frame.size.width-30, y>0 ? y:10, view.frame.size.width, view.frame.size.height);
            moveUp = CGAffineTransformMakeTranslation(view.frame.size.width/2,view.frame.size.height/2);//平移
        }
    }
    
    CGAffineTransform cat = CGAffineTransformConcat(smaller, moveUp);//合并两个矩阵变换
    self.menuView.transform = cat;//设置_imageView的仿射变换
    self.menuView.alpha = 0;//透明度
    CGAffineTransform larger = CGAffineTransformMakeScale(1, 1);//放大
       self.menuView.hidden = NO;//显示视图
        [UIView animateWithDuration:0.8 animations:^{
            self.menuView.transform = larger;
            self.menuView.alpha = 1;

        }];
}

#pragma mark - === 获取Wi-Fi名称mac等信息需要获取定位权限 再初始化 ===

- (void)BGGLocation
{
    BOOL enable = [CLLocationManager locationServicesEnabled];
    NSInteger state = [CLLocationManager authorizationStatus];
    
    if (!enable || 2 > state) {// 尚未授权位置权限
        if (8 <= [[UIDevice currentDevice].systemVersion floatValue]) {
          
            // 系统位置权限授权弹窗
            self.locationManager=[[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            [self.locationManager requestAlwaysAuthorization];
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    else {
        if (state == kCLAuthorizationStatusAuthorizedWhenInUse || state == kCLAuthorizationStatusAuthorizedAlways) {

        }
//        [self BGGInitAction];
        [self BGGAttracking];
    }
}

#pragma mark - === 定位权限delegate ===

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    //允许定位权限
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self BGGAttracking];//        [self BGGInitAction];
       
    }
    //拒绝定位权限
    if (status == kCLAuthorizationStatusDenied) {

//        [self BGGInitAction];

        dispatch_async(dispatch_get_main_queue(), ^{
            //在主线程刷新
            [self BGGAttracking];
        });
    }
    //尚未授权定位权限
    if (status == kCLAuthorizationStatusNotDetermined) {

    }

}

#pragma mark - === 初始化 ===

- (void)BGGAttracking
{
    
    if (true) {
        [self BGGInitAction];
        return;
    }
    
    int64_t delayInSeconds = 1;      // 延迟的时间
    /*
     *@parameter 1,时间参照，从此刻开始计时
     *@parameter 2,延时多久，此处为秒级，还有纳秒等。10ull * NSEC_PER_MSEC
     */
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
         // do something
        
        if (@available(iOS 14, *)) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //在主线程刷新
                    [self BGGInitAction];
                });
                
                // Here we get the result of the dialog
                // If `requestTrackingAuthorizationWithCompletionHandler` was called twice, the completion handler will be called twice, but will show the dialog on the first time.
                // On the second time this method is called the completion handler will be called with the value returned by `trackingAuthorizationStatus`
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                //在主线程刷新
                [self BGGInitAction];
            });
            // Fallback on earlier versions
        }
    });
    
    
}

-(void)BGGInit{
   
//    [self BGGAttracking];
    
    BOOL isConnetion = [self Method_ActionIsReachabilityForInternetConnection];
    if(isConnetion){
        if(self.NetTimer){
            self.NetTimer = nil;
        }
        
        [self BGGLocation];
    }else{
        self.NetTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(BGGInit) userInfo:nil repeats:NO];
        if(![NSThread isMainThread]){
            [[NSRunLoop currentRunLoop] run];
        }
    }
    
    
}
- (BOOL)Method_ActionIsReachabilityForInternetConnection {
    APPNETReachability *reach = [APPNETReachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    BOOL isConnect = status == NotReachable ? NO : YES;
    return isConnect;
}
- (void)BGGInitAction
{
    [BGGDataModel sharedInstance].isShowingRealName = NO;
    [BGGDataModel sharedInstance].bggInit = NO;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BGGConfig" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    [BGGDataModel sharedInstance].gameVersion = dictionary[@"gameVersion"];
    [BGGDataModel sharedInstance].appNumber = dictionary[@"appNumber"];
    [BGGDataModel sharedInstance].channelNumber = dictionary[@"channelNumber"];
    [BGGDataModel sharedInstance].number = dictionary[@"number"];
    [BGGDataModel sharedInstance].teamCompanyNumber = dictionary[@"teamCompanyNumber"];
    [BGGHTTPRequest BGGLocationsuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        if (returnCode == 0) {
            
            [self getConfig];
            [self BGGOpenGameUpLoad];

        }else{
            [self getConfig];
            [self BGGOpenGameUpLoad];

        }
    } failBlock:^(NSError *error) {
        [self getConfig];
        [self BGGOpenGameUpLoad];

    }];
}


#pragma mark - === 用户打开游戏 ===
-(void)BGGOpenGameUpLoad{
    
    [BGGHTTPRequest BGGOpenGameUpLoadsuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        if (returnCode == 0) {
             
        }else{
            [self popNotice:returnMsg];
        }
    } failBlock:^(NSError *error) {

    }];
}
#pragma mark - === 初始化获取游戏配置 ===
-(void)getConfig{
    [BGGHTTPRequest BGGGetGameConfigsuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        
        
        
        if (returnCode == 0) {
            NSDictionary *dic = data[@"game"];
            [BGGDataModel sharedInstance].bggInit = YES;
            

         //   iosAuditStatus 1:审核中 2:非审核
            [BGGDataModel sharedInstance].iosAuditStatus = [[dic objectForKey:@"iosAuditStatus"] intValue];
            [BGGDataModel sharedInstance].realNameType = [[dic objectForKey:@"realNameType"] stringValue];
            [BGGDataModel sharedInstance].forceRealName = [[dic objectForKey:@"forceRealName"] boolValue];
            [BGGDataModel sharedInstance].bindMobileType = [[dic objectForKey:@"bindMobileType"] stringValue];
            [BGGDataModel sharedInstance].floatWindowsStatus = [[dic objectForKey:@"floatWindowsStatus"] stringValue];
            [BGGDataModel sharedInstance].reportEvent = [dic objectForKey:@"reportEvent"];
            [BGGDataModel sharedInstance].cutLoginStatus = [[dic objectForKey:@"cutLoginStatus"] stringValue];
            [BGGDataModel sharedInstance].h5GameUrl = [dic objectForKey:@"h5GameUrl"];
            [BGGDataModel sharedInstance].customerUrl = [dic objectForKey:@"customerUrl"];
            [BGGDataModel sharedInstance].privacyUrl = [dic objectForKey:@"privacyUrl"];
            [BGGDataModel sharedInstance].noticeUrl = [dic objectForKey:@"noticeUrl"];
            [BGGDataModel sharedInstance].floatWindowsVoList =[dic objectForKey:@"floatWindowsVoList"];

            [BGGDataModel sharedInstance].heartInterval = [NSNumber numberWithInteger: [[dic objectForKey:@"heartInterval"] integerValue]];
            [self gameVersionControl];
            [[NSNotificationCenter defaultCenter] postNotificationName:BGGInitNotify object:BGGSuccessResult userInfo:nil];
            if ([BGGDataModel sharedInstance].noticeUrl.length) {
                [self popGameNoticeView];
            }else{
                //初始化成功之后弹出隐私协议的框
                [self popPrivacy];
              
            }
           
            
            
            
        }else{
            [self popNotice:returnMsg];
        }
    } failBlock:^(NSError *error) {

    }];

}

#pragma mark -=== 隐私协议版本 ===-
- (BOOL)isNewPrivacyVersion:(NSString *)newVersion
{
    if ([newVersion isEqualToString:@"0"]) {
        return NO;
    }
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"privacyVersion"];
    if (version.length > 0) {
        if ([version integerValue] >= [newVersion integerValue]) {
            return NO;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:newVersion forKey:@"privacyVersion"];
    return YES;
}

#pragma mark - === 初始化成功之后弹出隐私协议的框 ===
-(void)popPrivacy{

    [BGGHTTPRequest BGGPrivacysuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        if(returnCode == 0){
            NSDictionary *dic = data;
            NSString *title = [dic objectForKey:@"title"];
            NSString *content = [dic objectForKey:@"content"];
            
            if ([self isNewPrivacyVersion:[NSString stringWithFormat:@"%@",[dic objectForKey:@"version"]]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 主线程更新
                    BGGPrivacyView *privacyView = [[BGGPrivacyView alloc]initWithFrame:KBGGPrivacyRect title:title content:content];
                    privacyView.agreeBlock = ^{

                    };
                    [self BGGPresentView:privacyView];
                });
                
            }
            
        }else{
            [self popNotice:returnMsg];
        }
        
    } failBlock:^(NSError *error) {
        
    }];
    
    
}
#pragma mark - === 初始化弹出公告 ===
-(void)popGameNoticeView{
    BGGNoticeView *weView = [[BGGNoticeView alloc]initWithFrame:KBGGGongGaoRect];
    weView.webUrl = [BGGDataModel sharedInstance].noticeUrl;
    [self  BGGPresentView:weView];
    weView.rightBtnClickBlock = ^(BGGMainBaseView * _Nonnull keyboardView, UIButton * _Nonnull button) {
        [self popPrivacy];
        
    };
}
#pragma mark - ====登录====
-(void)BGGLogin{
    if (![BGGDataModel sharedInstance].bggInit) {
        [self popNotice:@"请先初始化"];
        return;
    }
    

//    if (![BGGDataModel sharedInstance].accountArray.count) {
//         if ([SaveInKeyChain load:@"BGGAccount"] && [SaveInKeyChain load:@"BGGPassword"]){
//            [BGGDataModel sharedInstance].autoLogin = YES;
//        }
//    }
    self.hideDragBtn = YES;
    if ([BGGDataModel sharedInstance].autoLogin) {
        [self BggAutoLogin];
     }else{
         [self normalLogin];
     }
}
#pragma mark - ====正常登录====
-(void)normalLogin{
    if ([BGGDataModel sharedInstance].viewArray.count) {
        BGGMainBaseView *baseView = (BGGMainBaseView *)[[BGGDataModel sharedInstance].viewArray lastObject];
        //[[BGGDataModel sharedInstance].viewArray removeAllObjects];
        self.lgView = [[BGGLogionView alloc] initWithFrame:KBGGLoginRect];
        self.lgView.center = [self getPopControllerCenter];
        [self.lgView pushToView:self.lgView currentView:baseView];
    }else{
        self.lgView = [[BGGLogionView alloc] initWithFrame:KBGGLoginRect];
        [self BGGPresentView:self.lgView];
        [self.lgView checkIFAccountLogin];
    }
    
//    self.lgView = [[BGGLogionView alloc] initWithFrame:KBGGLoginRect];
//    [self  BGGPresentView:self.lgView];
}
#pragma mark - ====自动登录====
-(void)BggAutoLogin{
  
    [self popLoadingView:@"登陆中..."];
    NSString *account;
    NSString *pwd ;
    
//    if ([BGGDataModel sharedInstance].accountArray.count) {
//       account = [[BGGDataModel sharedInstance].accountArray firstObject][@"account"];
//       pwd = [[BGGDataModel sharedInstance].accountArray firstObject][@"password"];
//    }else{
//        account = [SaveInKeyChain load:@"BGGAccount"];
//        pwd = [SaveInKeyChain load:@"BGGPassword"];
//    }
    if ([BGGDataModel sharedInstance].accountArray.count) {
       account = [[BGGDataModel sharedInstance].accountArray firstObject][@"account"];
       pwd = [[BGGDataModel sharedInstance].accountArray firstObject][@"password"];
    }
    [BGGHTTPRequest BGGAccountPasswordLoginWithAccount:account password:pwd SsuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        NSDictionary *dic = data;
        [self hideNotice];
        if (returnCode == 0) {
            self.autoLogin = [[BGGAutoLoginView alloc] initWithFrame:KBGGAutoLoginRect];
            [self BGGAutoLogin:self.autoLogin];
            [[BGGDataModel sharedInstance] insertDataWithAccount:account andPassword:pwd];
            [BGGAPI sharedAPIManeger].hideDragBtn = NO;
            [BGGDataModel sharedInstance].sdkUserToken = [dic objectForKey:@"token"];
            [BGGDataModel sharedInstance].mobile = [dic objectForKey:@"mobile"];
            [BGGDataModel sharedInstance].userName = [dic objectForKey:@"userName"];
            [BGGDataModel sharedInstance].nickName = [dic objectForKey:@"nickName"];
            [BGGDataModel sharedInstance].isLogin = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:BGGLoginNotify object:BGGSuccessResult userInfo:@{@"token": [BGGDataModel sharedInstance].sdkUserToken}];
            [[BGGDataModel sharedInstance] getUserInfoByToken];
            
            self.autoLogin.account = account;
           
            
            [BGGDataModel sharedInstance].isBind = [[dic objectForKey:@"isBind"] boolValue];
            [BGGDataModel sharedInstance].isRealName = [[dic objectForKey:@"isRealName"] boolValue];
            [BGGDataModel sharedInstance].forceRealName = [[dic objectForKey:@"forceRealName"] boolValue];
            [BGGDataModel sharedInstance].forceBindPhone = [[dic objectForKey:@"forceBindPhone"] boolValue];
            
            [self performSelector:@selector(showPopView) withObject:nil afterDelay:4.5];
            //登录成功后进行心跳检测
           
            [self performSelector:@selector(heartBeat) withObject:nil afterDelay: [[BGGDataModel sharedInstance].heartInterval intValue]*60];
       
            SYWeakObject(self);
            self.autoLogin.qieHuanBlock = ^{
                [[BGGDataModel sharedInstance] stopHeartBeat];
                [BGGDataModel sharedInstance].autoLogin = NO;
                weak_self.accountLogin = [[BGGAccountLoginView alloc] initWithFrame:KBGGLoginRect];
                [weak_self BGGPresentView:weak_self.accountLogin];
            };
           
        }else{
            [BGGDataModel sharedInstance].autoLogin = NO;
            [self hideNotice];
            [self popNotice:returnMsg];
            [self BGGDismiss];
            [self BGGLogin];
            
            
        }
    } failBlock:^(NSError *error) {
        [self BGGDismiss];
      
    }];

}
#pragma mark - ==== 心跳检测 ====
-(void)heartBeat{
    [[BGGDataModel sharedInstance] stopHeartBeat];
    [[BGGDataModel sharedInstance] heartBeatTest];
}
#pragma mark - ==== 游戏版本控制 ====
-(void)gameVersionControl{
    [BGGHTTPRequest BGGGameVersionCOntrolWithSDKVersion:@"1" gameVersion:[BGGDeviceInfo softwareVersion] successBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        NSDictionary *dic = data;
        
         if (returnCode == 0) {
             [self updatePopView:dic];
         }else{
             [self popNotice:returnMsg];
         }
     } failBlock:^(NSError *error) {

     }];
}
#pragma mark - ==== 更新提示弹窗 ====
-(void)updatePopView:(NSDictionary *)dic{
    if (![[dic objectForKey:@"downloadUrl"] isEqual:[NSNull null]]) {
        BGGUpdateNoticeView *updateView = [[BGGUpdateNoticeView alloc]initWithFrame:KBGGLoginRect];
        [self  BGGPresentView:updateView];
        updateView.dic = dic;
        updateView.rightBtnClickBlock = ^(BGGMainBaseView * _Nonnull keyboardView, UIButton * _Nonnull button) {
           
        };
    }
}

#pragma mark - ==== 处理弹框 ====
-(void)showPopView{
    [[BGGDataModel sharedInstance] dealPopViewIsExistAfterLogin];
    [[BGGDataModel sharedInstance] showPoviewAfterLogin];
}

#pragma mark - ==== 支付 ====
-(void)BGGPM:(BGGPMData *)PMData{
    
    if (![BGGDataModel sharedInstance].isLogin) {
        [self popNotice:@"请先登录"];
        return;
    }
    [self popLoadingView:@"购买中..."];
    //补发货
    [[BGGDataModel sharedInstance] appleResendGoods];
    [BGGHTTPRequest BGGCreateOrderWith:PMData successBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        if (returnCode == 0) {
            self.hideDragBtn = YES;
            NSDictionary *dic = data;
            //测试
            
          //  1:切 2：不切（苹果支付）
            if ([[dic objectForKey:@"cutPayStatus"] integerValue] == 1) {
                BGGWKWebview *weView = [[BGGWKWebview alloc]initWithFrame:KBGGRuleRect];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"amount"] = [NSNumber numberWithInteger:PMData.pm];
                dict[@"orderNumber"] = [dic objectForKey:@"orderNumber"];
                [BGGDataModel sharedInstance].orderNumber = [dic objectForKey:@"orderNumber"];
                dict[@"token"] = [BGGDataModel sharedInstance].sdkUserToken;
                dict[@"deviceType"] = @"Ios";
                dict[@"app_name"] = [BGGDeviceInfo displayName];
                dict[@"package_name"] = [BGGDeviceInfo bundleIdentifier];
                weView.paramDic = dict;
                weView.webUrl = [dic objectForKey:@"payUrl"];
                weView.isPM = YES;
                [self  BGGPresentView:weView];

            }else{;
                [[BGGAppStoreManager shareDcGamePayMannger] startPayWithID:PMData.appStoreProductId completeHandle:^(DCApplePayType type, NSData *data, NSString *transactionId) {
                    [BGGAPI sharedAPIManeger].hideDragBtn = NO;
                    if (type == DCApplePaySuccess) {
                        [[BGGDataModel sharedInstance] saveApplePMWithRecordNumber:[dic objectForKey:@"orderNumber"] appStorePriceNumber:PMData.appStoreProductId tranNum:transactionId receipt:[data base64EncodedStringWithOptions:0]];
                        [[BGGDataModel sharedInstance] appleSendGoodsWithRecordNumber:[dic objectForKey:@"orderNumber"] appStorePriceNumber:PMData.appStoreProductId tranNum:transactionId receipt:[data base64EncodedStringWithOptions:0]];
                        
                    }else{
                        [self popNotice:@"支付失败"];
                    }
                  
                }];

            }
        }else if(returnCode ==1003){
            self.hideDragBtn = YES;
            BGGAntiAddictionView *addictionView = [[BGGAntiAddictionView alloc] initWithFrame:KBGGNoticeRect];
            addictionView.msg = returnMsg;
            if ([BGGDataModel sharedInstance].isRealName) {
                addictionView.isKnowm = YES;
            }else{
                addictionView.isKnowm = NO;
            }
            
            [self BGGPresentView:addictionView];
            [self hideNotice];
        }else{
            [self popNotice:returnMsg];
        }
    } failBlock:^(NSError *error) {

    }];
}
#pragma mark - ==== 上传角色数据 ====
-(void)BGGUploadRoleData:(BGGRoleData *)roleData{

   [BGGHTTPRequest BGGUploadRoleDataWith:roleData SsuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        if (returnCode == 0) {
          
          
        }else{
            [self popNotice:returnMsg];
        }
    } failBlock:^(NSError *error) {
        
    }];
    
  
}
#pragma mark - ==== 注销 ====
-(void)BGGSDKLogout{
    [BGGHTTPRequest BGGSDKLogoutSsuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        if (returnCode == 0) {
            [[BGGDataModel sharedInstance] stopHeartBeat];
            [BGGAPI sharedAPIManeger].hideDragBtn = YES; 
            self.accountLogin = [[BGGAccountLoginView alloc] initWithFrame:KBGGLoginRect];
            [self BGGPresentView:self.accountLogin];
            [BGGDataModel sharedInstance].isLogin = NO;
            [BGGDataModel sharedInstance].autoLogin = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:BGGLogoutNotify object:BGGSuccessResult userInfo:nil];
        }else{
            [self popNotice:returnMsg];
        }
    } failBlock:^(NSError *error) {
        
    }];
}

-(void)BGGAutoLogin:(UIView *)endView{
    endView.hidden = NO;
    [[BGGDataModel sharedInstance].viewArray addObject:endView];
    SYPopupController *popupController =  [SYPopupController popupControllerWithMaskType:syPopupMaskTypeClear];
    popupController.layoutType = syPopupLayoutTypeTop;
    [BGGDataModel sharedInstance].popupController = popupController;
    [popupController presentContentView:endView duration:1 springAnimated:NO inView:nil displayTime:1.2];
    [[BGGDataModel sharedInstance].viewArray removeObject:endView];
    if (KIsIphone_X_series && IsPortrait ) {
        endView.center =  CGPointMake([BGGDataModel sharedInstance].popupController.popupView.frame.size.width/2.0,30 + 45 );
    }else{
        endView.center =  CGPointMake([BGGDataModel sharedInstance].popupController.popupView.frame.size.width/2.0,40 );
    }
    
      popupController.dismissOnMaskTouched = NO;
      popupController.popupView.backgroundColor = [UIColor clearColor];
}
-(void)BGGPresentView:(BGGMainBaseView *)endView{
    if ([BGGDataModel sharedInstance].viewArray.count) {
        BGGMainBaseView *baseView = (BGGMainBaseView *)[[BGGDataModel sharedInstance].viewArray lastObject];
        endView.center = [self getPopControllerCenter];
        [endView pushToView:endView currentView:baseView];
    }else{
        endView.hidden = NO;
        [[BGGDataModel sharedInstance].viewArray addObject:endView];
          endView.center = [self getPopControllerCenter];
          SYPopupController *popupController =  [SYPopupController popupControllerWithMaskType:syPopupMaskTypeBlackBlur];
          popupController.layoutType = syPopupLayoutTypeCenter;
          [popupController presentContentView:endView duration:0.25 springAnimated:NO];
          popupController.dismissOnMaskTouched = NO;
          popupController.popupView.backgroundColor = [UIColor clearColor];
          [BGGDataModel sharedInstance].popupController = popupController;
    }
    

}

- (void)BGGDismiss
{
    [[BGGDataModel sharedInstance].viewArray removeAllObjects];
    [[BGGDataModel sharedInstance].popupController dismiss];
}
- (CGPoint)getPopControllerCenter{
    CGPoint point = CGPointMake([BGGDataModel sharedInstance].popupController.popupView.frame.size.width/2.0, [BGGDataModel sharedInstance].popupController.popupView.frame.size.height/2.0);
    return point;
}

#pragma mark - ==== APP跳转处理 ====
-(BOOL)handleApplication:(UIApplication *)application
                 openURL:(NSURL *)url
       sourceApplication:(NSString *)sourceApplication
               annotation:(id)annotation{
    
    [BGGDataModel sharedInstance].isPaying = false;
    
    if ([[url absoluteString] containsString:@"qingin.cn"]) {
        [self showPMStatus:1];
    }
    if ([[url absoluteString] containsString:[[NSBundle mainBundle] bundleIdentifier]]) {
        [self showPMStatus:2];
    }
    
    return YES;
}
#pragma mark - ==== 获取PM状态 ====
-(void)showPMStatus:(NSInteger)type{
    
   NSDictionary *pmStatusDic = @{@"1":@"未支付",@"2":@"支付中",@"3":@"第三方处理中",@"4":@"支付成功",@"5":@"到账成功",@"6":@"支付超时",@"7":@"支付失败",@"8":@"关闭支付"};
    if (type == 1) {
        [BGGHTTPRequest BGGPM1WithRecordNUmber:[BGGDataModel sharedInstance].orderNumber successBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
            if (returnCode == 0) {
                NSDictionary *dic = data;
                NSString *orderNumber = [dic objectForKey:@"payRecordNumber"];
                NSString *stuStr =  [pmStatusDic objectForKey:[[dic objectForKey:@"status"] stringValue]];
        
                
                if ([[[dic objectForKey:@"status"] stringValue] isEqualToString:@"4"]) {
                    [self popNotice:@"支付成功"];
                }else{
                    BGGPMStatusView *statusView = [[BGGPMStatusView alloc]initWithFrame:KBGGLoginRect];
                    statusView.pmType = type;
                    [BGGAPI sharedAPIManeger].hideDragBtn = YES;
                    [self  BGGPresentView:statusView];
                    statusView.statuLab.text = [NSString stringWithFormat:@"支付状态:%@",stuStr];
                    statusView.orderNumLab.text = [NSString stringWithFormat:@"订单号:%@",orderNumber];
                }
                
                
            }else{
                [self popNotice:returnMsg];
            }
        } failBlock:^(NSError *error) {
            
        }];
    }else{
        [BGGHTTPRequest BGGPM2WithRecordNUmber:[BGGDataModel sharedInstance].orderNumber successBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
            if (returnCode == 0) {
                NSDictionary *dic = data;
                NSString *orderNumber = [dic objectForKey:@"payRecordNumber"];
                NSString *stuStr =  [pmStatusDic objectForKey:[[dic objectForKey:@"status"] stringValue]];

        
                
                if ([[[dic objectForKey:@"status"] stringValue] isEqualToString:@"4"]) {
                    [self popNotice:@"支付成功"];
                }else{
                    BGGPMStatusView *statusView = [[BGGPMStatusView alloc]initWithFrame:KBGGLoginRect];
                    statusView.pmType = type;
                    [BGGAPI sharedAPIManeger].hideDragBtn = YES;
                    [self  BGGPresentView:statusView];
                    statusView.statuLab.text = [NSString stringWithFormat:@"支付状态:%@",stuStr];
                    statusView.orderNumLab.text = [NSString stringWithFormat:@"订单号:%@",orderNumber];
                }
                
            }else{
                [self popNotice:returnMsg];
            }
        } failBlock:^(NSError *error) {
            
        }];
    }
}
@end
