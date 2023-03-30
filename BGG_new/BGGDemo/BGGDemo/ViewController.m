//
//  ViewController.m
//  BGGDemo
//
//  Created by lisheng on 2021/5/24.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "ViewController.h"
#import <BGGSDK/BGGSDK.h>

@interface ViewController ()<CLLocationManagerDelegate>


@property(nonatomic,strong)UITextField *PMTextField;
@end

@implementation ViewController












- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    

    
    [self createUI];
    [self configNotify];
}
#pragma mark - ==== UI相关，可忽略 =====
-(void)createUI{
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backImage"]];
    [self.view addSubview:backImageView];
    backImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    UIButton *initBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 30, 100, 50)];
//    [initBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [initBtn setTitle:@"初始化" forState:UIControlStateNormal];
//    [self.view addSubview:initBtn];
//    [initBtn addTarget:self action:@selector(initClick) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor grayColor];
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 80, 100, 50)];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.PMTextField = [[UITextField alloc] initWithFrame:CGRectMake(250, 200, 220, 40)];
    self.PMTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.PMTextField.textAlignment = NSTextAlignmentLeft;
    self.PMTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.PMTextField.placeholder = @"请输入金额(分)";
    self.PMTextField.font =[UIFont systemFontOfSize:18];
    self.PMTextField.textColor = [UIColor blackColor];
    self.PMTextField.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.PMTextField];
   
    
    UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 130, 100, 50)];
    [payButton setTitle:@"支付" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:payButton];
    [payButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 190, 100, 50)];
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:logoutButton];
    [logoutButton addTarget:self action:@selector(logoutButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *roleButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 240, 100, 50)];
    [roleButton setTitle:@"角色事件" forState:UIControlStateNormal];
    [roleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:roleButton];
    [roleButton addTarget:self action:@selector(roleButton) forControlEvents:UIControlEventTouchUpInside];
    

}

#pragma mark - ==== 注册通知 ====
-(void)configNotify{
   
    //登录结果通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BGGLoginNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BGGLoginCallback:) name:BGGLoginNotify object:nil];
    //支付结果通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BGGPMNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BGGPMCallback:) name:BGGPMNotify object:nil];
    //悬浮球注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BGGLogoutNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BGGLogoutCallback:) name:BGGLogoutNotify object:nil];
}

#pragma mark - ==== 登录 ====
- (void)loginClick
{
    [[BGGAPI sharedAPIManeger] BGGLogin];
}
#pragma mark - ==== 支付 ====
-(void)payButtonClick{
    if (!self.PMTextField.text.length) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入金额(分)" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        [alertController dismissViewControllerAnimated:YES completion:^{
                    
        }];
        return;
    }
    BGGPMData *PMData = [[BGGPMData alloc] init];
    PMData.CPOrderId = [NSString stringWithFormat:@"123456789%@",[self getNowTimeTimestamp]];   //CP订单号
    PMData.serverId = @"1";             //服务器ID
    PMData.serverName = @"ls";          //服务器名称
    PMData.roleId = @"12345";           //角色ID
    PMData.roleName = @"lsls";          //角色名称
    PMData.roleLevel = 1;               //角色等级
    PMData.dext = @"dext";              //透传参数,该参数会原样返回给 CP 服务端
    PMData.dradio = @"10";              //兑换比例
    PMData.dunit = @"元宝";              //商品单位 如：元宝
    PMData.pm = [self.PMTextField.text integerValue];        //支付金额单位为(分)（除苹果之外必传）
    PMData.appStoreProductId = @"com.dzzml.wzjh2.60";        //苹果产品编号
    [[BGGAPI sharedAPIManeger] BGGPM:PMData];
}
-(NSString *)getNowTimeTimestamp{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
    
}
#pragma mark - ==== 注销 ====
-(void)logoutButton{
    [[BGGAPI sharedAPIManeger] BGGSDKLogout];
}
#pragma mark - ==== 上传角色数据 =====
-(void)roleButton{
    BGGRoleData *roleData = [[BGGRoleData alloc] init];
    roleData.serverId = @"1";                       //服务器ID
    roleData.serverName = @"lsServerName";          //服务器名称
    roleData.roleId = @"12345";                     //角色ID
    roleData.roleName =@"lsls";                     //角色名称
    roleData.roleLevel = 1;                         //角色等级
    roleData.roleBalance = 100;                     //角色游戏内余额
    roleData.roleVip = @"3";                        //角色内VIP
    roleData.dCountry = @"ee";                      //帮派
    roleData.dParty = @"rr";                        //公会
    roleData.roleCreateTime = @"12356984211";       //角色创建时间，从1970年到现在的时间，单位秒
    roleData.roleLevelUpTime = @"12658945469";      //角色等级变化时间，从1970年到现在的时间，单位秒
    roleData.eventType = ROLEEVENT_CREATE_ROLE;     //事件类型
    /**
    ROLEEVENT_CREATE_ROLE 创建角色
    ROLEEVENT_RNTER_GAME     进入游戏
    ROLEEVENT_ROLE_LEVELUP   角色升级
     */
    roleData.dext = @"";                            //额外信息（json字符串形式，可自定义
    [[BGGAPI sharedAPIManeger] BGGUploadRoleData:roleData];
}
#pragma mark - ==== 回调处理 =====
//登录
- (void)BGGLoginCallback:(NSNotification *)notify{
    NSDictionary *userInfo = notify.userInfo;
    if (notify.object == BGGSuccessResult) {
        //[self alertMsg:@"登录成功"];
        
       
        //登录成功
        if (userInfo) {
            NSString *token = [userInfo objectForKey:@"token"];
            NSLog(@"token:%@",token);
           
        }
    }else if (notify.object == BGGFailResult){
        //登录失败
       
    }else if (notify.object == BGGCancelResult){
       
    }
}
- (void)BGGPMCallback:(NSNotification *)notify{
    
}
//悬浮球注销通知
- (void)BGGLogoutCallback:(NSNotification *)notify{
    if (notify.object == BGGSuccessResult) {
        [self alertMsg:@"注销成功"];
      //注销成功
    }
}

-(void)alertMsg:(NSString *)msg{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    [alertController dismissViewControllerAnimated:YES completion:^{
                
    }];
}
@end
