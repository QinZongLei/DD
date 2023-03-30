//
//  ViewController.m
//  Demo
//
//  Created by CCYQ on 2021/4/19.
//

#import "ViewController.h"
#import <SimpleSDK/SimpleSDK.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)initAction:(UIButton *)sender {
    
    [[SimpleSDK_Expose sharedInstance] func_startInitWithBlock:^(BOOL status, NSString * _Nonnull msg, NSString * _Nonnull isAudit) {
           NSLog(@"---- 初始化状态 ----");
           NSLog(@"status ---- %@", [NSNumber numberWithBool:status]);
           NSLog(@"msg ------- %@", msg);
           NSLog(@"isAudit ------- %@", isAudit);
           NSLog(@"---- -------- ----");
           NSLog(@"\n\n");
       }];
}


- (IBAction)loginAction:(UIButton *)sender {
    
    [[SimpleSDK_Expose sharedInstance] func_startLoginWithBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull dicData) {
        
        NSLog(@"---- 登录状态 ----");
        NSLog(@"status ---- %@", [NSNumber numberWithBool:status]);
        NSLog(@"msg ------- %@", msg);
        NSLog(@"data ------- %@", dicData);
        NSLog(@"---- -------- ----");
        NSLog(@"\n\n");
            
        } HandleLogout:^(BOOL status, NSString * _Nonnull msg) {
            
            NSLog(@"---- 登出状态 ----");
            NSLog(@"status ---- %@", [NSNumber numberWithBool:status]);
            NSLog(@"msg ------- %@", msg);
            NSLog(@"---- -------- ----");
            NSLog(@"\n\n");
        }];
   
}

- (IBAction)uploadAction:(id)sender {
    // 创建角色上传信息
    //⚠️⚠️⚠️【注意】这里传入的参数字段和以往SDK不同，请按照Demo的参数接入
    NSMutableDictionary *mDicUserInfo = [NSMutableDictionary dictionary];
    [mDicUserInfo setValue:@"8888" forKey:@"serverId"];//服务器ID
    [mDicUserInfo setValue:@"uid8888" forKey:@"serverName"]; //服务器名称
    [mDicUserInfo setValue:@"8888" forKey:@"roleID"]; //角色ID
    [mDicUserInfo setValue:@"uid8888" forKey:@"roleName"];    //角色名字
    [mDicUserInfo setValue:@"1" forKey:@"roleLevel"];  //角色等级
    [mDicUserInfo setValue:@"1" forKey:@"payLevel"]; //VIP等级
    //roleZsLevel 是用户转生等级,cp 没传过来 就传0
    [mDicUserInfo setValue:@"0" forKey:@"roleZsLevel"];
    //额外字段
    [mDicUserInfo setValue:@"201201904029111" forKey:@"extends"];
    //roleCreatetime 是 用户创角时间
    [mDicUserInfo setValue:@"2151234" forKey:@"roleCreatetime"];
    //1 选择服务器  2 创角  3 进入游戏 4 升级
    [[SimpleSDK_Expose sharedInstance] func_startReportWithBlock:@"1" UploadDic:mDicUserInfo FuncBlock:^(BOOL status, NSString * _Nonnull msg) {
        
        NSLog(@"---- 上报信息状态 ----");
        NSLog(@"status ---- %@", [NSNumber numberWithBool:status]);
        NSLog(@"msg ------- %@", msg);
        NSLog(@"---- -------- ----");
        NSLog(@"\n\n");
        
    }];
}

- (IBAction)buyAction:(UIButton *)sender {
    NSMutableDictionary *orderParams = [NSMutableDictionary dictionary];
    [orderParams setValue:@"uid8888" forKey:@"serverName"];//区服名称
    [orderParams setValue:@"8888" forKey:@"serverId"];//区服ID
    [orderParams setValue:@"uid8888" forKey:@"roleName"]; //角色名字
    [orderParams setValue:@"888" forKey:@"roleLevel"]; //等级
    [orderParams setValue:@"8888" forKey:@"roleID"]; //角色ID
    [orderParams setValue:@"元宝" forKey:@"goodsName"];  //商品名称
    [orderParams setValue:@"com.yscqsqb.djsq_30" forKey:@"goodsID"];//内购订单id
    [orderParams setValue:[self currentTimeStr] forKey:@"cpOrder"];//订单号
    [orderParams setValue:@"30" forKey:@"cost"]; //商品金额(元)
    [orderParams setValue:@"201201904029111" forKey:@"extension"]; //额外字段(可传订单号)
    [orderParams setValue:@"" forKey:@"notifyURL"];//发货回调地址(如果发货回调地址是动态改变的必传，不是动态的可以不传，若要传必须传正确的发货回调地址，避免出现充值不到账的问题)
    [[SimpleSDK_Expose sharedInstance] func_startCreateOrderWithBlcok:orderParams FuncBlock:^(BOOL status, NSString * _Nonnull msg) {
        NSLog(@"---- 购买状态 ----");
        NSLog(@"status ---- %@", [NSNumber numberWithBool:status]);
        NSLog(@"msg ------- %@", msg);
        NSLog(@"---- -------- ----");
        NSLog(@"\n\n");
    }];
}

//获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

- (IBAction)logoutAction:(UIButton *)sender {
    [[SimpleSDK_Expose sharedInstance] func_startLogoutWithBlock:^(BOOL status, NSString * _Nonnull msg) {
        NSLog(@"---- 登出状态 ----");
        NSLog(@"status ---- %@", [NSNumber numberWithBool:status]);
        NSLog(@"msg ------- %@", msg);
        NSLog(@"---- -------- ----");
        NSLog(@"\n\n");
    }];
}


@end
